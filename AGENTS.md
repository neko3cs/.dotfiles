# AGENTS.md

## What This Project Is

A cross-platform dotfiles repository managing configuration files and tooling setup for macOS, Fedora Linux, and Windows. The goal is a single source of truth for personal shell, editor, and tool configuration across all machines.

There are no application features, APIs, or user-facing products here — only shell scripts, config files, and package lists.

## Architecture

### Symlink Strategy

`set_dotfiles.sh` creates symlinks (`ln -sf`) from the repo root into `$HOME` for most configs. `Microsoft.PowerShell_profile.ps1` is copied (`cp -f`), not symlinked, because `$PROFILE` paths differ per OS. On Windows, `Set-DotFiles.ps1` uses `New-Item -ItemType SymbolicLink` or `Copy-Item` accordingly.

### Platform Detection

`.zshrc` sets `IS_MACOS` (`$OSTYPE == darwin*`) and `IS_WSL` (`$WSL_DISTRO_NAME` is set) booleans at startup. All platform-specific PATH entries, environment variables, and aliases are gated behind these booleans.

### Shell Plugin Management

Zsh plugins are managed by [zinit](https://github.com/zdharma-continuum/zinit), which auto-installs on first shell start. Active plugins: `zsh-completions`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-abbrev-alias`.

### Prompt

[Starship](https://starship.rs/) is used for both zsh and PowerShell. Config: `starship.toml` → `~/.starship/starship.toml`.

## Config File → Symlink Destination Mapping

| File in repo | Deployed to |
|---|---|
| `.zshrc` | `~/.zshrc` |
| `starship.toml` | `~/.starship/starship.toml` |
| `ghostty_config` | `~/.config/ghostty/config` |
| `bat_config` | `~/.config/bat/config` |
| `init.lua` | `~/.config/nvim/init.lua` |
| `.gitconfig` | `~/.gitconfig` |
| `Microsoft.PowerShell_profile.ps1` | `~/.config/powershell/Microsoft.PowerShell_profile.ps1` (copied, not symlinked) |
| `.textlintrc.json` | `~/.textlintrc.json` |
| `Brewfile` | `~/Brewfile` |
| `claude-settings.json` | `~/.claude/settings.json` |
| `copilot-settings.json` | `~/.copilot/settings.json` |
| `codex-config.toml` | `~/.codex/config.toml` (copied, not symlinked) |

`vscode-settings.json` is a reference file kept in the repo but **not symlinked** — apply it manually via VS Code Settings Sync or copy it manually.

`codex-config.toml`'s `base_url` is a `{AZURE_FOUNDRY_BASE_URL}` placeholder — fill in the real Azure Foundry endpoint by hand in `~/.codex/config.toml` after deployment. It's copied rather than symlinked because the Codex desktop app rewrites this file at runtime (auto-generated fields like `[projects.*]`, `[mcp_servers.*]`); symlinking would let that churn dirty the tracked source.

## Commands

### Bootstrap (first-time setup)

```sh
# macOS
zsh bootstrap_macOS.sh
# Runs softwareupdate, applies macOS system defaults, installs Homebrew,
# runs brew bundle, then calls set_dotfiles.sh, set_completions.sh, Set-Completions.ps1

# Fedora Linux
bash bootstrap_fedora.sh
# Configures locale/timezone, adds DNF repos (Microsoft, HashiCorp, lazygit, zsh-completions),
# installs packages from dnf-packages.txt, calls set_dotfiles.sh,
# installs AWS CLI / Docker CE / pyenv / starship via curl/installer,
# then calls set_completions.sh and Set-Completions.ps1

# Windows (run as Administrator in PowerShell 7+)
pwsh -f Bootstrap-Windows.ps1
# Requires winget and git to be pre-installed.
# Imports packages from winget-package.json, calls Set-DotFiles.ps1 and Set-Completions.ps1,
# installs WSL2 with FedoraLinux-43, enables Windows Optional Features (Hyper-V, WSL, VirtualMachinePlatform)
```

### Re-apply dotfiles only

```sh
# macOS / Linux
zsh set_dotfiles.sh

# Windows (run as Administrator)
pwsh -File Set-DotFiles.ps1
```

### Re-generate shell completions only

```sh
# zsh
zsh set_completions.sh

# PowerShell
pwsh -File Set-Completions.ps1
```

### Update package lists

```sh
# Sync Brewfile with currently installed packages
brew bundle dump --force
```

For `dnf-packages.txt`, `npm-packages.txt`, `dotnet-tools.txt`, and `vscode-extensions.txt`, edit the files directly.

## Development Rules

- **No automated tests.** This is a dotfiles repo — verify changes by running `set_dotfiles.sh` and sourcing `.zshrc` manually.
- **Machine-specific settings** (user.name, user.email, etc.) go in `~/.gitconfig.local`, which is included via `[include]` in `.gitconfig` and is never committed.
- **Platform guards are mandatory.** Any macOS-only or WSL-only config in `.zshrc` must be wrapped in `if $IS_MACOS` or `if $IS_WSL`.
- **Completions are generated per-machine.** The generated files under `~/.zsh/completion/` and `~/.config/powershell/completions/` are not tracked in git. Re-run `set_completions.sh` / `Set-Completions.ps1` after installing new tools.

## Tacit Knowledge

- **PowerShell profile is copied, not symlinked**: `$PROFILE` path differs per OS; a single symlink target can't satisfy both macOS and Windows.
- **`.gitconfig.local` is not tracked**: Stores machine-specific user.name/email that must not appear in a public repo. Loaded transparently via `[include]` in `.gitconfig`.
- **zinit for zsh plugins**: Auto-installs on first shell start with no separate step. Plugins load lazily (`wait'0'`), so bootstrapping needs no manual plugin setup.
- **`vscode-settings.json` is not symlinked**: VS Code settings path differs by OS and can conflict with Settings Sync. Kept as a reference snapshot only.
- **`IS_WSL` relies on `$WSL_DISTRO_NAME`**: Native Linux (non-WSL) will have both `IS_MACOS=false` and `IS_WSL=false`. Do not assume Linux == WSL.
- **Fedora bootstrap must run as non-root with sudo**: The script uses `sudo` internally; running as root breaks ownership assumptions.
- **Windows bootstrap requires `winget` and `git` pre-installed**: The script does not install them; it will fail early if they are missing.
- **PowerShell modules need manual install**: `Install-PowerShellModules` is defined in the profile but not called automatically — run it once when setting up a new machine.

## Open Issues

None currently known.

## Handoff Snapshot (2026-07-13)

- Tests: N/A (dotfiles repo — no automated tests)
- In progress: nothing
- Decided: Fixed `.gitconfig` missing its `[include]` directive for `.gitconfig.local` (design was documented but never wired up). Restricted `NODE_EXTRA_CA_CERTS` to `$IS_WSL` since the referenced cert path doesn't exist on macOS. Renamed `codex-app` → `chatgpt` cask in Brewfile (app was discontinued/rebranded). Fixed `PNPM_HOME` PATH entry to include `/bin`. Added `node` brew formula.

## Incidents

| Date | What went wrong | Prevention |
| :--- | :--- | :--- |
| 2026-07-12 | `.gitconfig` had no `[include]` section for `.gitconfig.local`, so `user.name`/`user.email` were never actually loaded despite AGENTS.md documenting that design | When splitting config into an included file, verify the `[include]` directive itself was added, not just the included file's existence |
| 2026-07-12 | `NODE_EXTRA_CA_CERTS` was set unconditionally in `.zshrc` pointing to a Linux-only cert path, breaking pnpm and other Node tools on macOS | New env vars/PATH entries in `.zshrc` must be checked against the "platform guards are mandatory" rule before merging, not just tested on one OS |
