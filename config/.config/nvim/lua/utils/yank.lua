local M = {}

-- Get the current file path based on context
-- Works in both normal buffers and mini.files
local function get_current_path()
  -- Check if we're in a mini.files buffer
  if vim.bo.filetype == "minifiles" then
    local ok, MiniFiles = pcall(require, "mini.files")
    if ok then
      local entry = MiniFiles.get_fs_entry()
      if entry then
        return entry.path
      end
    end
    return nil
  else
    -- Normal buffer
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
      return nil
    end
    return path
  end
end

-- Yank filename with extension
function M.yank_filename()
  local path = get_current_path()
  if not path or path == "" then
    vim.notify("No file under cursor", vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.fnamemodify(path, ":t")
  vim.fn.setreg("+", filename)
  vim.notify("Yanked filename: " .. filename, vim.log.levels.INFO)
end

-- Yank basename (filename without extension)
function M.yank_basename()
  local path = get_current_path()
  if not path or path == "" then
    vim.notify("No file under cursor", vim.log.levels.WARN)
    return
  end

  local basename = vim.fn.fnamemodify(path, ":t:r")
  vim.fn.setreg("+", basename)
  vim.notify("Yanked basename: " .. basename, vim.log.levels.INFO)
end

-- Yank absolute path
function M.yank_absolute()
  local path = get_current_path()
  if not path or path == "" then
    vim.notify("No file under cursor", vim.log.levels.WARN)
    return
  end

  local absolute = vim.fn.fnamemodify(path, ":p")
  vim.fn.setreg("+", absolute)
  vim.notify("Yanked absolute path: " .. absolute, vim.log.levels.INFO)
end

-- Yank relative path (relative to cwd)
function M.yank_relative()
  local path = get_current_path()
  if not path or path == "" then
    vim.notify("No file under cursor", vim.log.levels.WARN)
    return
  end

  local relative = vim.fn.fnamemodify(path, ":.")
  vim.fn.setreg("+", relative)
  vim.notify("Yanked relative path: " .. relative, vim.log.levels.INFO)
end

return M
