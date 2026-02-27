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
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map('n', 'g]',
            function()
              if vim.wo.diff then return 'g]' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, { expr = true })
          map('n', 'g[',
            function()
              if vim.wo.diff then return 'g[' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, { expr = true })
          map('n', 'gp', gs.preview_hunk)
          map('n', 'gh', gs.toggle_linehl)
        end
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "csharp_ls" }
      })
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        })
      })
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      if vim.lsp.config then
        vim.lsp.config('csharp_ls', {
          cmd = { 'csharp-ls' },
          filetypes = { 'cs' },
          capabilities = capabilities,
          root_markers = { '*.slnx', '*.sln', '.git' },
          options = {
            initialization_options = {
              solutionPath = function(client, root_dir)
                return root_dir
              end,
            },
          },
        })
        vim.lsp.enable('csharp_ls')
      else
        require('lspconfig').csharp_ls.setup({
          capabilities = capabilities,
          root_dir = require('lspconfig.util').root_pattern('*.slnx', '*.sln', '.git'),
          init_options = {
            solutionPath = vim.fn.getcwd(),
          }
        })
      end
    end
  },
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

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
  end,
})

-- GitSigns
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "green" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "blue" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "red" })
