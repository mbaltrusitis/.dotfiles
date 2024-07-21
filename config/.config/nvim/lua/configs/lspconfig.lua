local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local servers = {
	bashls = {},
	clangd = {},
	cssls = {},
	dockerls = {},
	lexical = {
		cmd = { "lexical" }
	},
	erlangls = {},
	gopls = {},
	html = {},
	jsonls = {},
	pyright = {},
	rust_analyzer = {},
	tailwindcss = {},
	tsserver = {},
}

for name, opts in pairs(servers) do
	opts.on_init = on_init
    opts.on_attach = on_attach
	opts.capabilities = capabilities

	require("lspconfig")[name].setup(opts)
end
