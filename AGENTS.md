# AGENTS.md

Cross-platform dotfiles for macOS, Fedora Linux, and Windows. Shell scripts, config files, and
package lists only — there are no application features, APIs, or user-facing products here.

## Key References

- `PLAN.md` — in-flight work baton. Read it before starting.

## Development Rules

- **No branches, no PRs.** Commit directly to `main`. Because there is no PR to hold the
  discussion, the commit message body must carry the intent — why the change was made, which
  alternatives were rejected and why. A subject-line-only commit is not acceptable here, even for
  a one-line change.
- **No automated tests.** Verify by running `set_dotfiles.sh` and sourcing `.zshrc` manually.
- **Config files mirror their deploy path.** `.claude/settings.json` → `~/.claude/settings.json`,
  `.config/ghostty/config` → `~/.config/ghostty/config`. Follow this when adding a new config file.
  The only exceptions are the "multiple destinations" table below.
- **Platform guards are mandatory.** Any macOS-only or WSL-only config in `.zshrc` must be wrapped
  in `if $IS_MACOS` / `if $IS_WSL`. `.zshrc` sets both booleans at startup
  (`$OSTYPE == darwin*` / `$WSL_DISTRO_NAME` is set).
- **Machine-specific settings** (`user.name`, `user.email`, Linux credential store) go in
  `~/.gitconfig.local`, included via `[include]` from `.gitconfig`. Never committed.
- **Prefix repo-internal paths with `$SCRIPT_ROOT` / `$PSScriptRoot`.** A bare relative path only
  works when cwd happens to be the repo root.
- **Completions are generated per-machine** and untracked. Re-run `set_completions.sh` /
  `Set-Completions.ps1` after installing new tools.

## Layout

Only deployable config files mirror their destination. Scripts, package lists, and docs sit flat at
the repo root — do not create directories for them.

```
.claude/settings.json   .copilot/settings.json
.codex/{config.toml, hooks.json, rules/custom.rules, codex-guard.py}
.config/{ghostty/config, bat/config, nvim/init.lua, zed/settings.json,
         powershell/Microsoft.PowerShell_profile.ps1}
.starship/starship.toml   .zshrc   .gitconfig   .textlintrc.json   Brewfile
bootstrap_macOS.sh  bootstrap_fedora.sh  Bootstrap-Windows.ps1
set_dotfiles.sh  Set-DotFiles.ps1  set_completions.sh  Set-Completions.ps1
play-sound.py
dnf-packages.txt  winget-package.json  msstore-apps.json  npm-packages.txt
dotnet-tools.txt  vscode-extensions.txt
```

**Multiple destinations** (cannot live at a single mirror path):

| File | Deployed to |
|---|---|
| `AGENTS.global.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md` |
| `.config/zed/settings.json` | `~/.config/zed/settings.json` (Win: `%APPDATA%\Zed\settings.json`) |

**Copied instead of symlinked** (everything else is `ln -sf`): `.codex/config.toml`,
`.config/powershell/Microsoft.PowerShell_profile.ps1`

**Not deployed**: `vscode-settings.json` and `.vssettings` are reference snapshots for manual
import. They are not symlinked because they conflict with Settings Sync.

## Commands

```sh
# First-time setup
zsh bootstrap_macOS.sh          # macOS
bash bootstrap_fedora.sh        # Fedora / WSL (as a sudo-capable user, not root)
pwsh -f Bootstrap-Windows.ps1   # Windows (elevated PowerShell 7+)

# Re-deploy dotfiles only
zsh set_dotfiles.sh
pwsh -File Set-DotFiles.ps1     # Windows needs elevation

# Regenerate completions only
zsh set_completions.sh
pwsh -File Set-Completions.ps1

# Sync Brewfile with the current environment
brew bundle dump --force

# Check an execpolicy decision (hidden subcommand — absent from `codex --help`)
codex execpolicy check --rules .codex/rules/custom.rules -- git reset --hard
```

Edit the other package lists directly.

`execpolicy check` returns a JSON `decision` for **raw argv only** — it skips the runtime's shell
splitting, so `bash -lc "git reset --hard"` will not match. To validate syntax and `match` / `not_match`
instead, send `initialize` then `thread/start` to `codex app-server` and watch for
`failed to parse rules file ...`. `codex doctor` and `codex debug models` never read rules.

## Tacit Knowledge

- **This repo's `.claude/` and `.codex/` are also read as *project* config**: running an agent
  inside this repo applies them on top of the user-level copies. Claude Code reads
  `.claude/settings.json` immediately, so the notification hook fires twice. Codex disables
  project-local layers until the project is trusted. Side effect of the mirror layout.
- **Never symlink a file the agent writes back to.** `.codex/config.toml` is copied because the
  Codex desktop app rewrites `[projects.*]` / `[mcp_servers.*]` / `[marketplaces.*]` / `notify` at
  runtime. Same cause for `custom.rules` vs `default.rules` (see that file's header) — every
  `*.rules` under `rules/` is loaded, so a separate name keeps the tracked file clean.
- **Codex permission routing is documented in the files themselves** — `custom.rules`'s header and
  `codex-guard.py`'s docstring. Two things that are not written there: decision precedence is
  forbidden > prompt > allow, and `permission_profiles` is enterprise-only (`requirements.toml`) —
  do not use it, and do not re-investigate it.
- **(POSIX only) Codex splits `bash -lc "..."` only when it is plain words joined by
  `&&` `||` `;` `|`.** Redirection, variable expansion, command substitution, globs, or control
  flow → no split, the whole invocation counts as one command and `prefix_rule` never matches.
  `codex-guard.py` closes this: `forbidden` commands are denied outright, `prompt` commands only
  when wrapped — so a bare `brew install` still reaches the approval flow. The split condition
  there is inferred, not documented upstream.
- **Hook payloads do not use Codex's internal tool names.** PreToolUse receives
  `tool_name: "Bash"` for shell (the rollout log's `function_call` name is `shell_command` — do
  not copy it into `matcher`), and `apply_patch` unchanged. `matcher` is a regex over that name.
  `tool_input.command` is the **raw** command, before the pwsh wrapper — so the guard decides
  Windows by `sys.platform`, not by detecting a wrapper.
- **`codex exec` runs as `permission_mode: bypassPermissions`: hooks fire but their deny is
  discarded** (measured — the command still ran on exit 2). Only an interactive `codex` session
  enforces a deny. Do not treat the hook as a barrier in automation.
- **On Windows neither execpolicy nor the approval flow works — `codex-guard.py` is the only
  barrier.** Codex always executes as
  `"C:\Program Files\PowerShell\7\pwsh.exe" -Command '<cmd>'`, which no `prefix_rule` can match
  (raw argv `gws status` → `forbidden`; `pwsh.exe -Command "gws status"` → zero matches).
  `approval_policy = "untrusted"` raises no prompt either, nor does `unified_exec` — both measured,
  both still execute a `forbidden` command without asking. No setting changes the shell in
  0.145.0 — `ConfigToml`'s 96 fields, `WindowsToml`, and all 97 `codex features list` entries
  were checked. Do not re-investigate. Because Windows has no approval flow, the guard applies
  `WRAPPED_ONLY_DENY` unconditionally there: "if it cannot be confirmed, stop it".
- **If a `prompt` rule silently does nothing**, the error is `approval required by policy, but
  AskForApproval is set to Never`. `granular` is a newtype variant; `config.toml`'s comment covers
  the all-five-fields requirement.
- **`.codex/hooks.json` event names are PascalCase** (`PreToolUse` / `Stop` — Claude Code
  compatible). **An unknown event name is silently ignored, not an error**, so after adding one
  confirm it loaded via `codex app-server`'s `hooks/list`.
- **Codex hooks start untrusted**: Codex re-asks for trust whenever the content hash changes. One
  approval per machine.
- **Call Python from hooks via `uv run --no-project python -c`**: this machine has no `python`, only
  `python3`; Windows is the reverse, and `uv` absorbs the difference. **Every OS that receives the
  hooks needs a `uv` source** — `Brewfile` / `winget-package.json` / `dnf-packages.txt` (Fedora 43
  ships `uv` in-repo; no curl installer needed). `--no-project` is mandatory: without it `uv` starts
  resolving the dependencies of whatever Python project the agent is working in and the hook breaks.
  Resolve paths with `os.path.expanduser`, not shell `~` expansion (cmd does not expand `~`). Exit
  codes propagate through `uv run`, so a PreToolUse deny (exit 2) still takes effect.
- **PowerShell profile is copied, not symlinked**: `$PROFILE` differs per OS, so one symlink target
  cannot satisfy both.
- **Windows deploys a deliberate subset**: `Set-DotFiles.ps1` skips `.zshrc` / ghostty / `init.lua` /
  `Brewfile`, and on macOS pwsh only gets the profile. zsh is the main shell — this is design, not
  an omission.
- **Native Linux leaves both `IS_MACOS` and `IS_WSL` false.** Do not assume Linux == WSL.
- **Windows bootstrap assumes `winget` and `git` are already installed**; the script does not
  install them.
- **Git Credential Manager installs differently per OS**: `bootstrap_fedora.sh`'s `install_gcm`
  branches between native Fedora (.NET tool + `secretservice`) and WSL (an interop wrapper around
  the Windows-side GCM). The reasoning is in the script's own comments.
- **Configs that host a shell must name the Nerd Font explicitly.** starship draws its separators
  and icons from the Nerd Font private-use area, which macOS font fallback does not cover (emoji it
  does) — an unset `font_family` renders tofu, never an error. Use `HackGen Console NF`, not the
  `HackGen35 Console NF` that `font-hackgen-nerd` installs alongside it.

## Incidents

| Date | What went wrong | Prevention |
| :--- | :--- | :--- |
| 2026-07-12 | `.gitconfig` had no `[include]` for `.gitconfig.local`, so `user.name` / `user.email` were never loaded | After splitting config out, verify the `[include]` side was written too — not just that the included file exists |
| 2026-07-12 | `NODE_EXTRA_CA_CERTS` was set unconditionally to a Linux-only path, breaking pnpm and friends on macOS | Check every new env/PATH entry in `.zshrc` against "platform guards are mandatory". Do not stop at testing one OS |
| 2026-07-26 | `dnf-packages.txt` in `bootstrap_fedora.sh` and `msstore-apps.json` in `Bootstrap-Windows.ps1` were bare relative paths, working only when cwd was the repo root | Always prefix repo-internal references with `$SCRIPT_ROOT` / `$PSScriptRoot` |
| 2026-07-26 | Concluded "Codex has no user-level permission setting" once `permission_profiles` proved managed-config-only, ignoring execpolicy (`.rules`) from the same search output — then reported `ask` as impossible and hand-rolled a Python hook | One negative result does not settle whether a mechanism exists; read every `--help` option and the official docs first |
| 2026-07-26 | Put the execpolicy rules in `default.rules` — the file Codex itself rewrites on "always allow" | Never symlink a file the agent writes back to; give the write target and the tracked file different names |
| 2026-07-26 | Looked for subcommands only under `codex debug` and missed the top-level hidden `codex execpolicy check` | A CLI-looking struct name in the binary's strings (here `ExecPolicyCheckCommand`) may be a top-level subcommand absent from `--help` |
| 2026-07-26 | The notification hook called `python -c`, but macOS has only `python3`, so it had failed silently (exit 127) all along — and the same shape got copied into the Codex hooks | Run hooks through a real shell and check the exit code; "the JSON is valid" proves nothing |
| 2026-07-26 | Switching hooks to `uv run` added `uv` to `Brewfile` and `winget-package.json` but missed `dnf-packages.txt`, where both hooks would have died with `uv: command not found` | When a hook gains a dependency, check the package list of **every OS the config deploys to** |
| 2026-07-26 | Created a feature branch for a one-file doc change, then had to fast-forward `main` onto it and delete the branch | This repo does not use branches; commit to `main` and put the reasoning in the commit message body |
| 2026-07-28 | `.codex/hooks.json`'s matcher was `shell`, so PreToolUse never fired on any OS and the guard was inert | After adding a hook, confirm it actually fires with a real payload — passing unit tests is not proof of firing |
| 2026-07-28 | execpolicy and `codex-guard.py` were deployed to Windows too, but the pwsh wrapper meant execpolicy had never once taken effect there | Before shipping permission control to another OS, confirm with `codex exec --json` what the runtime actually sends |
| 2026-08-06 | `Set-Wsl2Fedora`'s `wsl --install` failed with `ERROR_ALREADY_EXISTS` on a distro that already existed; the non-zero `$LASTEXITCODE` went uncaught until it surfaced as `pwsh -f`'s own exit code | Check for the existing distro via `wsl --list --quiet` (needs `WSL_UTF8=1` — raw output is UTF-16 with embedded NULs) before calling `wsl --install` |
| 2026-08-06 | `msstore-apps.json`'s age-gated app (Amazon Kindle) failed under non-interactive `store install`, which prompts for age confirmation with no flag to skip it (checked `store install --help`) | Do not add age-restricted MS Store apps to `msstore-apps.json` |
| 2026-08-06 | First real run of `bootstrap_fedora.sh` (`set -e`) died on the first re-run of any "one-shot install" command: `rpm -i` (Microsoft repo), `dnf config-manager addrepo` (HashiCorp, Docker CE — both need `--overwrite` once the repo file exists), the AWS CLI installer, and the pyenv installer (refuses to run over an existing `~/.pyenv`) all error on an already-satisfied state | Every `install_*` function must check the target state before acting, not just call the vendor's one-shot installer |
| 2026-08-06 | The 2026-08-04 commit meant to fix `dnf group install development-tools` erroring, but never added `-y` — so on a no-op transaction (already installed) it still prompted `Is this ok [y/N]:`, and with no TTY that reads EOF → "Operation aborted by the user" | A "no changes needed" transaction still asks for confirmation in dnf; `-y` is required even when you expect zero work |
