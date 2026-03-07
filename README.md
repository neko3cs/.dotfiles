# neko3cs dotfiles

## インストール方法

### macOS

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/main/bootstrap_macOS.sh | zsh
```

### Fedora

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/main/bootstrap_fedora.sh | bash
```

### Windows

WindowsにはGitが標準インストールされていないため、かつ、ついでにPowerShell Coreをインストールする。

```pwsh
winget install --silent --exact --id Git.Git && winget install --silent --exact --id Microsoft.PowerShell
```

ここでGitのパスを通すためにターミナルを再起動する。以降はPowerShell Core 7.0以上を使う。ここで管理者権限で起動しておくとwinget向けUACダイアログが1回で済む。

```pwsh
irm 'https://raw.githubusercontent.com/neko3cs/.dotfiles/main/Bootstrap-Windows.ps1' | iex
```

## インストーラーリンク集

各リポジトリになかったり、公式から取ってきた方がいいやつ。

### macOS

| パッケージ名                                                                           | 補足                                                                                             |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [.NET SDK](https://dotnet.microsoft.com/ja-jp/download)                                | homebrewにもあるけど、旧バージョンも入れたいなら個別に入れたほうがいい                           |
| [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)                   | [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip) |
| [Happy Hacking Keyboard - ダウンロード - PFU](https://happyhackingkb.com/jp/download/) | キーボードのドライバー更新など                                                                   |
| [iMovie](https://apps.apple.com/jp/app/imovie/id408981434?mt=12)                       | App Storeから                                                                                    |
| [Kindle](https://apps.apple.com/jp/app/kindle/id302584613)                             | App Storeから                                                                                    |
| [LINE](https://apps.apple.com/jp/app/line/id539883307?mt=12)                           | App Storeから                                                                                    |
| [Logi Options+Plus](https://www.logicool.co.jp/ja-jp/software/logi-options-plus.html)  | -                                                                                                |
| [RunCat](https://kyome.io/runcat/)                                                     | App Storeから                                                                                    |
| [Swift Playground](https://apps.apple.com/jp/app/swift-playgrounds/id1496833156?mt=12) | App Storeから                                                                                    |
| [Windows App](https://apps.apple.com/jp/app/windows-app/id1295203466?mt=12)            | App Storeから                                                                                    |
| [Xcode](https://apps.apple.com/jp/app/xcode/id497799835?mt=12)                         | App Storeから                                                                                    |

### Windows

| パッケージ名                                                                                                                            | 補足                                                                                             |
| --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [.NET SDK](https://dotnet.microsoft.com/ja-jp/download)                                                                                 | VS Installerからインストールできるが、最新版がほしいなどの場合は個別に入れる                     |
| [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)                                                                    | [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip) |
| [Ctrl2cap - Windows Sysinternals - Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)                    | -                                                                                                |
| [dotUltimate: 必要なすべての .NET と VS ツールを 1 つのパックで](https://www.jetbrains.com/ja-jp/dotnet/)                               | -                                                                                                |
| [Logi Options+Plus](https://www.logicool.co.jp/ja-jp/software/logi-options-plus.html)                                                   | -                                                                                                |
| [pdf_as - ファイルの部屋-Dream Space-](http://uchijyu.s601.xrea.com/wordpress/pdf_as/)                                                  | -                                                                                                |
| [RunCat](https://kyome.io/runcat/)                                                                                                      | リンク先最下部のGitHubリンクから                                                                 |
| [ULE4JIS/publish at master · dezz/ULE4JIS](https://github.com/dezz/ULE4JIS/tree/master/publish)                                         | -                                                                                                |
| [Windows App](https://apps.microsoft.com/detail/9n1f85v9t8bn?hl=ja-JP&gl=US)                                                            | Microsoft Storeから                                                                              |
| [カスタマイズ – かえうち](https://kaeuchi.jp/customize/)                                                                                | -                                                                                                |
| [プロセス エクスプローラー - Sysinternals - Microsoft Learn](https://learn.microsoft.com/ja-jp/sysinternals/downloads/process-explorer) | -                                                                                                |
