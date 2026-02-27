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
