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

`vscode-settings.json` is a reference file kept in the repo but **not symlinked** — apply it manually via VS Code Settings Sync or copy it manually.

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

## Why Certain Decisions Were Made

- **`Microsoft.PowerShell_profile.ps1` is copied, not symlinked**: The `$PROFILE` path differs between macOS and Windows, so a single symlink target cannot satisfy both. Copying on each `set_dotfiles.sh` run keeps the file up to date without requiring per-OS symlink paths.
- **`.gitconfig.local` is not tracked**: User name and email are machine-specific and must not leak into a public repo. The `[include]` mechanism in `.gitconfig` loads it transparently when present.
- **zinit is chosen for zsh plugins**: It auto-installs on first shell start with no separate setup step, making bootstrapping simpler. Plugins are loaded lazily (`wait'0'`).
- **`vscode-settings.json` is not symlinked**: VS Code's settings path differs by OS and can also be managed by VS Code Settings Sync, so symlinking would conflict. The file is kept in the repo as a reference snapshot.

## Implicit Constraints

- `IS_WSL` detection relies on `$WSL_DISTRO_NAME` being set by the WSL distro. Native Linux (non-WSL) will have both `IS_MACOS=false` and `IS_WSL=false`.
- The Fedora bootstrap assumes the user runs it as a regular user with `sudo` access, not as root.
- The Windows bootstrap requires `winget` and `git` to already be installed before running — it does not install them.
- PowerShell modules (`Az`, `Pester`, etc.) are installed via `Install-PowerShellModules` which is defined in the profile but not called automatically — run it manually when setting up a new machine.

## Open Issues

None currently known.

## Current State (2026-06-24)

- **Recently added**: `copilot-settings.json` symlink for GitHub Copilot settings (`~/.copilot/settings.json`)
- **AGENTS.md**: Created for the first time today; CLAUDE.md now delegates to this file via `@AGENTS.md`
- **All bootstrap scripts**: Verified against actual script content; descriptions in docs were updated to match
- **No in-progress tasks**
