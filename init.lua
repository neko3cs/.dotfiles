-- ========================================================================== --
-- ==                           NEOVIM 基本設定                            == --
-- ========================================================================== --

-- LeaderキーをSpaceに設定（多くのプラグイン操作の起点になります）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- === 1. オプション設定 (vim.opt) ===
local opt = vim.opt

opt.number = true         -- 行番号を表示
opt.cursorline = true     -- カーソル行をハイライト
opt.mouse = "a"           -- マウス操作を有効化
opt.termguicolors = true  -- TrueColor対応
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- インデント設定
opt.expandtab = true      -- タブをスペースに変換
opt.tabstop = 2           -- タブ幅を2に設定
opt.shiftwidth = 2        -- 自動インデント幅を2に設定
opt.autoindent = true     -- 改行時に前の行のインデントを継続
opt.smartindent = true    -- 言語に合わせて賢くインデント

-- 検索設定
opt.hlsearch = true       -- 検索結果をハイライト
opt.ignorecase = true     -- 検索時に大文字小文字を区別しない
opt.smartcase = true      -- 大文字が含まれる場合は区別する

-- その他
opt.laststatus = 2        -- ステータスラインを常に表示
opt.swapfile = false      -- スワップファイルを作成しない
opt.updatetime = 250      -- 反応速度（ms）
opt.wrap = false          -- 長い行を折り返さない
opt.backspace = { "indent", "eol", "start" } -- バックスペースの挙動

-- C# ファイル用の個別設定 (FileTypeごとに設定を切り替える)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- === 2. プラグイン管理 (lazy.nvim) ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- カラースキーム
  {
    "tomasiser/vim-code-dark",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme codedark]])
      -- カーソル行の背景色調整
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a", ctermbg = 236 })
    end
  },

  -- ステータスライン
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    init = function()
      vim.g.airline_theme = 'codedark'
      vim.g['airline#extensions#tabline#enabled'] = 1
      vim.g['airline#extensions#tabline#fnamemod'] = ':t'
      vim.g['airline#extensions#hunks#non_zero_only'] = 1
      vim.g.airline_section_c = '%t %M'
      -- セクションZ (行:列) の表示
      vim.g.airline_section_z = '%3l:%-2v'
    end
  },

  -- ファイルツリー
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-n>", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
    opts = {
      view = { width = 40 },
    }
  },

  -- ファジーファインダー (ファイル検索・文字列検索)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", function() require('telescope.builtin').find_files() end, desc = "Find Files" },
      { "<leader>f", function() require('telescope.builtin').live_grep() end, desc = "Live Grep" },
    }
  },

  -- Git 操作の補助
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
          -- Git 操作のキーマップ
          map('n', 'g]', gs.next_hunk, { desc = "Next Git Hunk" })
          map('n', 'g[', gs.prev_hunk, { desc = "Prev Git Hunk" })
          map('n', 'gp', gs.preview_hunk, { desc = "Preview Hunk" })
          map('n', 'gh', gs.toggle_linehl, { desc = "Toggle Git Line Highlight" })
        end
      })
      -- GitSignsの色設定
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "green" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "blue" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "red" })
    end
  },

  -- LSP / 補完設定
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

      -- 補完メニューの設定
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      -- LSPサーバーの設定
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('csharp_ls', {
        capabilities = capabilities,
        root_markers = { '*.slnx', '*.sln', '.git' },
      })
      vim.lsp.enable('csharp_ls')
    end
  },

  -- 括弧の自動補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
    end
  },

  -- Bicepファイルの構文強調
  { "carlsmedstad/vim-bicep" },
})

-- === 3. LSP 共通キーマップ (LspAttach時に有効化) ===
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    local k = vim.keymap.set
    k('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition", buffer = ev.buf })
    k('n', 'gr', vim.lsp.buf.references, { desc = "Show References", buffer = ev.buf })
    k('n', 'K',  vim.lsp.buf.hover, { desc = "Hover Documentation", buffer = ev.buf })
    k('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = ev.buf })
    k('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action", buffer = ev.buf })
    k('n', '[g', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic", buffer = ev.buf })
    k('n', ']g', vim.diagnostic.goto_next, { desc = "Next Diagnostic", buffer = ev.buf })
  end,
})
