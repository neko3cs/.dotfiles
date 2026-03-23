# neko3cs dotfiles

## インストール方法

### macOS

```sh
cd $HOME && git clone https://github.com/neko3cs/.dotfiles.git && cd $HOME/.dotfiles && bash bootstrap_macOS.sh
```

### Fedora

```sh
cd $HOME && git clone https://github.com/neko3cs/.dotfiles.git && cd $HOME/.dotfiles && bash bootstrap_fedora.sh
```

### Windows

WindowsにはGitが標準インストールされていないため、かつ、ついでにPowerShell Coreをインストールする。

```pwsh
winget install --silent --exact --id Git.Git; winget install --silent --exact --id Microsoft.PowerShell
```

ここでGitのパスを通すためにターミナルを再起動する。以降はPowerShell Core 7.0以上を使う。ここで管理者権限で起動しておくとwinget向けUACダイアログが1回で済む。

```pwsh
cd $HOME && git clone https://github.com/neko3cs/.dotfiles.git && cd $HOME/.dotfiles && pwsh -f Bootstrap-Windows.ps1
```

## インストーラーリンク集

各リポジトリになかったり、公式から取ってきた方がいいやつ。

### macOS

| パッケージ名                                                                           | 補足                                                                                             |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [.NET SDK](https://dotnet.microsoft.com/ja-jp/download)                                | homebrewにもあるけど、旧バージョンも入れたいなら個別に入れたほうがいい                           |
| [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)                   | [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip) |
| [Happy Hacking Keyboard - ダウンロード - PFU](https://happyhackingkb.com/jp/download/) | キーボードのドライバー更新など                                                                   |
| [Logi Options+Plus](https://www.logicool.co.jp/ja-jp/software/logi-options-plus.html)  | -                                                                                                |

### Windows

| パッケージ名                                                                                                                            | 補足                                                                                             |
| --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [.NET SDK](https://dotnet.microsoft.com/ja-jp/download)                                                                                 | VS Installerからインストールできるが、最新版がほしいなどの場合は個別に入れる                     |
| [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)                                                                    | [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip) |
| [Ctrl2cap - Windows Sysinternals - Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)                    | -                                                                                                |
| [Logi Options+Plus](https://www.logicool.co.jp/ja-jp/software/logi-options-plus.html)                                                   | -                                                                                                |
| [pdf_as - ファイルの部屋-Dream Space-](http://uchijyu.s601.xrea.com/wordpress/pdf_as/)                                                  | -                                                                                                |
| [ULE4JIS/publish at master · dezz/ULE4JIS](https://github.com/dezz/ULE4JIS/tree/master/publish)                                         | -                                                                                                |
| [カスタマイズ – かえうち](https://kaeuchi.jp/customize/)                                                                                | -                                                                                                |
| [プロセス エクスプローラー - Sysinternals - Microsoft Learn](https://learn.microsoft.com/ja-jp/sysinternals/downloads/process-explorer) | -                                                                                                |
