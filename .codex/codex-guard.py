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
  (bash -lc "git reset --hard > /dev/null")。文字列としては見えるのでここで捕まえる
- gcloud / az は動詞が末尾に来る上に深さが可変で (gcloud compute instances delete /
  az storage account delete)、aws は動詞名が可変 (delete-bucket / terminate-instances)。
  いずれも prefix_rule では届かない

UNSPLITTABLE_DENY (custom.rules の forbidden が届かない範囲):
- 同じ分解漏れでは forbidden ルールも素通りする。フックで同じコマンドを拒否して
  迂回を防ぐ。POSIX では **シェルに包まれていて、かつ分解を妨げる文字を含む** ときだけ
  この補完ルールを適用する。素のコマンドは execpolicy が拒否する。
- && || ; | は Codex が分解できるので、分解を妨げる文字には数えない。

Windows だけ扱いが違う理由:
- Codex は Windows では素の argv を使わず、常に
  `"C:\\Program Files\\PowerShell\\7\\pwsh.exe" -Command '<コマンド>'` で実行する。
  この形だと execpolicy の prefix_rule は一切マッチしない (実測: raw argv の
  `gws status` は forbidden、`pwsh.exe -Command "gws status"` はマッチ0件)。
  approval_policy を untrusted にしても承認要求は出ず、forbidden も prompt も
  Windows では機能しない。つまり **このフックが唯一の防壁**。
- 実行が常に包まれる以上「包まれた時だけ拒否」に分岐の意味がないので、Windows では
  UNSPLITTABLE_DENY を無条件に適用する。承認フローが無い以上「確認できないなら止める」
  に倒す、という判断。
- 判定に使うのは OS であってラッパー検出ではない。フックに届く tool_input.command は
  pwsh に包まれる**前**の生コマンド (実測: `{"command": "git reset --hard"}`) なので、
  ペイロードからは Windows かどうかを見分けられない。フックは Codex と同じマシンで動く
  ので sys.platform で足りる。

拒否は「exit 2 + stderr に理由」、それ以外は exit 0 で素通しする。
"""
import json
import re
import sys

_PATH_START = r"(?:^|[\s\"'=/\\])"
_PATH_END = r"(?=$|[\s\"'/\\;|&()])"

PATH_DENY = [
    (
        re.compile(_PATH_START + r"\.env(?:\.[\w.-]+)?" + _PATH_END),
        ".env ファイルへのアクセスは禁止されています",
    ),
    (
        re.compile(_PATH_START + r"secrets[\\/]"),
        "secrets/ 配下へのアクセスは禁止されています",
    ),
    (
        re.compile(r"\bcredentials\.json\b"),
        "credentials.json へのアクセスは禁止されています",
    ),
]

# コマンドの先頭とみなす位置。_as_text で平坦化された文字列に対し、
# 文頭 / シェルの区切り / bash -lc・sh -c・pwsh -Command・cmd /c の直後だけを起点に見る。
# これを付けないと `grep mail file` や `echo git reset` が誤って引っかかる。
# -Command / /c を入れているのは、モデルが明示的にシェルを入れ子にした
# (`pwsh -Command "git reset --hard"`) ときも起点として拾うため。フックに届く
# tool_input.command 自体は包まれていない (docstring 参照)。
# `-c` / `-lc` は空白必須なので `-Command` には別途マッチさせる必要がある。
# 入れ子の中身はクォートで囲まれることがあるので、いずれの起点でも1文字だけ食わせる。
_CMD_START = r"(?:^|(?:&&|\|\||[;|])\s*|-(?:lc|c)\s+[\"']?|-[Cc]ommand\s+[\"']?|/[Cc]\s+[\"']?)"

COMMAND_DENY = [
    (re.compile(_CMD_START + r"gws\b"), "gws の実行は禁止されています"),
    (re.compile(_CMD_START + r"(?:sendmail|mail)\s"), "メール送信コマンドの実行は禁止されています"),
    (re.compile(_CMD_START + r"git\s+(?:reset|rebase|clean)\b"), "履歴や未追跡ファイルを壊す git 操作は手動でのみ行う"),
    (re.compile(_CMD_START + r"dotnet\s+tool\s+(?:install|uninstall|update)\b[^;&|]*(?:--global|\s-g\b)"),
     "グローバルな .NET ツール変更は手動でのみ行う"),
    (re.compile(_CMD_START + r"(?:uv\s+pip|pip3?)\s+(?:install|uninstall)\b[^;&|]*(?:--user|--system|--break-system-packages)\b"),
     "グローバルな Python 環境への変更は手動でのみ行う"),
    # aws/gcloud/az は動詞の位置が揃わないため、次の区切りまでの範囲に破壊系の語を探す。
    (re.compile(_CMD_START + r"(?:aws|gcloud|az)\b[^;&|]*\b(?:delete|destroy|terminate)"),
     "クラウドリソースの削除・破棄コマンドは手動でのみ行う"),
]

# custom.rules の forbidden ルールに対応するコマンド。Codex が分解できないシェル
# ラッパー内では execpolicy が届かないため、フックでも同じ操作を拒否する。
UNSPLITTABLE_DENY = re.compile(
    _CMD_START + r"(?:"
    r"terraform\s+destroy"
    r"|curl\s+(?:-\S+\s+)*-X\s+DELETE"
    r"|npm\s+publish"
    r"|npm\s+install\s+(?:-g|--global)\b"
    r"|brew\s+(?:install|uninstall|upgrade)\b"
    r"|winget\s+(?:install|uninstall|upgrade)\b"
    r"|cargo\s+(?:install|uninstall)\b"
    r"|docker\s+system\s+prune\b"
    r")"
)

# シェルラッパー経由か。
_WRAPPER_POSIX = re.compile(r"\b(?:bash|sh|zsh)\s+-(?:lc|c)\b")
# Codex が bash -lc "..." を分解しなくなる条件 (リダイレクト・変数展開・コマンド置換・
# グロブ・制御構文)。&& || ; | は分解できるので含めない。
_UNSPLITTABLE = re.compile(r"[<>$`*?]|\b(?:for|while|until|if|case)\b")

# Windows かどうかはペイロードからは判定できない。tool_input.command は
# pwsh でラップされる**前**の生コマンドなので (実測: `git reset --hard` がそのまま届く)、
# ラッパー検出では Windows を見分けられない。フックは Codex と同じマシンで動くので
# 実行中の OS がそのまま Codex の OS になる。
_IS_WINDOWS = sys.platform.startswith("win")


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
    # `git reset` までコマンドとして誤検知するため、パス条件だけを適用する。
    if payload.get("tool_name") != "apply_patch":
        rules += COMMAND_DENY
        if _IS_WINDOWS:
            # Windows には承認フローが無いので、包まれているかで分岐する意味がない。
            rules.append((UNSPLITTABLE_DENY, "環境や外部状態を破壊し得るため、手動で実行してください"))
        elif _WRAPPER_POSIX.search(haystack) and _UNSPLITTABLE.search(haystack):
            rules.append((
                UNSPLITTABLE_DENY,
                "シェルに包むと禁止ルールを迂回するため実行できません",
            ))

    for pattern, reason in rules:
        if pattern.search(haystack):
            print(reason, file=sys.stderr)
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
