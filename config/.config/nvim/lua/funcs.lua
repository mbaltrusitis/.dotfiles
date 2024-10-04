local telescope = require("telescope.builtin")
local M = {}

function M.grep_notes()
	local opts = {}
	opts.prompt_title = "search notes."
	opts.prompt_prefix = "notes content :: "
	opts.search_dirs = {"$HOME/Vaults/", "$HOME/Documents"}
	opts.shorten_path = true

	telescope.live_grep(opts)
end

function M.find_notes()
	local opts = {}
	opts.prompt_title = "find notes."
	opts.prompt_prefix = "notes :: "
	opts.search_dirs = {
		"$HOME/Vaults/",
		"$HOME/Documents/",
	}

	telescope.find_files(opts)
end

function M.find_configs()
	local opts = {}
	opts.prompt_title = "find config."
	opts.prompt_prefix = "config :: "
	opts.search_dirs = {
		"$HOME/.bashrc",
		"$HOME/.config",
		"$HOME/.config/nvim/lua/custom",
		"$HOME/.profile",
		"$HOME/.ssh",
		"$HOME/.tmux.conf",
	}

	telescope.find_files(opts)
end

function M.grep_configs()
	local opts = {}
	opts.prompt_title = "search config."
	opts.prompt_prefix = "config content :: "
	opts.shorten_path = true
	opts.search_dirs = {
		"$HOME/.bashrc",
		"$HOME/.config",
		"$HOME/.profile",
		"$HOME/.ssh",
		"$HOME/.tmux.conf",
	}

	telescope.live_grep(opts)
end

return M
