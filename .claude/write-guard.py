#!/usr/bin/env python3
"""Claude Code の PreToolUse フックとして動作する書き込みガード。

Edit / Write / NotebookEdit の書き込み先が、セッションの作業フォルダ
(最初のフォルダと、追加したフォルダ) の外なら拒否する。読み取りは止めない。

フックにした理由:
- sandbox が対象にするのはシェルコマンドだけで、ファイル系ツールは権限ルールに従う。
  auto mode では作業フォルダ外の編集を classifier が判断するので、通ってしまうことがある。
- 書き込み版の permissions.blockReadsOutsideWorkingDirectories は無い。deny は allow より
  優先されるので、「作業フォルダの外だけ deny」は権限ルールでは書けない。
- --restricted フラグはファイル系ツールを作業フォルダに閉じ込めるが、読み取りも止める上に、
  デスクトップアプリからは渡せない。

作業フォルダの一覧の取り方:
- フック入力の共通フィールドには cwd しかなく、追加したフォルダの一覧は無い。
- DirectoryAdded イベントは /add-dir と SDK の register_repo_root でしか発火しない。
  デスクトップアプリでフォルダを追加しても発火しなかった (実測)。起動時の --add-dir も対象外。
- transcript の environment 添付 (attachment.snapshot) には workingDirectory と
  additionalWorkingDirectories が入っている。デスクトップアプリで途中から追加したときも、
  次のリクエストの時点で新しいスナップショットが書かれた (実測)。ただし公開された形式では
  ないので、形式が変わると追加フォルダへの書き込みが拒否される (安全側に倒れる)。
  そうなったらここを直す。

作業フォルダのほかに許可する場所: scratchpad、plan mode の計画ファイル (~/.claude/plans)、
auto memory (<transcript のフォルダ>/memory)。どれも Claude Code 自身が Write で書く場所。

判定できないときも拒否する。拒否は「exit 2 + stderr に理由」、それ以外は exit 0 で素通しし、
通常の権限判定に任せる。
"""
import json
import os
import sys

PATH_KEYS = ("file_path", "notebook_path")
ENVIRONMENT_MARK = b'"attachment":{"type":"environment"'


def _norm(path):
    return os.path.normcase(os.path.realpath(os.path.expanduser(path)))


def _inside(path, root):
    try:
        return os.path.commonpath([path, root]) == root
    except ValueError:  # Windows でドライブが違う
        return False


def _main_transcript(payload):
    """サブエージェントの transcript には environment が無いので、本体の transcript を探す。"""
    path = payload.get("transcript_path")
    name = f"{payload.get('session_id')}.jsonl"
    if not path:
        return None
    if os.path.basename(path) == name:
        return path
    folder = os.path.dirname(path)
    while folder != os.path.dirname(folder):
        candidate = os.path.join(folder, name)
        if os.path.isfile(candidate):
            return candidate
        folder = os.path.dirname(folder)
    return path


def _latest_snapshot(transcript):
    snapshot = None
    with open(transcript, "rb") as f:
        for line in f:
            if ENVIRONMENT_MARK in line:
                snapshot = json.loads(line)["attachment"]["snapshot"]
    return snapshot


def allowed_roots(payload):
    roots = [os.environ.get("CLAUDE_PROJECT_DIR") or payload["cwd"]]
    transcript = _main_transcript(payload)
    if transcript and os.path.isfile(transcript):
        snapshot = _latest_snapshot(transcript) or {}
        roots += snapshot.get("additionalWorkingDirectories", [])
        roots.append(os.path.join(os.path.dirname(transcript), "memory"))
    if payload.get("scratchpad_dir"):
        roots.append(payload["scratchpad_dir"])
    config_dir = os.environ.get("CLAUDE_CONFIG_DIR") or "~/.claude"
    roots.append(os.path.join(config_dir, "plans"))
    return [_norm(r) for r in roots]


def check(payload):
    """拒否するなら理由を返す。"""
    tool_input = payload.get("tool_input") or {}
    target = next((tool_input[k] for k in PATH_KEYS if tool_input.get(k)), None)
    if target is None:
        return None
    target = _norm(os.path.join(payload["cwd"], target))
    roots = allowed_roots(payload)
    if any(_inside(target, root) for root in roots):
        return None
    return (
        f"作業フォルダの外への書き込みは禁止されています: {target}\n"
        "このフォルダを編集する必要があるなら、ユーザーにセッションへのフォルダ追加を頼んでください"
        " (デスクトップアプリではフォルダの追加、CLI では /add-dir)。"
    )


def main():
    try:
        reason = check(json.load(sys.stdin))
    except Exception as e:  # 判定できないなら止める
        reason = f"書き込みガードが判定に失敗したため拒否しました: {e!r}"
    if reason:
        print(reason, file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
