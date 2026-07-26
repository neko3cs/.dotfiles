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

- **リポジトリの `.claude/` と `.codex/` はプロジェクト設定としても読まれる**: この dotfiles
  リポジトリ自体でエージェントを動かすと、ユーザー設定と二重に適用される。Claude Code は
  `.claude/settings.json` を即座に読むので通知音のフックが2回鳴る。Codex は project-local を
  trusted になるまで無効化するので、このリポジトリを信頼させると hooks と execpolicy が
  二重ロードされる。配置先ミラー構成の副作用。
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
- **Codex の権限制御は execpolicy が本筋。フックは穴埋め**: `.claude/settings.json` の
  `permissions` は2箇所に分けて移植してある。`permission_profiles` は企業向け
  `requirements.toml` 専用なので使わない。
  - **コマンド単位** → `.codex/rules/custom.rules` (Starlark)。`prefix_rule(pattern=[...],
    decision="forbidden"|"prompt"|"allow", justification=..., match=[...], not_match=[...])`。
    `pattern` の要素は文字列または選択肢のリスト。decision の優先順位は
    forbidden > prompt > allow。`match` / `not_match` はパース時に検証される自己テスト。
  - **パス単位のみ** → `.codex/hooks.json` の `PreToolUse` + `codex-path-guard.py`。理由は下項。
- **ファイル名が `custom.rules` なのは `default.rules` を Codex 自身が書き換えるから**:
  「このプレフィックスを常に許可」を選ぶと `~/.codex/rules/default.rules` に
  `prefix_rule(..., decision="allow")` が追記される。`rules/` 配下の `*.rules` は全て読まれる
  ので、追記対象と追跡ファイルを分ける。`config.toml` を cp にしているのと同じ理由。
- **パス単位の deny だけフックに残っている理由**: execpolicy の builtin は `prefix_rule` /
  `network_rule` / `host_executable` の3つだけで、**ファイルパスを条件にしたルールが書けない**
  (`path_rule` は存在しない。`paths` は `host_executable` のパラメータで、絶対パス解決用)。
  `prefix_rule` は前置一致しか書けないので「どのコマンドであれ `.env` に触る」を表現するには
  cat/less/head/rg… × `.env`/`.env.local`/`path/to/.env` の総当たりが必要になる。加えて
  `apply_patch` の書き込みはシェルコマンドではないので execpolicy の管轄外。
- **execpolicy はシェルでラップされると届かないことがある (既知の穴)**: Codex は `bash -lc "..."`
  を「プレーンな語が `&&` `||` `;` `|` でつながっているだけ」のときだけ分割してポリシーに渡す。
  リダイレクト・変数展開・コマンド置換・ワイルドカード・制御構文が入ると分割せず invocation
  全体を1コマンドとして扱うため、`prefix_rule` がマッチしない
  (`bash -lc "git push > /dev/null"` は forbidden をすり抜ける)。
  `prefix_rule(pattern=["bash","-lc"], decision="prompt")` で塞げるが、`ls *.ts` のような
  グロブを含む日常的なコマンドまで全部確認が入るため採用していない。
- **`decision = "prompt"` は `approval_policy.granular.rules = true` が必須**: `never` のままだと
  `approval required by policy, but AskForApproval is set to Never` で機能しない。`granular` は
  newtype variant なので `[approval_policy.granular]` に**5フィールドすべて**書く必要がある
  (省略するとパースエラー)。`rules` 以外を false にしてあるので、明示ルール以外は従来どおり全自動。
- **execpolicy に移植できなかった ask**: `aws * delete` のように**途中にワイルドカードが入る
  パターンは `prefix_rule` で書けない**。`gcloud`/`aws`/`az` の delete・terminate・destroy 系の
  5件は未移植 (`curl -X DELETE` は `-X DELETE` が先頭に来る形だけ移植済み)。
  `pattern = ["aws"]` のように CLI 全体を prompt にすれば拾えるが騒がしくなるため見送った。
- **`.rules` の検証は `codex execpolicy check`**: `codex --help` に出てこない隠しサブコマンド。

  ```sh
  codex execpolicy check --rules .codex/rules/custom.rules -- git push origin main
  ```

  JSON で `decision` が返る。**引数は生の argv で、ランタイム側のシェル分割は通らない**ので、
  `bash -lc "git push"` を渡してもマッチしない (上の「シェルでラップされると届かない」を参照)。
  構文と `match`/`not_match` の検証だけなら `codex app-server` に `initialize` → `thread/start`
  を投げると `failed to parse rules file ...` が出る。`codex doctor` と `codex debug models` は
  ルールを読まないので使えない。
- **`.codex/hooks.json` のイベント名は PascalCase**: `PreToolUse` / `Stop` など Claude Code 互換。
  **未知のイベント名はエラーにならず黙って無視される**ので、追加時は `codex app-server` の
  `hooks/list` で読み込まれたか確認すること。
- **Codex のフックは初回 untrusted**: 内容のハッシュが変わるたびに Codex が信頼を確認してくる。
  マシンごとに一度承認が必要。
- **フックから Python を呼ぶときは `uv run --no-project python -c`**: このマシンに `python` は
  無く `python3` だけ、Windows は逆という差を `uv` が吸収する。**フックを配置する全 OS に `uv`
  の導入元が要る**: Brewfile / `winget-package.json` / `dnf-packages.txt` (対象の Fedora 43 は
  リポジトリに `uv` がある。curl インストーラは不要)。`--no-project` は必須で、これが無いと
  **エージェントの作業先が Python プロジェクトだったときに `uv` がそのプロジェクトの依存解決を
  始めてフックが壊れる**。
  パスは shell の `~` 展開に頼らず `os.path.expanduser` で解決する (cmd では `~` が展開されない)。
  exit code は `uv run` を通しても伝播するので、PreToolUse の deny (exit 2) はそのまま効く。
- **Git Credential Manager は OS ごとに導入方法が違う**: `bootstrap_fedora.sh` の `install_gcm` が
  native Fedora（.NET tool + `secretservice`）と WSL（Windows 側 GCM への interop ラッパー）で
  分岐する。理由はスクリプト内のコメントに書いてある。

## Handoff Snapshot (2026-07-26)

- Tests: N/A (dotfiles repo — no automated tests)
- In progress: nothing
- Decided: 設定ファイルを「$HOME の配置先と同じフォルダ構成」へ再編。スクリプトとパッケージ
  リストは平置きのまま。`.claude/settings.json` の `permissions` を Codex へ移植し、コマンド系は
  `.codex/rules/custom.rules` (execpolicy)、execpolicy で表現できないパス条件だけを
  `.codex/hooks.json` + `codex-path-guard.py` に残した。`approval_policy` を `never` から
  `granular` (rules のみ true) へ変更。
- 未検証: `bootstrap_fedora.sh` と `Bootstrap-Windows.ps1` は当該 OS が手元に無く未実行。
  `prompt` ルールが実際に承認ダイアログを出すところまでは、認証付きセッションが必要なため未確認。

## Incidents

| Date | What went wrong | Prevention |
| :--- | :--- | :--- |
| 2026-07-12 | `.gitconfig` に `.gitconfig.local` の `[include]` が無く、`user.name`/`user.email` が読み込まれていなかった | 設定を分割したら、分割先の存在だけでなく `[include]` 側が書かれたかを確認する |
| 2026-07-12 | `NODE_EXTRA_CA_CERTS` を無条件で Linux 専用パスに設定し、macOS の pnpm 等が壊れた | `.zshrc` の env/PATH 追加は「platform guards are mandatory」に照らしてから入れる。1 OS のテストで済ませない |
| 2026-07-26 | `bootstrap_fedora.sh` の `dnf-packages.txt` と `Bootstrap-Windows.ps1` の `msstore-apps.json` が裸の相対パス参照で、cwd がリポジトリルートのときしか動かなかった | スクリプトからリポジトリ内ファイルを参照するときは必ず `$SCRIPT_ROOT` / `$PSScriptRoot` を前置する |
| 2026-07-26 | Codex の権限機構の調査で `permission_profiles` が managed config 専用と分かった時点で「ユーザー設定は無い」と結論し、同じ調査結果に出ていた execpolicy (`.rules`) を追わなかった。結果 `ask` を「再現不可」と誤報告し、宣言的に書けるものを Python フックで実装した | 機構の有無を判定するときは、1つの否定的な結果で打ち切らない。`--help` の全オプション (今回は `--ignore-rules`) と公式ドキュメントを当たってから結論を出す |
| 2026-07-26 | execpolicy のルールを `default.rules` に置いた。Codex が「常に許可」の追記先として同名ファイルを書き換えるため、追跡ファイルが汚れるところだった | エージェントが実行時に書き戻すファイルは symlink しない。書き戻し先と追跡ファイルを別名にする (`config.toml` を cp にしているのと同じ判断) |
| 2026-07-26 | サブコマンドを `codex debug` の下だけ探し、トップレベルの隠しコマンド `codex execpolicy check` を見つけられなかった。検証手段が無いと判断して app-server のパースエラーで代用していた | `--help` に出ないサブコマンドがある。バイナリの文字列 (今回は `ExecPolicyCheckCommand`) に CLI らしき構造体名が見えたら、トップレベルでも試す |
| 2026-07-26 | `.claude/settings.json` の通知音フックが `python -c` を呼んでいたが、macOS には `python` が無く `python3` だけのため、ずっと無言で失敗していた (exit 127)。Codex のフックにも同じ形をコピーしていた | フックは「JSON として妥当」で満足せず、シェル経由で実際に走らせて exit code まで確認する。インタプリタ名は `uv run` で吸収する |
| 2026-07-26 | フックの `python -c` を `uv run` に置き換えたとき、`uv` の導入元を Brewfile と `winget-package.json` にしか足さず、`dnf-packages.txt` が漏れた。`set_dotfiles.sh` は Fedora/WSL にもフックを配置するので、そこでは両フックが `uv: command not found` で死ぬところだった | フックが依存するコマンドを増やしたら、その設定を**配置している全 OS** のパッケージリストに入っているか確認する。macOS だけで動作確認して終わらせない |
