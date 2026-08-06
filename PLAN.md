# PLAN.md

No work in progress.

## Undecided
- Running Codex inside this repo fires each hook twice (user layer + project layer — see the
  Tacit Knowledge entry on `.claude/`/`.codex/` also being read as project config), and during
  the interactive verification one of the two exited 1 instead of 0/2. The deny still took
  effect; the cause of the exit-1 duplicate is unknown.
- `custom.rules`'s header points at `AGENTS.md`, and `AGENTS.md` now points back at the config
  files. Whichever side gets edited, the other can go stale. No fix chosen.
- `_UNSPLITTABLE` in `codex-guard.py` guesses which bodies Codex refuses to split. POSIX-only
  now — Windows applies `WRAPPED_ONLY_DENY` unconditionally, so the guess no longer matters
  there. Still relevant for macOS/Linux.
