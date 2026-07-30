# PLAN.md

## Goal
- Codex permission control on Windows. Done: matcher fixed (`Bash`), guard extended, deny
  verified end-to-end in an interactive session. Remaining: the never-run bootstrap scripts.

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
- Switching Codex to a bash-family shell on Windows so the existing execpolicy rules apply: no
  such setting exists in 0.145.0 (config, `WindowsToml`, and every feature flag were checked).
- `unified_exec` / `approval_policy = "untrusted"` as a way to reach the approval flow on
  Windows: measured, both still execute a `forbidden` command without asking.
- Detecting the pwsh wrapper in the payload to identify Windows: the hook receives the raw
  command, before any wrapper, so there is nothing to detect. Uses `sys.platform` instead.

## Next
Windows is set up and the guard is verified (`git reset --hard` and `winget install` both denied,
`git status` passes, in an interactive session). Remaining:
1. Run `Bootstrap-Windows.ps1` on a machine you can afford to re-provision — it has never been
   executed.
2. `bootstrap_fedora.sh` stays unverified until a Fedora machine exists; `dnf install -y uv` is
   the unproven line.
3. 2026-07-30: switched the AI git workflow to branch + PR (worktree-based), so `git push` is now
   allowed on both Claude (`.claude/settings.json`) and Codex (`custom.rules` forbidden pattern +
   `codex-guard.py` COMMAND_DENY, both narrowed to `reset`/`rebase` only). Not yet re-verified in
   an interactive Windows session — confirm `git push` now passes through and `git reset --hard`
   is still denied.

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
