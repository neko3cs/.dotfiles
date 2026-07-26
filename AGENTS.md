# AGENTS.md

Cross-platform dotfiles for macOS, Fedora Linux, and Windows. Shell scripts, config files, and
package lists only — there are no application features, APIs, or user-facing products here.

## Development Rules

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
.codex/{config.toml, hooks.json, rules/custom.rules}
.config/{ghostty/config, bat/config, nvim/init.lua, zed/settings.json,
         powershell/Microsoft.PowerShell_profile.ps1}
.starship/starship.toml   .zshrc   .gitconfig   .textlintrc.json   Brewfile
bootstrap_macOS.sh  bootstrap_fedora.sh  Bootstrap-Windows.ps1
set_dotfiles.sh  Set-DotFiles.ps1  set_completions.sh  Set-Completions.ps1
play-sound.py  codex-path-guard.py
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
codex execpolicy check --rules .codex/rules/custom.rules -- git push origin main
```

Edit the other package lists directly.

`execpolicy check` returns a JSON `decision` for **raw argv only** — it skips the runtime's shell
splitting, so `bash -lc "git push"` will not match. To validate syntax and `match` / `not_match`
instead, send `initialize` then `thread/start` to `codex app-server` and watch for
`failed to parse rules file ...`. `codex doctor` and `codex debug models` never read rules.

## Tacit Knowledge

- **This repo's `.claude/` and `.codex/` are also read as *project* config**: running an agent
  inside this repo applies them on top of the user-level copies. Claude Code reads
  `.claude/settings.json` immediately, so the notification hook fires twice. Codex disables
  project-local layers until the project is trusted. Side effect of the mirror layout.
- **Never symlink a file the agent writes back to.** `.codex/config.toml` is copied because the
  Codex desktop app rewrites `[projects.*]` / `[mcp_servers.*]` / `[marketplaces.*]` / `notify` at
  runtime. Same reason the execpolicy file is `custom.rules`, not `default.rules`: choosing "always
  allow this prefix" appends `prefix_rule(..., decision="allow")` to `~/.codex/rules/default.rules`.
  Every `*.rules` under `rules/` is loaded, so a separate name keeps the tracked file clean.
  (`config.toml`'s `base_url` is a `{AZURE_FOUNDRY_BASE_URL}` placeholder — substitute by hand
  after deployment.)
- **Codex permissions live in execpolicy; hooks only patch its gaps**: commands →
  `.codex/rules/custom.rules` (Starlark `prefix_rule`, decision precedence
  forbidden > prompt > allow, with `match` / `not_match` validated at parse time as self-tests).
  Path conditions → `.codex/hooks.json` + `codex-path-guard.py`. `permission_profiles` is
  enterprise-only (`requirements.toml`) — do not use it.
- **execpolicy cannot express path rules**: the builtins are `prefix_rule` / `network_rule` /
  `host_executable` only (`path_rule` does not exist; `paths` is a `host_executable` parameter for
  absolute-path resolution). `prefix_rule` matches command prefixes, so "any command touching
  `.env`" would need cat/less/head/rg… × every path spelling, and `apply_patch` writes are not
  shell commands at all. That is the entire reason the hook still exists.
- **execpolicy misses shell-wrapped commands (known hole)**: Codex splits `bash -lc "..."` only when
  it is plain words joined by `&&` `||` `;` `|`. Redirection, variable expansion, command
  substitution, globs, or control flow → no split, the whole invocation counts as one command, and
  `prefix_rule` will not match (`bash -lc "git push > /dev/null"` slips past `forbidden`).
- **`decision = "prompt"` requires `approval_policy.granular.rules = true`**: under `never` it fails
  with `approval required by policy, but AskForApproval is set to Never`. `granular` is a newtype
  variant, so `[approval_policy.granular]` must list **all five fields** (omitting any is a parse
  error). Only `rules` is true, so anything outside an explicit rule still runs unattended.
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
- **`IS_WSL` depends on `$WSL_DISTRO_NAME`**: native Linux leaves both `IS_MACOS` and `IS_WSL`
  false. Do not assume Linux == WSL.
- **Windows bootstrap assumes `winget` and `git` are already installed**; the script does not
  install them.
- **Git Credential Manager installs differently per OS**: `bootstrap_fedora.sh`'s `install_gcm`
  branches between native Fedora (.NET tool + `secretservice`) and WSL (an interop wrapper around
  the Windows-side GCM). The reasoning is in the script's own comments.

## Open Issues

- [ ] `prompt` rules have never been observed raising an actual approval dialog — only the static
  decision via `codex execpolicy check` is verified. Needs an authenticated Codex session.
- [ ] `bootstrap_fedora.sh` and `Bootstrap-Windows.ps1` have never been executed (no Fedora or
  Windows machine at hand). Syntax-checked only; `dnf install -y uv` is unverified.
- [ ] Five `ask` entries are not ported to execpolicy: `gcloud` / `aws` / `az`
  delete·terminate·destroy need a mid-pattern wildcard, which `prefix_rule` cannot express.
  Workaround would be prompting on the whole CLI (`pattern = ["aws"]`) — rejected as too noisy.
- [ ] Shell-wrapped commands bypass `forbidden` (see Tacit Knowledge).
  `prefix_rule(pattern=["bash","-lc"], decision="prompt")` would close it, but then everyday
  commands containing globs such as `ls *.ts` all prompt.

## Handoff Snapshot (2026-07-26)

- Tests: N/A (dotfiles repo — no automated tests)
- In progress: nothing
- Decided: Reorganised config files to mirror their `$HOME` deploy paths, keeping scripts and
  package lists flat at the root. Ported `.claude/settings.json`'s `permissions` to Codex —
  commands to `.codex/rules/custom.rules` (execpolicy), and only the path conditions execpolicy
  cannot express to `.codex/hooks.json` + `codex-path-guard.py`. Changed `approval_policy` from
  `never` to `granular` (only `rules` true). Switched every hook to `uv run --no-project`.

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
