-- Use built-in Neovim treesitter folding (0.9+)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 4

-- Custom fold text showing first and last line
function _G.custom_fold_text()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local end_line = vim.fn.trim(vim.fn.getline(vim.v.foldend))
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  return string.format("  %s ... %s (%d lines)", start_line, end_line, line_count)
end

vim.opt.foldtext = "v:lua.custom_fold_text()"
