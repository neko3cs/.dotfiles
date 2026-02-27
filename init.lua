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

-- === 3. PLUGIN SPECIFIC SETTINGS ===

-- --- vim-airline ---
vim.g.airline_theme = 'codedark'
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
vim.g['airline#extensions#tabline#show_buffers = 1'] = 1
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

-- --- fern.vim ---
vim.keymap.set('n', '<C-n>', ':Fern . -reveal=% -drawer -toggle -width=40<CR>', { silent = true })
vim.g['fern#default_hidden'] = 1
vim.g['fern#renderer'] = 'nerdfont'

-- --- glyph-palette.vim ---
local glyph_palette_group = vim.api.nvim_create_augroup("my-glyph-palette", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = glyph_palette_group,
  pattern = { "fern", "nerdtree", "startify" },
  callback = function()
    vim.fn['glyph_palette#apply']()
  end,
})

-- --- vim-gitgutter ---
vim.keymap.set('n', 'g[', ':GitGutterPrevHunk<CR>', { silent = true })
vim.keymap.set('n', 'g]', ':GitGutterNextHunk<CR>', { silent = true })
vim.keymap.set('n', 'gh', ':GitGutterLineHighlightsToggle<CR>', { silent = true })
vim.keymap.set('n', 'gp', ':GitGutterPreviewHunk<CR>', { silent = true })

vim.cmd([[
  highlight GitGutterAdd    ctermfg=green
  highlight GitGutterChange ctermfg=blue
  highlight GitGutterDelete ctermfg=red
]])

-- --- asyncomplete.vim ---
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })
vim.cmd([[
  inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"
]])

-- --- vim-lsp ---
local function on_lsp_buffer_enabled()
  vim.opt_local.omnifunc = "lsp#complete"
  vim.opt_local.signcolumn = "yes"
  if vim.fn.exists('+tagfunc') == 1 then
    vim.opt_local.tagfunc = "lsp#tagfunc"
  end

  local opts = { buffer = true, silent = true }
  vim.keymap.set('n', 'gd', '<plug>(lsp-definition)', opts)
  vim.keymap.set('n', 'gr', '<plug>(lsp-references)', opts)
  vim.keymap.set('n', 'gi', '<plug>(lsp-implementation)', opts)
  vim.keymap.set('n', 'gt', '<plug>(lsp-type-definition)', opts)
  vim.keymap.set('n', '<leader>ca', '<plug>(lsp-code-action)', opts)
  vim.keymap.set('n', '<leader>rn', '<plug>(lsp-rename)', opts)
  vim.keymap.set('n', '[g', '<plug>(lsp-previous-diagnostic)', opts)
  vim.keymap.set('n', ']g', '<plug>(lsp-next-diagnostic)', opts)
  vim.keymap.set('n', 'K', '<plug>(lsp-hover)', opts)

  vim.keymap.set('n', '<c-f>', 'lsp#scroll(+4)', { buffer = true, expr = true })
  vim.keymap.set('n', '<c-b>', 'lsp#scroll(-4)', { buffer = true, expr = true })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "lsp_buffer_enabled",
  callback = on_lsp_buffer_enabled,
})

-- --- csharp-ls ---
if vim.fn.executable('csharp-ls') == 1 then
  vim.api.nvim_create_autocmd("User", {
    pattern = "lsp_setup",
    callback = function()
      vim.fn['lsp#register_server']({
        name = 'csharp-ls',
        cmd = { 'csharp-ls' },
        allowlist = { 'cs' },
        initialization_options = {
          solutionPath = vim.fn['lsp#utils#find_nearest_parent_file_directory'](
            vim.fn['lsp#utils#get_buffer_path'](),
            { '*.slnx', '*.sln', '.git' }
          ),
        },
      })
    end,
  })
end

-- --- fzf.vim ---
vim.keymap.set('n', '<C-p>', ':Files<CR>', { silent = true })
vim.keymap.set('n', '<leader>f', ':Rg<CR>', { silent = true })
vim.keymap.set('n', '<leader>b', ':Buffers<CR>', { silent = true })
