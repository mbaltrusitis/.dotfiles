# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration written in Lua, using the lazy.nvim plugin manager. The configuration uses modern Neovim LSP features with the new `vim.lsp.config()` and `vim.lsp.enable()` API (Neovim 0.11+).

## Architecture

### Entry Point

- `init.lua`: Minimal bootstrap that sets leader keys and requires core modules
- Execution order: `config.lazy` → `opts` → `config.folds` → `mappings`

### Directory Structure

```
lua/
├── config/           # Plugin-specific configurations
│   ├── mini/        # mini.nvim module configurations
│   ├── cmp.lua      # nvim-cmp completion setup
│   ├── conform.lua  # Code formatting with conform.nvim
│   ├── lazy.lua     # lazy.nvim bootstrap and setup
│   ├── lspconfig.lua # LSP server configurations
│   ├── mason.lua    # Mason LSP installer
│   ├── treesitter.lua # Tree-sitter parsers
│   └── whichkey.lua # which-key keybinding hints
├── plugins/
│   └── init.lua     # Plugin specifications with pinned commits
├── snippets/        # Custom LuaSnip snippets
│   └── makefile.lua # Makefile boilerplate snippet
├── mappings.lua     # All keybindings
└── opts.lua         # Vim options and settings
```

### LSP Configuration (Important)

This config uses **Neovim's new LSP API** (0.11+):
- Server setup: `vim.lsp.config(name, opts)` followed by `vim.lsp.enable(name)`
- Global capabilities: `vim.lsp.config("*", { capabilities = ... })`
- Keybindings: Set in `LspAttach` autocommand in `lua/config/lspconfig.lua:14-45`
- NO nvim-lspconfig helper functions like `require('lspconfig').lua_ls.setup()`

Configured LSP servers (in `lua/config/lspconfig.lua:48-99`):
- ansiblels, awk_ls, bashls, clangd, cssls, docker_compose_language_service, docker_language_server
- lexical (Elixir), lua_ls, erlangls, gopls, html, jsonls (with schemastore), nim_langserver
- pyright, rust_analyzer, tailwindcss, ts_ls, uvls

### Plugin Management

All plugins are managed via lazy.nvim with **pinned commits** in `lua/plugins/init.lua`. Each plugin specifies:
- Exact commit hash for reproducibility
- Event-based lazy loading where appropriate
- Configuration files in `lua/config/` directory

Key plugins:
- **mini.nvim**: Multiple mini modules (files, diff, git, starter, icons, statusline, surround, etc.)
- **nvim-cmp**: Completion with LSP, buffer, path, cmdline sources
- **LuaSnip**: Snippet engine with custom snippets in `lua/snippets/`
- **Telescope**: Fuzzy finder with fzf-native extension
- **conform.nvim**: Code formatting (format-on-save enabled except for SQL)
- **Harpoon**: File navigation
- **nvim-treesitter**: Syntax highlighting with extensive language support

### Completion & Snippets

- nvim-cmp sources: LSP → LuaSnip → buffer → path
- Custom snippets: Place in `lua/snippets/{filetype}.lua`
- Snippet loading: Both custom Lua snippets and friendly-snippets (VSCode-style)
- Tab/S-Tab: Navigate completion and jump between snippet placeholders

### Formatting

Configured in `lua/config/conform.lua`:
- Format on save (except SQL): 500ms timeout with LSP fallback
- Per-language formatters:
  - Lua: stylua
  - Python: ruff
  - JavaScript: prettierd or prettier
  - SQL: sqlfluff (manual format only)
- Manual format: `<leader>fm`

## Key Bindings

Leader key: `<Space>` | Local leader: `\`

### LSP (in buffers with LSP attached)
- `gd`: Go to definition
- `gD`: Go to declaration
- `gi`: Go to implementation
- `grr`: Show references
- `K`: Hover information
- `<leader>ca`: Code action
- `<leader>rs`: Rename symbol
- `<leader>D`: Go to type definition

### File Navigation
- `<C-n>` or `<leader>e`: Open mini.files (current file directory)
- `<leader>E`: Open mini.files (cwd)
- `<leader>ff`: Telescope find files
- `<leader>fg` or `<leader>fw`: Telescope live grep
- `<leader>fb`: Telescope buffers
- `<leader>fa`: Telescope find all files (including hidden/ignored)

### Harpoon
- `<leader>a`: Add current file to harpoon
- `<leader>H`: Toggle harpoon quick menu
- `<leader>1-4`: Jump to harpoon files 1-4

### Buffers & Windows
- `<Tab>` / `<S-Tab>`: Next/previous buffer
- `<leader>x`: Close buffer
- `<leader>b`: New buffer
- `<leader><leader>`: Toggle alternate file
- `<C-h/j/k/l>`: Navigate windows
- `<leader>sv` / `<leader>sh`: Split vertically/horizontally

### Diagnostics & Quickfix
- `<leader>d`: Show diagnostic float
- `<leader>dl`: Toggle diagnostic location list
- `]l` / `[l`: Next/previous location list item
- `<leader>ql`: Toggle quickfix window
- `]q` / `[q`: Next/previous quickfix item

### Miscellaneous
- `<leader>fm`: Format buffer
- `<leader>gb`: Toggle git blame (mini.git)
- `<leader>ss`: Open start screen
- `<leader>rn`: Toggle relative line numbers

## Development Workflow

### Testing Configuration Changes
```bash
# Launch Neovim with this config
nvim

# Update plugins (respects pinned commits in lazy-lock.json)
:Lazy sync

# Check LSP status
:LspInfo

# Install missing treesitter parsers
:TSInstall <language>

# Check formatter status
:ConformInfo
```

### Adding New LSP Server
1. Add server config to `servers` table in `lua/config/lspconfig.lua:48-99`
2. Use empty table `{}` for default config or specify custom options
3. Server will auto-enable via loop at `lua/config/lspconfig.lua:107-113`

### Adding New Snippet
1. Create `lua/snippets/{filetype}.lua`
2. Return array of snippet definitions using LuaSnip API
3. See `lua/snippets/makefile.lua` for example
4. Snippets auto-load on nvim-cmp initialization

### Adding New Plugin
1. Add spec to `lua/plugins/init.lua` with commit hash
2. Create config file in `lua/config/` if needed
3. Use lazy loading (`event`, `ft`, `cmd`, `keys`) when possible
4. Run `:Lazy sync` to install

## Important Notes

- **LSP API**: Uses new Neovim 0.11+ API (`vim.lsp.config` / `vim.lsp.enable`)
- **Commit pinning**: All plugins use exact commit hashes for stability
- **Format on save**: Enabled by default except for SQL files
- **Semantic tokens disabled**: Prevents LSP/Treesitter highlighting conflicts (`lua/config/lspconfig.lua:21`)
- **Mouse disabled**: `vim.opt.mouse = ""` in `lua/opts.lua:3`
- **Clipboard integration**: Uses system clipboard (`unnamedplus`)
- **Custom snippets**: Loaded from `lua/snippets/` directory
