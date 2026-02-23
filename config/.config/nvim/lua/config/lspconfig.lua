-- Capabilities setup
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- snippet support for vscode-based language servers
capabilities.textDocument.completion.completionItem.snippetSupport = true

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

capabilities.textDocument.codeLens = {
  dynamicRegistration = false,
}

capabilities.workspace.didChangeWatchedFiles = {
  dynamicRegistration = true,
}

-- nvim-cmp
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

-- LspAttach autocommand for keybindings and per-client setup
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Disable semantic tokens to prevent conflicts with Treesitter
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end

    local function opts(desc)
      return { buffer = bufnr, desc = "LSP " .. desc }
    end

    local map = vim.keymap.set

    map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
    map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
    map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
    map("n", "K", vim.lsp.buf.hover, opts("Hover information"))
    map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
    map("n", "<leader>wl", function()
      vim.pretty_print(vim.lsp.buf.list_workspace_folders())
    end, opts("List workspace folders"))
    map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts("Workspace symbols"))
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
    map("n", "<leader>ds", vim.lsp.buf.document_symbol, opts("Document symbols"))
    map("n", "<leader>rs", vim.lsp.buf.rename, opts("Rename symbol"))
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
    map("n", "grr", vim.lsp.buf.references, opts("Show references"))
    map("n", "<leader>li", "<cmd>LspInfo<CR>", opts("Show LSP info"))
  end,
})

-- Server configurations
local servers = {
  ansiblels = {},
  awk_ls = {},
  bashls = {},
  clangd = {},
  cssls = {},
  docker_compose_language_service = {},
  docker_language_server = {},
  lexical = {
    cmd = { "lexical" },
    root_dir = require("lspconfig.util").root_pattern("mix.exs", ".git"),
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  },
  erlangls = {},
  gopls = {},
  html = {
    filetypes = { "html" },
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true,
      },
      provideFormatter = true,
    },
  },
  jsonls = {
    init_options = {
      provideFormatter = true,
    },
    settings = {
      json = {
        validate = { enable = true },
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  nim_langserver = {},
  pyright = {},
  rust_analyzer = {},
  tailwindcss = {},
  ts_ls = {},
  uvls = {},
}

-- Set global capabilities for all servers
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Configure and enable each server
for name, opts in pairs(servers) do
  -- Always configure server (even if opts is empty, for clarity)
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
