-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
---@type ChadrcConfig
local M = {}

M.ui = {
  theme = 'tomorrow_night',
  statusline = {
    theme = "minimal", -- {default,vscode,vscode_colored,minimal}
  },
}

-- M.plugins = "custom.plugins"
-- M.mappings = require "custom.mappings"

return M
