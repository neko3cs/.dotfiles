" -------------------------------
"         neko3cs .vimrc
" -------------------------------

"" vim --------------------------
syntax on
colorscheme ron
set fenc=utf-8
set noswapfile
set number
set cursorline
set laststatus=2
set expandtab
set tabstop=4
set shiftwidth=4

"" neobundle --------------------
" install neobundle
" $ curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
" $ sh ./install.sh

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/neko3cs/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/Users/neko3cs/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
" neko3cs additional bundles.
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'tomtom/tcomment_vim'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

