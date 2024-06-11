# neko3cs dotfiles

## インストール方法

### macOS

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/main/bootstrap_macOS.sh | zsh
```

### Ubuntu

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/main/bootstrap_ubuntu.sh | bash
```

### Windows

```pwsh
winget install --silent --exact --id Git.Git
# ここでGitのパスを通すためにターミナルを再起動
# ※管理者権限で起動しておくとwinget向けUACダイアログが1回で済む
irm 'https://raw.githubusercontent.com/neko3cs/.dotfiles/main/Bootstrap-Windows.ps1' | iex
```

## インストーラーリンク集

各リポジトリになかったり、公式から取ってきた方がいいやつ。

### All

- [RunCat](https://kyome.io/runcat/)
  - macOS: App Storeから
  - Windows: リンク先最下部のGitHubリンクから
- [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)
  - [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip)
- [.NET SDK](https://dotnet.microsoft.com/ja-jp/download)
  - WindowsはVisual Studioから入れても良い

### Windows

- [Ctrl2cap - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)
- [カスタマイズ – かえうち](https://kaeuchi.jp/customize/)
- [ULE4JIS/publish at master · dezz/ULE4JIS](https://github.com/dezz/ULE4JIS/tree/master/publish)
- [dotUltimate: 必要なすべての .NET と VS ツールを 1 つのパックで](https://www.jetbrains.com/ja-jp/dotnet/)
