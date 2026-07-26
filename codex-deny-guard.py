#!/usr/bin/env python3
"""Codex の PreToolUse フックとして動作する deny ガード。

Codex 0.145 には Claude Code の `permissions.deny` に相当するユーザー設定が無い
(`permission_profiles` は managed config 専用、`exec_permission_approvals` は未実装)。
そのため claude-settings.json の deny リストをこのスクリプトで再現する。

PreToolUse が返せる判定は deny のみ。allow / ask はバイナリ側で拒否されるため、
「exit 2 + stderr に理由」で拒否し、それ以外は exit 0 で素通しする。
"""
import json
import re
import sys

# コマンド位置(行頭・パイプ・; & の直後)でのみマッチさせる。引数中の単なる文字列一致を防ぐ。
_CMD_POS = r"(?:^|[;&|(]|&&|\|\||\bthen\b|\bdo\b)\s*"
_M = re.MULTILINE

COMMAND_DENY = [
    (re.compile(_CMD_POS + r"gws\b", _M), "gws の実行は禁止されています"),
    (re.compile(_CMD_POS + r"(?:mail|sendmail)\b", _M), "メール送信コマンドの実行は禁止されています"),
    (re.compile(_CMD_POS + r"git\s+(?:reset|rebase|push)\b", _M), "git reset / rebase / push は禁止されています"),
]

# shell ツールは argv 形式 (["bash", "-lc", "<script>"]) で来るため、ラッパーを剥がして実スクリプトを取り出す
_SHELL_WRAPPERS = {"bash", "sh", "zsh", "dash", "fish", "pwsh", "powershell", "cmd"}

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


def _command_script(command) -> str:
    """`["bash", "-lc", "git push"]` から `git push` を取り出す。"""
    if not isinstance(command, list):
        return _as_text(command)
    parts = [_as_text(p) for p in command]
    if not parts:
        return ""
    head = parts[0].replace("\\", "/").rsplit("/", 1)[-1].removesuffix(".exe").lower()
    if head in _SHELL_WRAPPERS:
        for i, part in enumerate(parts[1:], start=1):
            if not part.startswith(("-", "/")):  # -lc / /c などのフラグを読み飛ばす
                return "\n".join(parts[i:])
        return "\n".join(parts[1:])
    return " ".join(parts)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        # 入力を解釈できないときは素通しする(フックの故障でセッションを止めない)
        return 0

    tool_input = payload.get("tool_input") or {}
    command_text = _command_script(tool_input.get("command")) if isinstance(tool_input, dict) else ""
    haystack = _as_text(tool_input)

    # コマンド判定は実コマンドが取れたときだけ。apply_patch の本文に対して誤爆させない。
    for pattern, reason in COMMAND_DENY:
        if command_text and pattern.search(command_text):
            print(reason, file=sys.stderr)
            return 2

    for pattern, reason in PATH_DENY:
        if pattern.search(haystack):
            print(reason, file=sys.stderr)
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
