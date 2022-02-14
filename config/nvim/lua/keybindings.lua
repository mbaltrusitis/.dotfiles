-- helper functions
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- NERDTree
nmap("<leader>n", ":NERDTreeToggle<CR>")  -- toggle sidebar
nmap("<F3>", ":noh<CR>")  -- clear search highlights

