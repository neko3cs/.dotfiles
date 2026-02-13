" -----------------------------------------------------------
"                neko3cs .vimrc
" -----------------------------------------------------------

" === 1. GENERAL SETTINGS ===
set nocompatible
filetype plugin indent on
syntax enable

set encoding=utf-8
set fileencoding=utf-8
set number          " Show line numbers
set cursorline      " Highlight current line
set laststatus=2    " Always show status line
set noswapfile      " Disable swap files
set updatetime=250  " Faster updates (for gitgutter etc.)
set mouse=a         " Enable mouse support
set backspace=indent,eol,start

" Search settings
set hlsearch        " Highlight search results
set ignorecase      " Ignore case when searching
set smartcase       " Override ignorecase if search contains uppercase

" Indentation
set expandtab       " Use spaces instead of tabs
set tabstop=2       " Number of spaces a <Tab> counts for
set shiftwidth=2    " Number of spaces for autoindent
set autoindent
set smartindent

" UI Colors
if has("win32") || has("win64")
  set t_Co=256
endif

" === 2. PLUGIN MANAGEMENT (vim-plug) ===
" Auto-install vim-plug if not exists
let s:plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug_path)
  execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  " Appearance
  Plug 'tomasiser/vim-code-dark'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  
  " File Explorer
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'
  
  " Git integration
  Plug 'airblade/vim-gitgutter'
  
  " Completion & LSP
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'

  " Search
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Utilities
  Plug 'tpope/vim-commentary'
  Plug 'jiangmiao/auto-pairs'
  
  " Language specific
  Plug 'carlsmedstad/vim-bicep'
call plug#end()

" Apply colorscheme after plugin definition
if (has("termguicolors"))
  set termguicolors
endif
silent! colorscheme codedark
highlight CursorLine cterm=NONE ctermbg=236 gui=NONE guibg=#2a2a2a

" === 3. PLUGIN SPECIFIC SETTINGS ===

" --- vim-airline ---
let g:airline_theme = 'codedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#hunks#non_zero_only = 1

let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ ['z']
  \ ]
let g:airline_section_c = '%t %M'
let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'

" --- fern.vim ---
nnoremap <silent> <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'

" --- glyph-palette.vim ---
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

" --- vim-gitgutter ---
nnoremap <silent> g[ :GitGutterPrevHunk<CR>
nnoremap <silent> g] :GitGutterNextHunk<CR>
nnoremap <silent> gh :GitGutterLineHighlightsToggle<CR>
nnoremap <silent> gp :GitGutterPreviewHunk<CR>

highlight GitGutterAdd    ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red

" --- asyncomplete.vim ---
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"

" --- vim-lsp ---
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-b> lsp#scroll(-4)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" --- fzf.vim ---
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>f :Rg<CR>
nnoremap <silent> <leader>b :Buffers<CR>
