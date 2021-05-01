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
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start

"" neobundle --------------------
" =========================================================
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('$HOME/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'OmniSharp/omnisharp-vim'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" =========================================================
