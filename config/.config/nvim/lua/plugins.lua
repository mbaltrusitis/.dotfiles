vim.cmd([[
	packadd packer.nvim
]])

return require('packer').startup(function()
	use 'wbthomason/packer.nvim'  -- package manager

	-- common
	use 'vim-airline/vim-airline' -- powerline
	use 'vim-airline/vim-airline-themes'
	use 'rhysd/vim-grammarous' -- grammar check
	use 'andymass/vim-matchup' -- matching parens and more
	use 'bronson/vim-trailing-whitespace' -- highlight trailing spaces
	use 'editorconfig/editorconfig-vim'  -- .editorconfig support

	-- vcs
	use 'tpope/vim-fugitive' -- Git commands
	use 'rhysd/git-messenger.vim'
	use 'airblade/vim-gitgutter'

	-- Theme
	use 'chriskempson/base16-vim'

	-- NERDTree
	use 'preservim/nerdtree'  -- sidebar
	use 'Xuyuanp/nerdtree-git-plugin'  -- show git status in sidebar
	--vim.cmd("let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$', '\.sw?']")

	-- file searching
	use 'vijaymarupudi/nvim-fzf'
	-- autocompletion
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	--use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	--use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use "onsails/lspkind-nvim" -- autocomplete popup icons

	-- LuaSnip
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

	-- LSP
	use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
	use 'williamboman/nvim-lsp-installer'

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	-- luasnip setup
	local luasnip = require 'luasnip'
	local lspkind = require 'lspkind'

	-- nvim-cmp setup
	local cmp = require 'cmp'
	cmp.setup {
		snippet = {
			expand = function(args)
				require('luasnip').lsp_expand(args.body)
			end,
		},
		mapping = {
			['<C-p>'] = cmp.mapping.select_prev_item(),
			['<C-n>'] = cmp.mapping.select_next_item(),
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			['<Tab>'] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end,
			['<S-Tab>'] = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end,
		},
		formatting = {
			format = lspkind.cmp_format {
				with_text = true,
				menu = {
					buffer   = "[buf]",
					nvim_lsp = "[LSP]",
					path     = "[path]",
				},
			},
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
			{ name= 'path' },
			{ name = "buffer", keyword_length = 5},
		},
		experimental = {
			ghost_text = true
		}
	}

	-- REAL LSP START
	-- Mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap=true, silent=true }
	vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	end

	-- config that activates keymaps and enables snippet support
	local function make_config()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		-- capabilities.textDocument.colorProvider = { dynamicRegistration = false }
		-- Add additional capabilities supported by nvim-cmp
		capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
		return {
			-- enable snippet support
			capabilities = capabilities,
			-- map buffer local keybindings when the language server attaches
			on_attach = on_attach,
		}
	end

	-- setup installer for language servers
	local lsp_installer = require('nvim-lsp-installer.servers')
	-- servers are defined by which servers are installed
	local installed_servers = lsp_installer.get_installed_servers()

	-- loop through servers passing through configs
	for _, lsp in pairs(installed_servers) do
		local config = make_config()
		lsp:setup(config)
		--require('lspconfig')[lsp].setup(config)
			-- on_attach = on_attach,
			-- capabilities = capabilities,
			-- flags = {
				-- This will be the default in neovim 0.7+
			-- 	debounce_text_changes = 150,
		-- 	}
		-- })
	end


	--local lspconfig = require('lspconfig')

	---- Enable some language servers with the additional completion capabilities offered by nvim-cmp
	--local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
	--for _, lsp in ipairs(servers) do
	--lspconfig[lsp].setup {
	---- on_attach = my_custom_on_attach,
	--capabilities = capabilities,
	--}
	--end

	-- REAL LSP END


	-- Treesitter
	require'nvim-treesitter.configs'.setup {
		highlight = {
			enable = true,
			disable = {"ruby"}
		}
	}

	-- general development
	use 'scrooloose/nerdcommenter' -- commenting shortcuts

	-- elixir
	use { 'elixir-lang/vim-elixir', ft = 'elixir' }
	use { 'mattreduce/vim-mix', ft = 'elixir' }
	use { 'slashmili/alchemist.vim', ft = 'elixir' }

end)
