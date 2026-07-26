# PLAN.md

## Goal
- Verify on Windows what has only ever been exercised on macOS: the Codex approval flow, and
  whether `codex-guard.py` fires there at all. The doc alignment with `AGENTS.global.md` is done.

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
Prerequisites — the Windows machine has never been set up:
1. Clone this repo to `%USERPROFILE%\.dotfiles`. `.codex/hooks.json` resolves the guard as
   `~/.dotfiles/codex-guard.py`, so any other location kills both hooks silently. Only the hook
   path is fixed like this; `Set-DotFiles.ps1` itself uses `$PSScriptRoot`.
2. `winget install astral-sh.uv` — without `uv` both hooks exit 127.
3. `pwsh -File Set-DotFiles.ps1` from an elevated shell. `config.toml` is copied, not symlinked,
   so re-run it after every change to that file.
4. Codex asks to trust the hooks once — the content hash changed on 2026-07-26.

Then, in this order:
- Check that the guard runs at all (see the first `Undecided` item). Everything below is
  meaningless until this is settled.
- Confirm a `prompt` rule raises a real approval dialog. `winget install <anything>` matches
  `custom.rules`; decline at the dialog instead of installing.
- Run `Bootstrap-Windows.ps1` on a machine you can afford to re-provision — it has never been
  executed. `bootstrap_fedora.sh` stays unverified until a Fedora machine exists;
  `dnf install -y uv` is the unproven line.

## Undecided
- **Whether `codex-guard.py` does anything on Windows at all.** `_WRAPPER` and `_CMD_START` only
  recognise `bash` / `sh` / `zsh` with `-lc` / `-c`. If Codex wraps commands as `cmd /c ...` or
  `pwsh -Command ...` there, `/c` never matches `-c\s+` and both deny layers go inert. The 35
  passing cases were all macOS. Find out what the runtime actually sends before trusting anything.
- `custom.rules`'s header points at `AGENTS.md`, and `AGENTS.md` now points back at the config
  files. Whichever side gets edited, the other can go stale. No fix chosen.
- `codex-guard.py` skips `COMMAND_DENY` when `tool_name == "apply_patch"`, so a patch containing
  the literal text `git push` is not denied. The field name is assumed to match Claude Code's
  payload and is unverified on Codex. If it is wrong, editing docs gets denied. To check it, have
  Codex edit a file whose text contains `git push` and see whether it is denied.
- `_UNSPLITTABLE` in `codex-guard.py` guesses which bodies Codex refuses to split. If the guess is
  narrower than reality, a wrapped `prompt` command slips through.
