# AGENTS.md

Cross-platform dotfiles for macOS, Fedora Linux, and Windows. Shell scripts, config files, and
package lists only — there are no application features, APIs, or user-facing products here.

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
- **Bootstrap `install_*` / `Set-*` steps must check target state before acting.** One-shot
  installers are not idempotent — they error when the target already exists, and the failure often
  goes uncaught because it's a native command, not a cmdlet/builtin. Known cases: `rpm -i`,
  `dnf config-manager addrepo` (needs `--overwrite`), the AWS CLI and pyenv installers, and
  `wsl --install` (check `wsl --list --quiet` first, with `WSL_UTF8=1` — the raw output is UTF-16
  with embedded NULs).
- **Pass `-y` to every `dnf` command.** dnf asks for confirmation even on a no-op transaction, and
  with no TTY that reads EOF and aborts.
- **A config that gains a dependency needs it in the package list of every OS it deploys to** —
  `Brewfile` / `winget-package.json` / `dnf-packages.txt`.
- **Do not add age-restricted apps to `msstore-apps.json`.** Non-interactive `store install`
  prompts for age confirmation and has no flag to skip it.
- **Completions are generated per-machine** and untracked. Re-run `set_completions.sh` /
  `Set-Completions.ps1` after installing new tools.

## Layout

Only deployable config files mirror their destination. Scripts, package lists, and docs sit flat at
the repo root — do not create directories for them.

```
.claude/settings.json   .copilot/settings.json
.codex/{config.toml, hooks.json, rules/custom.rules, codex-guard.py}
.config/{ghostty/config, bat/config, nvim/init.lua,
         powershell/Microsoft.PowerShell_profile.ps1}
.starship/starship.toml   .zshrc   .gitconfig   Brewfile
bootstrap_macOS.sh  bootstrap_fedora.sh  Bootstrap-Windows.ps1
set_dotfiles.sh  Set-DotFiles.ps1  set_completions.sh  Set-Completions.ps1
dnf-packages.txt  winget-package.json  msstore-apps.json  go-tools.txt
dotnet-tools.txt  vscode-extensions.txt
```

**Multiple destinations** (cannot live at a single mirror path):

| File | Deployed to |
|---|---|
| `AGENTS.global.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md` |

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
  inside this repo applies them on top of the user-level copies, so a hook defined there fires
  twice. Codex disables project-local layers until the project is trusted. Side effect of the
  mirror layout.
- **Never symlink a file the agent writes back to.** `.codex/config.toml` is copied because the
  Codex desktop app rewrites `[projects.*]` / `[mcp_servers.*]` / `[marketplaces.*]` / `notify` at
  runtime. Same cause for `custom.rules` vs `default.rules`: Codex appends "always allow"
  decisions to `default.rules`, and every `*.rules` under `rules/` is loaded, so a separate name
  keeps the tracked file clean.
- **Codex permission routing is documented in `codex-guard.py`'s docstring.** Two things that are
  not written there: decision precedence is forbidden > prompt > allow, and `permission_profiles`
  is enterprise-only (`requirements.toml`) — do not use it, and do not re-investigate it.
- **Before concluding Codex lacks a mechanism, read every `--help` option and the official docs,
  and look for hidden top-level subcommands.** One negative result settles nothing:
  `codex execpolicy check` is absent from `--help`, and a CLI-looking struct name in the binary's
  strings (`ExecPolicyCheckCommand`) was the only hint.
- **(POSIX only) Codex splits `bash -lc "..."` only when it is plain words joined by
  `&&` `||` `;` `|`.** Redirection, variable expansion, command substitution, globs, or control
  flow → no split, the whole invocation counts as one command and `prefix_rule` never matches.
  `codex-guard.py` closes this by denying the wrapped form of the `forbidden` commands too
  (`UNSPLITTABLE_DENY`). The split condition there is inferred, not documented upstream.
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
  were checked. Re-investigate only when a Codex release note mentions the Windows shell; the
  measurement is otherwise taken as still valid. Because Windows has no approval flow, the guard
  applies `UNSPLITTABLE_DENY` unconditionally there: "if it cannot be confirmed, stop it".
  Before relying on permission control on any other OS, confirm with `codex exec --json` what the
  runtime actually sends.
- **`.codex/hooks.json` event names are PascalCase** (`PreToolUse` / `Stop` — Claude Code
  compatible). **An unknown event name is silently ignored, not an error**, so after adding one
  confirm it loaded via `codex app-server`'s `hooks/list`.
- **Codex hooks start untrusted**: Codex re-asks for trust whenever the content hash changes. One
  approval per machine.
- **Verify a new or changed hook by firing it with a real payload and checking the exit code.**
  Valid JSON and passing unit tests prove nothing: a hook calling `python -c` failed with exit 127
  unnoticed, and a `matcher` of `shell` never fired at all.
- **Call Python from hooks via `uv run --no-project python -c`**: this machine has no `python`, only
  `python3`; Windows is the reverse, and `uv` absorbs the difference (Fedora 43 ships `uv` in-repo;
  no curl installer needed). `--no-project` is mandatory: without it `uv` starts
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
- **During Codex's double-fire (see the entry above on `.claude`/`.codex` also being read as
  project config), one of the two duplicate invocations exited 1 instead of 0/2** during one
  verification; the deny from the other still took effect. Accepted as-is — the cause of the
  exit-1 duplicate was not found.
- **This file restates facts from `.codex/` and `.claude/settings.json`, and nothing keeps them in
  sync.** After editing those files, re-check every entry here that names them; when a change
  removes something, grep this file for its name in the same commit.
- **`_UNSPLITTABLE` in `codex-guard.py` is a guess, not a guarantee**, at which command bodies
  Codex refuses to split (see the file's own docstring). Windows sidesteps this by applying
  `UNSPLITTABLE_DENY` unconditionally, but macOS/Linux still depend on the guess being right.
- **Claude Code's `enabledPlugins` only takes effect at the user scope
  (`~/.claude/settings.json`, i.e. this repo's `.claude/settings.json`).** A project-level
  `.claude/settings.json` in some other repo cannot override it per-project — the key is silently
  ignored there, not merged. Confirmed via upstream GitHub issue
  anthropics/claude-code#62174 ("Support per-project enabledPlugins"), closed as not planned. Do
  not try to toggle LSP plugins per-repo again; toggle them here instead, globally.
- **All six LSP plugins are disabled in `enabledPlugins` on purpose**, even the ones in use.
  Claude Code re-appends each enabled plugin's `bin/` to `PATH` on every Bash call without dedup;
  that is the suspected (correlated, never reproduced) cause of Bash going silently inert after
  ~2 hours of use. Re-enabling one trades that risk for its features. If Bash starts silently
  no-op'ing or throwing quote errors mid-session, start a fresh session.
