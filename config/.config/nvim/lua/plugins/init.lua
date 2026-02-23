return {
  {
    "windwp/nvim-autopairs",
    commit = "7a2c97cccd60abc559344042fefb1d5a85b3e33b",
    event = "InsertEnter",
    config = true,
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
    "stevearc/conform.nvim",
    commit = "cde4da5c1083d3527776fee69536107d98dae6c9",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      return require("config.conform")
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    commit = "cf22c9e32512de3be1fd6b65fd25e3aabead4d8b",
    event = "InsertEnter",
    dependencies = {
      -- Completion sources
      { "hrsh7th/cmp-nvim-lsp", commit = "bd5a7d6db125d4654b50eeae9f5217f24bb22fd3" }, -- LSP completion source
      { "hrsh7th/cmp-buffer", commit = "b74fab3656eea9de20a9b8116afa3cfc4ec09657" }, -- Buffer completion source
      { "hrsh7th/cmp-path", commit = "c642487086dbd9a93160e1679a1327be111cbc25" }, -- Path completion source
      { "hrsh7th/cmp-cmdline", commit = "d126061b624e0af6c3a556428712dd4d4194ec6d" }, -- Cmdline completion source

      -- Snippet engine (required for nvim-cmp)
      {
        "L3MON4D3/LuaSnip",
        commit = "3732756842a2f7e0e76a7b0487e9692072857277",
        dependencies = {
          { "rafamadriz/friendly-snippets", commit = "572f5660cf05f8cd8834e096d7b4c921ba18e175" },
        },
      },
      { "saadparwaiz1/cmp_luasnip", commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" },
    },
    config = function()
      require("config.cmp")
    end,
  },
  {
    "PedramNavid/dbtpal",
    commit = "981eab51609362712c64e3cf3fb773fe11f859b9",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    ft = {
      "sql",
      "md",
      "yaml",
    },
    keys = {
      { "<leader>drf", "<cmd>DbtRun<cr>" },
      { "<leader>drp", "<cmd>DbtRunAll<cr>" },
      { "<leader>dtf", "<cmd>DbtTest<cr>" },
      { "<leader>dm", "<cmd>lua require('dbtpal.telescope').dbt_picker()<cr>" },
    },
    opts = function()
      return require("config.dbtpal")
    end,
    config = function(_, opts)
      require("dbtpal").setup(opts)
      require("telescope").load_extension("dbtpal")
    end,
  },
  {
    "olexsmir/gopher.nvim",
    commit = "295e21e637f9194a4d2bc34622d324a88b028141",
    ft = "go",
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    ---@module "gopher"
    ---@type gopher.Config
    opts = {},
  },
  {
    "theprimeagen/harpoon",
    commit = "1bc17e3e42ea3c46b33c0bbad6a880792692a1b3",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim", commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" },
    },
  },
  {
    "folke/lazydev.nvim",
    commit = "5231c62aa83c2f8dc8e7ba957aa77098cda1257d",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
    commit = "0ea4ff636c5bb559ffa78108561d0976f4de9682",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    commit = "a89bfcfd0e44f898341ac8a80ba83ccf6218bef3",
    config = function()
      require("config.lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    commit = "ad7146aa61dcaeb54fa900144d768f040090bff0",
    opts = function()
      return require("config.mason")
    end,
  },
  {
    "nvim-mini/mini.nvim",
    commit = "94cae4660a8b2d95dbbd56e1fbc6fcfa2716d152",
    config = function()
      -- start page
      require("mini.starter").setup(require("config.mini.starter"))
      -- miller columns file browser
      require("mini.diff").setup(require("config.mini.diff"))
      require("mini.files").setup(require("config.mini.files"))
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
      -- toggle arguments
      require("mini.splitjoin").setup()
      -- highlight trailing whitespace
      require("mini.trailspace").setup()
      -- toggle comments with `gc`
      require("mini.comment").setup()
      -- statusline
      require("mini.statusline").setup()
      -- align
      require("mini.align").setup()
      -- git
      require("mini.git").setup()
      -- surround
      require("mini.surround").setup()

      local git_blame = require("config.mini.git-blame")
      vim.api.nvim_create_user_command("BlameLineToggle", git_blame.toggle, {})
      vim.api.nvim_create_user_command("BlameLineEnable", git_blame.enable, {})
      vim.api.nvim_create_user_command("BlameLineDisable", git_blame.disable, {})
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    commit = "cf2a288696b03d0934da713d66c6d71557b5c997",
    opts = {
      styles = {
        bold = true,
        italic = false,
        transparency = false,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd("colorscheme rose-pine-moon")
    end,
  },
  {
    "b0o/schemastore.nvim",
    version = false,
    commit = "eed1834170f343c14a6768f085b26b3571a55302",
  },
  {
    "nvim-telescope/telescope.nvim",
    commit = "b4da76be54691e854d3e0e02c36b0245f945c2c7",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        commit = "6fea601bd2b694c6f2ae08a6c6fab14930c60e2c",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
  {
    "folke/tokyonight.nvim",
    commit = "5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      comments = { italic = true },
      keywords = {},
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "coder/claudecode.nvim",
    commit = "1552086ebcce9f4a2ea3b9793018a884d6b60169",
    dependencies = {
      { "folke/snacks.nvim", commit = "836e07336ba523d4da480cd66f0241815393e98e" },
    },
    opts = function()
      return require("config.claudecode")
    end,
    config = function(_, opts)
      require("claudecode").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "42fc28ba918343ebfd5565147a42a26580579482",
    branch = "master",
    lazy = false,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require("config.treesitter")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "fladson/vim-kitty",
    commit = "5c3efc79af70dc2c22cad03e6a7374a5f81205d9",
    ft = "kitty",
  },
  {
    "folke/which-key.nvim",
    commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
    event = "VeryLazy",
    opts = function()
      return require("config.whichkey")
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
