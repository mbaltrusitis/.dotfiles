require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- loclist
map("n", "<leader>lo", "<cmd>:lopen <CR>", { desc = "loclist open"})
map("n", "<leader>lc", "<cmd>:lclose<CR>", { desc = "loclist close"})
map("n", "<leader>ln", "<cmd>:lnext <CR>", { desc = "loclist next"})
map("n", "<leader>lp", "<cmd>:lprev <CR>", { desc = "loclist prev"})
map("n", "<leader>l<n>", "<cmd>:ll<n> <CR>", { desc = "loclist nth item"})

-- harpoon
local function fn_harpoon_nav_file(n)
	return function()
		require("harpoon.ui").nav_file(n)
	end
end

map("n", "<leader>H", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "harpoon quick menu"}
)
map("n", "<leader>a", function()
	require("harpoon.mark").add_file()
end, { desc = "harpoon add mark"})
map("n", "<leader>1", fn_harpoon_nav_file(1), { desc = "harpoon open file 1"})
map("n", "<leader>2", fn_harpoon_nav_file(2), { desc = "harpoon open file 2"})
map("n", "<leader>3", fn_harpoon_nav_file(3), { desc = "harpoon open file 3"})
map("n", "<leader>4", fn_harpoon_nav_file(4), { desc = "harpoon open file 4"})

-- telescope
local funcs = require("funcs")
map("n", "<leader>gn", function()
	funcs.grep_notes()
	end, { desc = "Telescope grep note files"}
)
map("n", "<leader>fn", function()
	funcs.find_notes()
	end, { desc = "Telescope search note files"}
)
map("n", "<leader>gc", function()
	funcs.grep_configs()
	end, { desc = "Telescope grep config files"}
)
map("n", "<leader>fc", function()
	funcs.find_configs()
	end, { desc = "Telescope search config files"}
)

-- zenmode
map("n", "<leader>zm", "<cmd>ZenMode<CR>", { desc = "ZenMode toggle Zenmode" })
