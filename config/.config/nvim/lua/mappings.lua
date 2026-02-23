local map = vim.keymap.set

-- buffer management
map("n", "<tab>", function()
  vim.cmd.bnext()
end, { desc = "buffer next" })

map("n", "<S-tab>", function()
  vim.cmd.bprevious()
end, { desc = "buffer previous" })

map("n", "<leader>x", function()
  vim.cmd.bdelete()
end, { desc = "buffer close" })

map("n", "<leader>b", function()
  vim.cmd.enew()
end, { desc = "buffer new" })

map("n", "<leader><leader>", "<C-^>", { desc = "Toggle alternate file" })

-- quickfix list
map("n", "<leader>ql", function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid ~= 0 then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix window" })

map("n", "<leader>qx", function()
  vim.fn.setqflist({})
end, { desc = "Clear quickfix list" })

map("n", "]q", function()
  local ok = pcall(vim.cmd.cnext)
  if not ok then
    pcall(vim.cmd.cfirst)
  end
end, { desc = "Next quickfix item" })

map("n", "[q", function()
  local ok = pcall(vim.cmd.cprev)
  if not ok then
    pcall(vim.cmd.clast)
  end
end, { desc = "Previous quickfix item" })

map("n", "]Q", function()
  vim.cmd.clast()
end, { desc = "Last quickfix item" })

map("n", "[Q", function()
  vim.cmd.cfirst()
end, { desc = "First quickfix item" })

local qf_sort_ascending = true
map("n", "<leader>qs", function()
  local qflist = vim.fn.getqflist()
  table.sort(qflist, function(a, b)
    local filename_a = vim.fn.bufname(a.bufnr)
    local filename_b = vim.fn.bufname(b.bufnr)
    if qf_sort_ascending then
      return filename_a < filename_b
    else
      return filename_a > filename_b
    end
  end)
  vim.fn.setqflist(qflist, "r")
  local direction = qf_sort_ascending and "ascending" or "descending"
  vim.notify("Quickfix sorted by filename (" .. direction .. ")", vim.log.levels.INFO)
  qf_sort_ascending = not qf_sort_ascending
end, { desc = "Sort quickfix list by filename (toggle direction)" })

-- diagnostics list
map("n", "<leader>dl", function()
  local loc_winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if loc_winid ~= 0 then
    vim.cmd("lclose")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "Toggle diagnostic location list" })

map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic float" })

map("n", "]l", function()
  local ok = pcall(vim.cmd.lnext)
  if not ok then
    pcall(vim.cmd.lfirst)
  end
end, { desc = "Next location list item" })

map("n", "[l", function()
  local ok = pcall(vim.cmd.lprev)
  if not ok then
    pcall(vim.cmd.llast)
  end
end, { desc = "Previous location list item" })

map("n", "]L", function()
  vim.cmd.llast()
end, { desc = "Last location list item" })

map("n", "[L", function()
  vim.cmd.lfirst()
end, { desc = "First location list item" })

-- Modern diagnostic navigation (Neovim 0.11+)
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })

-- relative // absolute line numbers
map("n", "<leader>rn", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative line numbers" })

-- telescope
local TeleBuiltin = require("telescope.builtin")
local TeleActions = require("telescope.actions")
map("n", "<leader>ff", TeleBuiltin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", TeleBuiltin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", function()
  -- delete buffers
  TeleBuiltin.buffers({
    attach_mappings = function(prompt_bufnr, tmap)
      tmap("n", "<C-c>", function()
        TeleActions.delete_buffer(prompt_bufnr)
      end)
      tmap("i", "<C-c>", function()
        TeleActions.delete_buffer(prompt_bufnr)
      end)
      return true
    end,
  })
end, { desc = "Telescope buffers" })
map("n", "<leader>fh", TeleBuiltin.help_tags, { desc = "Telescope help tags" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- harpoon
local function fn_harpoon_nav_file(n)
  return function()
    require("harpoon.ui").nav_file(n)
  end
end

map("n", "<leader>H", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "harpoon quick menu" })

map("n", "<leader>a", function()
  require("harpoon.mark").add_file()
end, { desc = "harpoon add mark" })

map("n", "<leader>1", fn_harpoon_nav_file(1), { desc = "harpoon open file 1" })
map("n", "<leader>2", fn_harpoon_nav_file(2), { desc = "harpoon open file 2" })
map("n", "<leader>3", fn_harpoon_nav_file(3), { desc = "harpoon open file 3" })
map("n", "<leader>4", fn_harpoon_nav_file(4), { desc = "harpoon open file 4" })

-- window navigation with Ctrl + hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- window splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split window horizontally" })

-- window resizing with Alt + hjkl
map("n", "<M-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<M-j>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<M-k>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<M-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- mini.files
local MiniFiles = require("mini.files")
map("n", "<C-n>", function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
  end
end, { desc = "Open mini.files (current file directory)" })

map("n", "<leader>e", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open mini.files (current file directory)" })

map("n", "<leader>E", function()
  MiniFiles.open(vim.uv.cwd(), true)
end, { desc = "Open mini.files (cwd)" })

-- map ctrl+c to copy entire buffer
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file to clipboard" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })

-- yank file paths
local yank = require("utils.yank")
map("n", "yf", yank.yank_filename, { desc = "Yank filename" })
map("n", "yb", yank.yank_basename, { desc = "Yank basename" })
map("n", "ya", yank.yank_absolute, { desc = "Yank absolute path" })
map("n", "yr", yank.yank_relative, { desc = "Yank relative path" })

-- rename file
local rename = require("utils.rename")
map("n", "<leader>rf", rename.rename_file, { desc = "Rename file" })
map("n", "<F2>", rename.rename_file, { desc = "Rename file" })

-- git blame
vim.keymap.set("n", "<leader>gb", function()
  require("config.mini.git-blame").toggle()
end, { desc = "Toggle git blame" })

-- mini.starter
vim.keymap.set("n", "<leader>ss", function()
  require("mini.starter").open()
end, { desc = "Open start screen" })

-- conform
map("n", "<leader>fm", function()
  require("conform").format({ async = true }, function(err)
    if err then
      vim.notify("Format failed: " .. tostring(err), vim.log.levels.ERROR)
    else
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", true)
      end
      vim.notify("Buffer formatted", vim.log.levels.INFO)
    end
  end)
end, { desc = "Format buffer" })

-- claudecode
map("n", "<leader>cf", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Claude: add current file" })
map("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude: send selection" })
map("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
map("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude: deny diff" })
map("n", "<leader>ci", "<cmd>ClaudeCodeStatus<cr>", { desc = "Claude: server status" })
