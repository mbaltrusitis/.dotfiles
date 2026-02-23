local registry = require("mason-registry")

local pkgs = {
  "ansible-language-server",
  "ansible-lint",
  "awk-language-server",
  "bash-language-server",
  "clangd",
  "css-lsp",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "erlang-ls",
  "gopls",
  "html-lsp",
  "json-lsp",
  "lexical",
  "lua-language-server",
  "nimlangserver",
  "prettierd",
  "pyright",
  "ruff",
  "rust-analyzer",
  "shellcheck",
  "shfmt",
  "sqlfluff",
  "stylua",
  "tailwindcss-language-server",
  "typescript-language-server",
  "uv",
}

vim.api.nvim_create_user_command("MasonInstallAll", function()
  for _, pkg_name in ipairs(pkgs) do
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if ok and not pkg:is_installed() then
      vim.cmd("MasonInstall " .. pkg_name)
    elseif not ok then
      vim.notify("Package not found in registry: " .. pkg_name, vim.log.levels.WARN)
    end
  end
end, {})

local opts = {}
return opts
