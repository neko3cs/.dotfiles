#!/usr/bin/env python3
"""Codex の PreToolUse フックとして動作するパス deny ガード。

権限制御は原則 execpolicy (.codex/rules/custom.rules) に寄せてある。
このスクリプトが残っているのは、execpolicy の builtin が
prefix_rule / network_rule / host_executable の3つだけで、
**ファイルパスを条件にしたルールが書けない**という構造的な理由による。

- prefix_rule は「コマンド + 引数の前置一致」しか書けないので
  「どのコマンドであれ .env に触る」を表現できない
  (cat/less/head/rg... x .env/.env.local/path/to/.env の総当たりになる)
- apply_patch によるファイル書き込みはシェルコマンドではなく execpolicy の管轄外

コマンド単位の deny/ask はすべて custom.rules 側にあり、ここには持たない。

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

    for pattern, reason in PATH_DENY:
        if pattern.search(haystack):
            print(reason, file=sys.stderr)
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
