# neko3cs dotfiles

## インストール方法

### macOS

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/main/macOS-bootstrap.sh | zsh
```

### Ubuntu

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/main/ubuntu-bootstrap.sh | bash
```

### Windows

```pwsh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
winget install --silent --exact --id Git.Git
# ここでGitのパスを通すためにターミナルを管理者権限で再起動
Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/neko3cs/.dotfiles/main/windows-bootstrap.ps1' | Invoke-Expression
```

## インストーラーリンク集

各リポジトリになかったり、公式から取ってきた方がいいやつ。

### macOS

- [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)
  - [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip)
  - Change `"CaskaydiaCove Nerd Font"` on Terminal Settings

### Windows

- [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)
  - [Direct Link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip)
  - Change `"CaskaydiaCove Nerd Font"` on Windows Terminal Settings
- [Ctrl2cap - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)
- [カスタマイズ – かえうち](https://kaeuchi.jp/customize/)
- [dotUltimate: 必要なすべての .NET と VS ツールを 1 つのパックで](https://www.jetbrains.com/ja-jp/dotnet/)
