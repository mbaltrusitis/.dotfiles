local format_on_save = function(bufnr)
  -- do not autoformat these filetypes
  local excluded_fts = {
    "sql",
  }
  local filetype = vim.bo[bufnr].filetype
  if not vim.tbl_contains(excluded_fts, filetype) then
    return {
      timeout_ms = 500,
      lsp_format = "fallback",
      quiet = false, -- Show errors if formatting fails
    }
  end
end

---@module "conform"
---@type conform.setupOpts
local opts = {
  formatters_by_ft = {
    bash = { "shfmt" },
    elixir = { "mix" },
    go = { "gofmt" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" },
    markdown = { "prettierd" },
    nim = { "nimpretty" },
    python = { "ruff" },
    sql = { "sqlfluff" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = format_on_save,
  formatters = {
    shfmt = {
      append_args = { "-i", "4", "--posix" },
    },
  },
}

return opts
