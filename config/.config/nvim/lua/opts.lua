vim.wo.relativenumber = true

vim.opt.mouse = "" -- disable the mouse
vim.opt.encoding = "utf-8"
vim.opt.backspace = "indent,eol,start" -- backspace works on every char in insert mode
vim.opt.completeopt = "menuone,noselect"
vim.opt.history = 10000
vim.opt.dictionary = "/usr/share/dict/words"
vim.opt.startofline = true

vim.opt.termguicolors = true
vim.opt.updatetime = 50

-- Mapping waiting time
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100

-- Display
vim.opt.showmatch = true -- show matching brackets
vim.opt.scrolloff = 2 -- always show 3 rows from edge of the screen
vim.opt.synmaxcol = 500 -- stop syntax highlight after x lines for performance
vim.opt.laststatus = 2 -- always show status line
vim.opt.colorcolumn = "80,100,120" -- column lines
vim.opt.cursorcolumn = true -- show vertical cursor
vim.opt.cursorline = true -- highlight current line number
-- vim.opt.cursorlineopt = "number"

vim.opt.list = true -- display white characters

-- folds
vim.opt.foldenable = true
-- vim.opt.foldmethod = 'syntax' -- use language syntax to generate folds
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldlevelstart = 99 -- start with all folds open
-- vim.opt.foldlevel = 4 -- limit folding to 4 levels
vim.opt.wrap = false
vim.opt.eol = false -- show if there's no eol char

-- Sidebar
vim.opt.number = true -- line number on the left
vim.opt.numberwidth = 3 -- always reserve 3 spaces for line number
-- vim.opt.modelines = 0
vim.opt.signcolumn = "yes:2" -- always show 2 columns (1. git, 2. LSP)
vim.opt.showcmd = true -- display command in bottom bar

-- Search
vim.opt.incsearch = true -- starts searching as soon as typing, without enter needed
vim.opt.ignorecase = true -- ignore letter case when searching
vim.opt.smartcase = true -- case insentive unless capitals used in search
vim.opt.hlsearch = false -- highlight all search pattern matches

-- undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undofile = true

vim.opt.matchtime = 2 -- delay before showing matching paren

-- White characters
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- diagnostics
vim.diagnostic.config({
  -- virtual_text = {
  --   prefix = "▎",
  -- },
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "ℹ",
    },
  },
})

-- enable system clipboard integration
vim.opt.clipboard = "unnamedplus"

-- vim.opt.formatoptions = 'qnj1' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
-- vim.opt.expandtab = true -- expand tab to spaces
