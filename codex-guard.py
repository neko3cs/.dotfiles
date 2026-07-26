#!/usr/bin/env python3
"""Codex の PreToolUse フックとして動作する deny ガード。

権限制御は原則 execpolicy (.codex/rules/custom.rules) に寄せてある。
このスクリプトが残っているのは、execpolicy の builtin が
prefix_rule / network_rule / host_executable の3つだけで、
**位置が固定されていない語を条件にしたルールが書けない**という構造的な理由による。
prefix_rule は「コマンド + 引数の前置一致」しか書けず、途中や末尾のワイルドカードを
表現できない。ここは tool_input を文字列に潰して正規表現をかけるので位置に依存しない。

PATH_DENY (ファイルパス条件):
- 「どのコマンドであれ .env に触る」は prefix_rule では
  cat/less/head/rg... x .env/.env.local/path/to/.env の総当たりになる
- apply_patch によるファイル書き込みはシェルコマンドではなく execpolicy の管轄外

COMMAND_DENY (custom.rules の forbidden が届かない範囲):
- Codex は bash -lc "..." の中身にリダイレクト・グロブ・変数展開・制御構文が混ざると
  分解しないため、全体が1コマンド扱いになり forbidden な prefix_rule が素通りする
  (bash -lc "git push > /dev/null")。文字列としては見えるのでここで捕まえる
- gcloud / az は動詞が末尾に来る上に深さが可変で (gcloud compute instances delete /
  az storage account delete)、aws は動詞名が可変 (delete-bucket / terminate-instances)。
  いずれも prefix_rule では届かない

WRAPPED_ONLY_DENY (custom.rules の prompt が届かない範囲):
- 同じ分解漏れは prompt ルールも素通りさせる。ただしフックは ask を返せないため
  (未検証)、素のコマンドまで deny すると「確認」が「拒否」に化けてしまう。
  そこで **シェルに包まれていて、かつ分解を妨げる文字を含む** ときだけ拒否する。
  素で叩く分には従来どおり execpolicy の承認フローに乗る。
- && || ; | は Codex が分解できるので、分解を妨げる文字には数えない。

拒否は「exit 2 + stderr に理由」、それ以外は exit 0 で素通しする。
"""
import json
import re
import sys

PATH_DENY = [
    (re.compile(r"(?:^|[\s\"'=/])\.env(?:\.[\w.-]+)?(?:$|[\s\"'/])"), ".env ファイルへのアクセスは禁止されています"),
    (re.compile(r"(?:^|[\s\"'/])secrets/"), "secrets/ 配下へのアクセスは禁止されています"),
    (re.compile(r"\bcredentials\.json\b"), "credentials.json へのアクセスは禁止されています"),
]

# コマンドの先頭とみなす位置。_as_text で平坦化された文字列に対し、
# 文頭 / シェルの区切り / bash -lc・sh -c の直後だけを起点に見る。
# これを付けないと `grep mail file` や `echo git push` が誤って引っかかる。
_CMD_START = r"(?:^|(?:&&|\|\||[;|])\s*|-lc\s+|-c\s+)"

COMMAND_DENY = [
    (re.compile(_CMD_START + r"gws\b"), "gws の実行は禁止されています"),
    (re.compile(_CMD_START + r"(?:sendmail|mail)\s"), "メール送信コマンドの実行は禁止されています"),
    (re.compile(_CMD_START + r"git\s+(?:push|reset|rebase)\b"), "履歴とリモートを壊す git 操作は手動でのみ行う"),
    # aws/gcloud/az は動詞の位置が揃わないため、次の区切りまでの範囲に破壊系の語を探す。
    (re.compile(_CMD_START + r"(?:aws|gcloud|az)\b[^;&|]*\b(?:delete|destroy|terminate)"),
     "クラウドリソースの削除・破棄コマンドは手動でのみ行う"),
]

# custom.rules の prompt ルールに対応するコマンド。素で叩く分には承認フローに乗るので
# 触らず、包まれた時だけ拒否する。
WRAPPED_ONLY_DENY = re.compile(
    _CMD_START + r"(?:"
    r"terraform\s+destroy"
    r"|curl\s+(?:-\S+\s+)*-X\s+DELETE"
    r"|npm\s+publish"
    r"|npm\s+install\s+(?:-g|--global)\b"
    r"|(?:brew|winget|cargo)\s+install\b"
    r"|dotnet\s+tool\s+install\b"
    r"|(?:pnpm|uv)\s+add\b"
    r"|uv\s+pip\s+install\b"
    r"|pip3?\s+install\b"
    r")"
)

# シェルラッパー経由か。
_WRAPPER = re.compile(r"\b(?:bash|sh|zsh)\s+-(?:lc|c)\b")
# Codex が bash -lc "..." を分解しなくなる条件 (リダイレクト・変数展開・コマンド置換・
# グロブ・制御構文)。&& || ; | は分解できるので含めない。
_UNSPLITTABLE = re.compile(r"[<>$`*?]|\b(?:for|while|until|if|case)\b")


def _as_text(value) -> str:
    """tool_input の形が tool ごとに違うため、素直に文字列へ潰す。"""
    if isinstance(value, str):
        return value
    if isinstance(value, list):
        return " ".join(_as_text(v) for v in value)
    if isinstance(value, dict):
        return " ".join(_as_text(v) for v in value.values())
    return "" if value is None else str(value)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        # 入力を解釈できないときは素通しする(フックの故障でセッションを止めない)
        return 0

    haystack = _as_text(payload.get("tool_input"))

    rules = list(PATH_DENY)
    # apply_patch の tool_input はファイルの中身そのもの。ドキュメントに例示された
    # `git push` までコマンドとして誤検知するため、パス条件だけを適用する。
    if payload.get("tool_name") != "apply_patch":
        rules += COMMAND_DENY
        if _WRAPPER.search(haystack) and _UNSPLITTABLE.search(haystack):
            rules.append((
                WRAPPED_ONLY_DENY,
                "シェルに包むと承認フローを迂回するため実行できません。包まずに実行してください",
            ))

    for pattern, reason in rules:
        if pattern.search(haystack):
            print(reason, file=sys.stderr)
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
