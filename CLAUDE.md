# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository managing configuration files and tooling setup for macOS, Fedora Linux, and Windows.

## Bootstrap Commands

### macOS (initial setup)
```sh
zsh bootstrap_macOS.sh
```
Runs `softwareupdate`, applies macOS system defaults, installs Homebrew, runs `brew bundle`, then calls `set_dotfiles.sh` and `set_completions.sh`.

### Fedora (initial setup)
```sh
bash bootstrap_fedora.sh
```
Configures locale/timezone, adds third-party DNF repos (Microsoft, HashiCorp, lazygit, zsh-completions), installs packages from `dnf-packages.txt`, then calls `set_dotfiles.sh` and `set_completions.sh`.

### Windows (initial setup, run as Administrator in PowerShell 7+)
```pwsh
pwsh -f Bootstrap-Windows.ps1
```
Imports packages from `winget-package.json`, calls `Set-DotFiles.ps1` and `Set-Completions.ps1`, installs WSL2 with FedoraLinux-43.

## Dotfiles Deployment (without full bootstrap)

Re-apply symlinks and copy config files only:
```sh
# macOS / Linux
zsh set_dotfiles.sh

# Windows (run as Administrator)
pwsh -File Set-DotFiles.ps1
```

Re-generate shell completions only:
```sh
# zsh
zsh set_completions.sh

# PowerShell
pwsh -File Set-Completions.ps1
```

## Updating Package Lists

```sh
# Sync Brewfile with currently installed packages
brew bundle dump --force
```

For `dnf-packages.txt`, `npm-packages.txt`, `dotnet-tools.txt`, and `vscode-extensions.txt`, update manually by editing the files directly.

## Architecture

### Symlink Strategy
`set_dotfiles.sh` creates symlinks (`ln -sf`) from the repo into `$HOME` for most configs. Exceptions: `Microsoft.PowerShell_profile.ps1` is copied (not symlinked) because PowerShell profile paths differ per OS; on Windows, `Set-DotFiles.ps1` uses `Copy-Item` or `New-Item -ItemType SymbolicLink` depending on the file.

### Platform Detection
`.zshrc` sets `IS_MACOS` and `IS_WSL` booleans at startup and gates platform-specific PATH entries, environment variables, and aliases behind them.

### Shell Plugin Management
Zsh plugins are managed by [zinit](https://github.com/zdharma-continuum/zinit) (auto-installed on first shell start). Active plugins: `zsh-completions`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-abbrev-alias`.

### Config File → Symlink Destination Mapping
| File in repo | Deployed to |
|---|---|
| `.zshrc` | `~/.zshrc` |
| `starship.toml` | `~/.starship/starship.toml` |
| `ghostty_config` | `~/.config/ghostty/config` |
| `bat_config` | `~/.config/bat/config` |
| `init.lua` | `~/.config/nvim/init.lua` |
| `.gitconfig` | `~/.gitconfig` |
| `Microsoft.PowerShell_profile.ps1` | `~/.config/powershell/Microsoft.PowerShell_profile.ps1` |
| `.textlintrc.json` | `~/.textlintrc.json` |
| `Brewfile` | `~/Brewfile` |
| `claude-settings.json` | `~/.claude/settings.json` |

### Git Config
`.gitconfig` includes `.gitconfig.local` via `[include]` — machine-specific settings (e.g., user name/email) go there and are not tracked in this repo.
