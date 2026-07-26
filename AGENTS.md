# AGENTS.md

Cross-platform dotfiles for macOS, Fedora Linux, and Windows. Shell scripts, config files, and
package lists only — there are no application features, APIs, or user-facing products here.

## Development Rules

- **No automated tests.** Verify by running `set_dotfiles.sh` and sourcing `.zshrc` manually.
- **設定ファイルは配置先と同じフォルダ構成でリポジトリに置く。** `.claude/settings.json` は
  `~/.claude/settings.json` へ、`.config/ghostty/config` は `~/.config/ghostty/config` へ。
  新しい設定ファイルを足すときはこの規則に従う。例外は下表の「配置先が複数のもの」だけ。
- **Platform guards are mandatory.** Any macOS-only or WSL-only config in `.zshrc` must be wrapped
  in `if $IS_MACOS` / `if $IS_WSL`. `.zshrc` sets both booleans at startup
  (`$OSTYPE == darwin*` / `$WSL_DISTRO_NAME` is set).
- **Machine-specific settings** (`user.name`, `user.email`, Linux credential store) go in
  `~/.gitconfig.local`, included via `[include]` from `.gitconfig`. Never committed.
- **スクリプトからリポジトリ内のファイルを参照するときは `$SCRIPT_ROOT` / `$PSScriptRoot` を前置する。**
  裸の相対パスは cwd がリポジトリルートのときしか動かない。
- **Completions are generated per-machine** and not tracked. Re-run `set_completions.sh` /
  `Set-Completions.ps1` after installing new tools.

## Layout

配置対象の設定ファイルだけが配置先ミラー。スクリプト・パッケージリスト・ドキュメントは
リポジトリ直下に平置きで、ディレクトリは作らない。

```
.claude/settings.json   .codex/{config.toml,hooks.json}   .copilot/settings.json
.config/{ghostty/config, bat/config, nvim/init.lua, zed/settings.json,
         powershell/Microsoft.PowerShell_profile.ps1}
.starship/starship.toml   .zshrc   .gitconfig   .textlintrc.json   Brewfile
bootstrap_macOS.sh  bootstrap_fedora.sh  Bootstrap-Windows.ps1
set_dotfiles.sh  Set-DotFiles.ps1  set_completions.sh  Set-Completions.ps1
play-sound.py  codex-deny-guard.py
dnf-packages.txt  winget-package.json  msstore-apps.json  npm-packages.txt
dotnet-tools.txt  vscode-extensions.txt
```

**配置先が複数のもの**（ミラー構成に置けない例外）:

| File | Deployed to |
|---|---|
| `AGENTS.global.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md` |
| `.config/zed/settings.json` | `~/.config/zed/settings.json` (Win: `%APPDATA%\Zed\settings.json`) |

**cp されるもの**（他は全て `ln -sf`）: `.codex/config.toml`,
`.config/powershell/Microsoft.PowerShell_profile.ps1`

**配置されないもの**: `vscode-settings.json` と `.vssettings` は手動インポート用の参照スナップ
ショット。Settings Sync と競合するため symlink しない。

## Commands

```sh
# 初回セットアップ
zsh bootstrap_macOS.sh          # macOS
bash bootstrap_fedora.sh        # Fedora / WSL (root ではなく sudo を使える一般ユーザーで)
pwsh -f Bootstrap-Windows.ps1   # Windows (管理者権限の PowerShell 7+)

# dotfiles の再配置のみ
zsh set_dotfiles.sh
pwsh -File Set-DotFiles.ps1     # Windows は管理者権限

# 補完の再生成のみ
zsh set_completions.sh
pwsh -File Set-Completions.ps1

# Brewfile を現在の環境と同期
brew bundle dump --force
```

その他のパッケージリストは直接編集する。

## Tacit Knowledge

- **リポジトリの `.claude/settings.json` は Claude Code の「プロジェクト設定」としても読まれる**:
  この dotfiles リポジトリ自体で Claude Code を動かすと、ユーザー設定 (`~/.claude/settings.json`)
  と二重に適用され、通知音のフックが2回鳴る。配置先ミラー構成の副作用。
- **PowerShell profile is copied, not symlinked**: `$PROFILE` のパスが OS ごとに違い、単一の
  symlink 先で両立できない。
- **Windows は意図的に一部しか配置しない**: `Set-DotFiles.ps1` は `.zshrc` / `ghostty` /
  `init.lua` / `Brewfile` を配置しない。macOS でも pwsh は補助用途でプロファイルのみ配置する。
  メインシェルは zsh であり、これは欠落ではなく設計。
- **zinit for zsh plugins**: 初回シェル起動時に自動インストールされ、`wait'0'` で遅延ロードする。
  bootstrap 側でのプラグイン導入手順は不要。
- **`IS_WSL` は `$WSL_DISTRO_NAME` 依存**: ネイティブ Linux は `IS_MACOS` も `IS_WSL` も false に
  なる。Linux == WSL と仮定しないこと。
- **Windows bootstrap は `winget` と `git` が導入済み前提**: スクリプトは入れない。
- **PowerShell モジュールは手動導入**: プロファイル内の `Install-PowerShellModules` は自動実行
  されない。新しいマシンで一度だけ実行する。
- **`.codex/config.toml` は cp**: Codex デスクトップアプリが `[projects.*]` / `[mcp_servers.*]` /
  `[marketplaces.*]` / `notify` を実行時に書き戻すため、symlink すると追跡ファイルが汚れる。
  `base_url` は `{AZURE_FOUNDRY_BASE_URL}` プレースホルダで、配置後に手で実 URL に置換する。
- **Codex には allow/deny/ask のユーザー設定が無い**: `permission_profiles` は企業向け
  `requirements.toml` 専用、`exec_permission_approvals` feature は未実装 (0.145 時点)。そのため
  `.claude/settings.json` の `permissions.deny` は `.codex/hooks.json` の `PreToolUse` +
  `codex-deny-guard.py` で再現している。**`ask` は再現不可** (`PreToolUse` が返せるのは `deny`
  のみで、`allow` / `ask` はバイナリ側で拒否される)。
- **`.codex/hooks.json` のイベント名は PascalCase**: `PreToolUse` / `Stop` など Claude Code 互換。
  **未知のイベント名はエラーにならず黙って無視される**ので、追加時は `codex app-server` の
  `hooks/list` で読み込まれたか確認すること。
- **Codex のフックは初回 untrusted**: 内容のハッシュが変わるたびに Codex が信頼を確認してくる。
  マシンごとに一度承認が必要。
- **Git Credential Manager は OS ごとに導入方法が違う**: `bootstrap_fedora.sh` の `install_gcm` が
  native Fedora（.NET tool + `secretservice`）と WSL（Windows 側 GCM への interop ラッパー）で
  分岐する。理由はスクリプト内のコメントに書いてある。

## Handoff Snapshot (2026-07-26)

- Tests: N/A (dotfiles repo — no automated tests)
- In progress: nothing
- Decided: 設定ファイルを「$HOME の配置先と同じフォルダ構成」へ再編。スクリプトとパッケージ
  リストは平置きのまま。Codex 用に `.codex/hooks.json` と `codex-deny-guard.py` を新設し、
  `.claude/settings.json` の deny リストを移植した。
- 未検証: `bootstrap_fedora.sh` と `Bootstrap-Windows.ps1` は当該 OS が手元に無く未実行。

## Incidents

| Date | What went wrong | Prevention |
| :--- | :--- | :--- |
| 2026-07-12 | `.gitconfig` に `.gitconfig.local` の `[include]` が無く、`user.name`/`user.email` が読み込まれていなかった | 設定を分割したら、分割先の存在だけでなく `[include]` 側が書かれたかを確認する |
| 2026-07-12 | `NODE_EXTRA_CA_CERTS` を無条件で Linux 専用パスに設定し、macOS の pnpm 等が壊れた | `.zshrc` の env/PATH 追加は「platform guards are mandatory」に照らしてから入れる。1 OS のテストで済ませない |
| 2026-07-26 | `bootstrap_fedora.sh` の `dnf-packages.txt` と `Bootstrap-Windows.ps1` の `msstore-apps.json` が裸の相対パス参照で、cwd がリポジトリルートのときしか動かなかった | スクリプトからリポジトリ内ファイルを参照するときは必ず `$SCRIPT_ROOT` / `$PSScriptRoot` を前置する |
