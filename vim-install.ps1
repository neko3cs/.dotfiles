#!pwsh

if (-not (Test-Path $HOME\.vim\bundle\neobundle.vim\)) {
  git clone https://github.com/Shougo/neobundle.vim $HOME\.vim\bundle\neobundle.vim
}

if (Test-Path $HOME\.vimrc) {
  Remove-Item $HOME\.vimrc
}
Copy-Item $HOME\dotfiles\.vimrc $HOME\.vimrc

