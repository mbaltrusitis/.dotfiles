local plugins = {
	{"mbbill/undotree", lazy = false},
	{"theprimeagen/harpoon", lazy = false},
	{"nvim-treesitter/playground", lazy = false},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"comment",
				"cpp",
				"css",
				"diff",
				"dockerfile",
				"elixir",
				"erlang",
				"git_config",
				"git_rebase",
				"gleam",
				"go",
				"haskell",
				"hcl",
				"heex",
				"html",
				"http",
				"ini",
				"javascript",
				"jq",
				"json",
				"lua",
				"luadoc",
				"make",
				"markdown",
				"markdown_inline",
				"nix",
				"nim",
				"passwd",
				"python",
				"regex",
				"rust",
				"sql",
				"terraform",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"yaml"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"bash-language-server",
				"black",
				"clangd",
				"css-lsp",
				"dockerfile-language-server",
				"erlang-ls",
				"gopls",
				"html-lsp",
				"json-lsp",
				"lexical",
				"lua-language-server",
				"mypy",
				"nimlangserver",
				"pyright",
				"ruff",
				"rust-analyzer",
				"tailwindcss-language-server",
				"typescript-language-server"
			}
		}
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require "configs.lspconfig"
		end
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = "nvim-telescope/telescope-fzy-native.nvim",

		opts = {
			extensions_list = {
				"fzy_native",
				"file_browser",
				"terms",
				"themes",
			},
			extensions = {
				fzy_native = {
					override_generic_sorter = false,
					override_file_sorter = true,
				}
			}
		}
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},
	-- {"LinArcX/telescope-command-palette.nvim", lazy = false},
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function ()
			-- require("copilot").setup({})
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				config = function ()
					require("copilot_cmp").setup()
				end
			}
		},
		opts = {
			sources = {
				{ name = "nvim_lsp", group_index = 2 },
				{ name = "copilot",  group_index = 2 },
				{ name = "luasnip",  group_index = 2 },
				{ name = "buffer",   group_index = 2 },
				{ name = "nvim_lua", group_index = 2 },
				{ name = "path",     group_index = 2 },
			}
		}
		-- opts = function ()
		-- 	require "plugins.configs.cmp"
		-- 	require "custom.configs.cmp"
		-- end
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		opts = {
			chat = {
				keymaps = {
					close = { "<C-x>"},
				},
			},
		},
		config = function(_, opts)
			require("chatgpt").setup(opts)
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function(_, opts)
			require("gopher").setup(opts)
			require("core.utils").load_mappings("gopher")
		end,
		build = function()
			vim.cmd [[silent! GoInstallDeps!]]
		end
	},
	{
		"folke/zen-mode.nvim",
		ft = "markdown",
		opts = {
			window = {
				width = 80,
			},
			on_open = function(_win)
				vim.opt.wrap = true
				vim.opt.linebreak = true
			end,
			on_close = function()
				vim.opt.wrap = false
				vim.opt.linebreak = false
			end
		},
		config = function(_, opts)
			require("zen-mode").setup(opts)
		end
	},
	{
		"fladson/vim-kitty",
		ft = "kitty"
	},
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		config = function()
			require "configs.conform"
		end
	}

}

return plugins
