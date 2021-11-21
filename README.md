# neko3cs dotfiles

## macOS

Run this.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/master/macOS-bootstrap.sh)"
```

## ubuntu

Run this.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/neko3cs/.dotfiles/master/ubuntu-bootstrap.sh)"
```

## windows

Run this.

```pwsh
powershell `
-ExecutionPolicy ByPass `
-Command {
  Invoke-RestMethod `
    -Uri 'https://raw.githubusercontent.com/neko3cs/.dotfiles/master/windows-bootstrap.ps1' |
  Invoke-Expression
}
```

## App Installer Link

The ones that don't get scripted.

- Windows
  - [ArmouryCrateInstallTool](https://www.asus.com/supportonly/Armoury%20Crate/HelpDesk_Download/)
    - ASUS Driver Manager
  - [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)
    - Oh My Posh Font
    - Change `"CaskaydiaCove Nerd Font"` on Windows Terminal Settings
  - [FF14](https://www.finalfantasyxiv.com/freetrial/download/)
  - [Genshin](https://genshin.mihoyo.com/ja/download)
  - [Origin](https://www.origin.com/jpn/ja-jp/store/download)
  - [Logicool Options](https://www.logicool.co.jp/ja-jp/product/options)
  - [Razer Surround Sound](https://www2.razer.com/jp-jp/7.1-surround-sound)
- macOS
  - [Soundflower](https://github.com/mattingalls/Soundflower)
