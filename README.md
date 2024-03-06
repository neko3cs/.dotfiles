# neko3cs dotfiles

## インストール方法

### macOS

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/master/macOS-bootstrap.sh | zsh
```

### Ubuntu

```sh
curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/master/ubuntu-bootstrap.sh | bash
```

### Windows

```pwsh
powershell `
-ExecutionPolicy ByPass `
-Command {
  Invoke-RestMethod `
    -Uri 'https://raw.githubusercontent.com/neko3cs/.dotfiles/master/windows-bootstrap.ps1' |
  Invoke-Expression
}
```

## インストーラーリンク集

各リポジトリになかったり、公式から取ってきた方がいいやつ。

### macOS

- [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)
  - Change `"CaskaydiaCove Nerd Font"` on Terminal Settings

### Windows

- [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)
  - Change `"CaskaydiaCove Nerd Font"` on Windows Terminal Settings
- [Ctrl2cap - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)
- [カスタマイズ – かえうち](https://kaeuchi.jp/customize/)
- [dotUltimate: 必要なすべての .NET と VS ツールを 1 つのパックで](https://www.jetbrains.com/ja-jp/dotnet/)
