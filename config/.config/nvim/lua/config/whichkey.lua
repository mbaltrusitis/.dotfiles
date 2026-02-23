local M = {}

M.delay = 1000 -- milliseconds

-- Define prefix groups for better organization
M.spec = {
  { "<leader>f", group = "Find/Files (Telescope)" },
  { "<leader>w", group = "Workspace (LSP)" },
  { "<leader>d", group = "Diagnostics/Document" },
  { "<leader>q", group = "Quickfix" },
  { "<leader>l", group = "LSP" },
  { "<leader>s", group = "Split/Misc" },
  { "<leader>y", group = "Yank/Copy" },
  { "<leader>g", group = "Git" },
  { "<leader>r", group = "Rename/Refactor" },
  { "<leader>c", group = "Claude Code" },
}

return M
