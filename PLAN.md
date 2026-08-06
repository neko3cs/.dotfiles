# PLAN.md

## Goal
- Codex permission control on Windows. Done: matcher fixed (`Bash`), guard extended, deny
  verified end-to-end in an interactive session. Both bootstrap scripts (`Bootstrap-Windows.ps1`,
  `bootstrap_fedora.sh`) have now been run end-to-end and their idempotency bugs fixed — see
  the 2026-08-06 entries below and AGENTS.md Incidents.

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
`git status` passes, in an interactive session). No open items remain in this goal; the log below
records how each part was verified.

2026-08-06: ran `bootstrap_fedora.sh` end-to-end on the WSL FedoraLinux-43 instance set up by
`Bootstrap-Windows.ps1`'s `Set-Wsl2Fedora`. This instance already had a partial prior run on it
(docker, aws-cli, starship, dotfiles symlinks dated 2026-07-30 all present), so this exercised
idempotency, same as the Windows run. `set -e` meant only one bug surfaced per run; fixed and
re-ran 6 times until a clean `exit 0`. Found and fixed 6 bugs — see AGENTS.md Incidents for the
"why" on each:
- `rpm -i packages-microsoft-prod.rpm` (fails if already installed) → check `rpm -q` first.
- `dnf config-manager addrepo` for HashiCorp and, separately, Docker CE (both fail once the repo
  file exists) → added `--overwrite` to both.
- `sudo dnf group install development-tools` was missing `-y` — the 2026-08-04 commit that
  extracted this line never actually fixed the underlying problem, it just moved it. A no-op
  transaction still prompts without `-y`.
- `install_aws_cli`'s installer refuses to run over an existing install → skip if `command -v aws`.
- `install_pyenv`'s installer refuses to run over an existing `~/.pyenv` (leftover from an earlier
  interrupted run) → skip if the directory exists.
Everything else (locale/timezone, copr repos, `dnf install` from `dnf-packages.txt`,
`set_dotfiles.sh`, `install_gcm`'s WSL wrapper, `install_starship`, completions) was already
idempotent. Verified via full runs (not isolated units, since `set -e` makes each run itself the
verification) plus a final spot-check of `~/.pyenv`, the GCM wrapper, `starship`, `docker`
(active), and both repo files.

2026-08-06: ran `gsudo pwsh -f Bootstrap-Windows.ps1` end-to-end on this machine (2nd run, so
this exercised idempotency, not first-time setup). Found and fixed two bugs — see AGENTS.md
Incidents for the "why":
- `Set-Wsl2Fedora`'s `wsl --install` errored `ERROR_ALREADY_EXISTS` on the already-installed
  distro; its `$LASTEXITCODE` went uncaught and became the whole script's exit code (1). Fixed
  by checking `wsl --list --quiet` first.
- `msstore-apps.json`'s Amazon Kindle entry can't install non-interactively (age-gate prompt,
  no skip flag). Removed.
Everything else in the script — winget import, Windows optional features, `Set-DotFiles.ps1`
symlinks, final WSL state — was already idempotent and needed no changes. The fix was verified
in isolation (fixed `Set-Wsl2Fedora` logic run standalone, `$LASTEXITCODE` 0 for both `wsl`
calls); a full re-run of the whole script was not repeated since the rest was already proven.

2026-08-06: re-verified the `git push` allow after the 2026-07-30 branch+PR switch.
- Claude: live in an interactive Windows session — `git push --dry-run` ran with no prompt,
  `git reset --hard` came back "Permission ... has been denied."
- Codex: `codex execpolicy check` confirms the rules file (`git push origin feature-x` → no
  match / implicit allow, `git reset --hard` → `forbidden`), but that layer never fires on
  Windows (pwsh wrapping — see Tacit Knowledge). The actual barrier, `codex-guard.py`, was fed
  the measured unwrapped payload shape directly: `git push origin feature-x` → exit 0,
  `git reset --hard` → exit 2 with the expected justification. Not a literal interactive Codex
  TUI session (`codex exec` can't be used here — it bypasses hook denials, see Undecided/
  Incidents), but it exercises the exact mechanism that gates on Windows.

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
