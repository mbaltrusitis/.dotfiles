local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local has_mini_icons, mini_icons = pcall(require, "mini.icons")

-- Load snippets from ../snippets
local ok, lua_loader = pcall(require, "luasnip.loaders.from_lua")
if ok then
  lua_loader.lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
else
  vim.notify("Failed to load custom Lua snippets", vim.log.levels.WARN)
end

-- Load friendly-snippets
local ok_vscode, vscode_loader = pcall(require, "luasnip.loaders.from_vscode")
if ok_vscode then
  vscode_loader.lazy_load()
else
  vim.notify("Failed to load friendly-snippets", vim.log.levels.WARN)
end

cmp.setup({

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    -- navigate options
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- navigate docs
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),

    -- Tab completion
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),

  formatting = has_mini_icons
      and {
        format = function(entry, vim_item)
          -- Get icon from mini.icons
          local icon, hl_group = mini_icons.get("lsp", vim_item.kind)

          -- Format: icon + text + [kind]
          vim_item.kind = string.format("%s %s", icon, vim_item.kind)

          -- Truncate if too long
          local maxwidth = 50
          if #vim_item.abbr > maxwidth then
            vim_item.abbr = vim_item.abbr:sub(1, maxwidth - 3) .. "..."
          end

          return vim_item
        end,
      }
    or {
      -- Fallback formatting without icons
      format = function(entry, vim_item)
        local maxwidth = 50
        if #vim_item.abbr > maxwidth then
          vim_item.abbr = vim_item.abbr:sub(1, maxwidth - 3) .. "..."
        end
        return vim_item
      end,
    },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Setup for searching with / and ?
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Setup for command mode with :
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

-- insert `(` after selecting function or method item
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
