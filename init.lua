-- === 1. GENERAL SETTINGS ===
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.mouse = "a"
vim.opt.backspace = { "indent", "eol", "start" }

-- Search settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Set indentation for C# files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- === 2. PLUGIN MANAGEMENT (vim-plug) ===
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.filereadable(plug_path) == 0 then
  vim.fn.system({
    'curl', '-fLo', plug_path, '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  })
  vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

vim.fn['plug#begin'](vim.fn.stdpath('data') .. '/plugged')
-- Appearance
vim.fn['plug#']('tomasiser/vim-code-dark')
vim.fn['plug#']('vim-airline/vim-airline')
vim.fn['plug#']('vim-airline/vim-airline-themes')

-- File Explorer
vim.fn['plug#']('lambdalisue/fern.vim')
vim.fn['plug#']('lambdalisue/fern-git-status.vim')
vim.fn['plug#']('lambdalisue/nerdfont.vim')
vim.fn['plug#']('lambdalisue/fern-renderer-nerdfont.vim')
vim.fn['plug#']('lambdalisue/glyph-palette.vim')

-- Git integration
vim.fn['plug#']('airblade/vim-gitgutter')

-- Completion & LSP
vim.fn['plug#']('prabirshrestha/asyncomplete.vim')
vim.fn['plug#']('prabirshrestha/asyncomplete-lsp.vim')
vim.fn['plug#']('prabirshrestha/vim-lsp')
vim.fn['plug#']('mattn/vim-lsp-settings')

-- Search
vim.fn['plug#']('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end })
vim.fn['plug#']('junegunn/fzf.vim')

-- Utilities
vim.fn['plug#']('tpope/vim-commentary')
vim.fn['plug#']('jiangmiao/auto-pairs')

-- Language specific
vim.fn['plug#']('carlsmedstad/vim-bicep')

vim.fn['plug#end']()

-- Colorscheme Settings
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
local ok, _ = pcall(vim.cmd, "colorscheme codedark")
if not ok then
  print("Colorscheme 'codedark' not found. Please run :PlugInstall")
end
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 236, bg = "#2a2a2a" })
