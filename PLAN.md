# PLAN.md

## Goal
- Bring this repo's docs in line with the revised global doctrine in `AGENTS.global.md`.

## Approach
- The doctrine owns the routing table. `AGENTS.md` and the skills defer to it instead of
  restating it.
- `AGENTS.md` keeps only what the config files' own comments do not already say. Where a file
  documents itself, `AGENTS.md` points at it rather than repeating it.

## Rejected
- Moving the "classification table, then a diff" gate into the update-agentsmd skill: Codex /
  Gemini / Copilot cannot invoke skills, so three of the four tools would lose the guard.
- Splitting the Codex/execpolicy entries out to `docs/codex-permissions.md`: the extra hop makes
  it likelier the content goes unread, and anything touching `.codex/` has to read it anyway.
- Cutting `AGENTS.md` down to the doctrine's ~100-line target: the 2026-07-26 audit found the
  remaining entries genuinely tacit, so the cut would discard accident-preventing text.
  161 lines is accepted deliberately.
- Prompting on `bash -lc` as a whole to close the split hole: every everyday command containing a
  glob or a redirect would then wait for approval.
- Denying the `prompt`-rule commands unconditionally in the hook: the hook cannot return "ask", so
  bare `brew install` / `pip install` would turn from a confirmation into a refusal.
- Enumerating cloud subcommands as `prefix_rule`s: `gcloud` / `az` put the verb last at a variable
  depth, so the enumeration would have silent gaps and give false confidence.

## Next
- On the Windows machine, confirm in an authenticated Codex session that a `prompt` rule actually
  raises an approval dialog. Only the static `execpolicy check` decision has ever been verified.
- Run `Bootstrap-Windows.ps1` there too — it has never been executed. `bootstrap_fedora.sh` stays
  unverified until a Fedora machine exists; `dnf install -y uv` is the unproven line.

## Undecided
- `custom.rules`'s header points at `AGENTS.md`, and `AGENTS.md` now points back at the config
  files. Whichever side gets edited, the other can go stale. No fix chosen.
- `codex-guard.py` skips `COMMAND_DENY` when `tool_name == "apply_patch"`, so a patch containing
  the literal text `git push` is not denied. The field name is assumed to match Claude Code's
  payload and is unverified on Codex. If it is wrong, editing docs gets denied.
- `_UNSPLITTABLE` in `codex-guard.py` guesses which bodies Codex refuses to split. If the guess is
  narrower than reality, a wrapped `prompt` command slips through.
