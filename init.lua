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

-- === 2. PLUGIN MANAGEMENT (lazy.nvim) ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "tomasiser/vim-code-dark",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd([[colorscheme codedark]]) end
  },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("nvim-tree").setup() end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },
  "prabirshrestha/vim-lsp",
  "mattn/vim-lsp-settings",
  "prabirshrestha/asyncomplete.vim",
  "prabirshrestha/asyncomplete-lsp.vim",
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end
  },
  "carlsmedstad/vim-bicep",
})
-- Apply colorscheme after plugin definition
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
local ok, _ = pcall(vim.cmd, "colorscheme codedark")
if not ok then
  print("Colorscheme 'codedark' not found. Please run :Lazy")
end
vim.api.nvim_set_hl(0, "CursorLine", {
  ctermbg = 236,
  bg = "#2a2a2a",
  bold = false,
  italic = false,
  underline = false
})

-- === 3. PLUGIN SPECIFIC SETTINGS ===
-- vim-airline
vim.g.airline_theme = 'codedark'
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
vim.g['airline#extensions#tabline#show_buffers'] = 1
vim.g['airline#extensions#tabline#show_splits'] = 0
vim.g['airline#extensions#tabline#show_tabs'] = 1
vim.g['airline#extensions#tabline#show_tab_nr'] = 0
vim.g['airline#extensions#tabline#show_tab_type'] = 1
vim.g['airline#extensions#tabline#show_close_button'] = 0
vim.g['airline#extensions#hunks#non_zero_only'] = 1

vim.g['airline#extensions#default#layout'] = {
  { 'a', 'b', 'c' },
  { 'z' }
}
vim.g.airline_section_c = '%t %M'
local prefix = vim.g.airline_linecolumn_prefix or ''
vim.g.airline_section_z = prefix .. '%3l:%-2v'

-- telescope.nvim
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})

-- nvim-tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
