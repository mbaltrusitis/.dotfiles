local M = {}
local uv = vim.uv or vim.loop

function M.rename_file()
  if vim.bo.filetype == "minifiles" then
    vim.notify("Use mini.files' built-in rename command", vim.log.levels.INFO)
    return
  end

  -- Get current file path
  local filepath = vim.api.nvim_buf_get_name(0)

  if filepath == "" or filepath == nil then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  -- Check if buffer has unsaved changes
  if vim.bo.modified then
    vim.notify("Save buffer before renaming", vim.log.levels.WARN)
    return
  end

  local current_name = vim.fn.fnamemodify(filepath, ":t")
  local dir = vim.fn.fnamemodify(filepath, ":h")

  -- Helper function to perform the actual rename
  local function perform_rename(old_path, new_path, display_name)
    local ok, err = uv.fs_rename(old_path, new_path)
    if not ok then
      vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    -- Update buffer to point to new file
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(buf, new_path)
    vim.cmd.edit()

    vim.notify("File renamed to: " .. display_name, vim.log.levels.INFO)
  end

  vim.ui.input({
    prompt = "New filename: ",
    default = current_name,
    completion = "file",
  }, function(new_name)
    -- User cancelled
    if not new_name or new_name == "" then
      vim.notify("Rename cancelled", vim.log.levels.INFO)
      return
    end

    -- No change
    if new_name == current_name then
      vim.notify("Same filename, no action taken", vim.log.levels.INFO)
      return
    end

    local new_filepath = dir .. "/" .. new_name

    -- Check if target file already exists
    local stat = uv.fs_stat(new_filepath)
    if stat then
      vim.notify("File already exists: " .. new_filepath, vim.log.levels.WARN)
      vim.ui.input({
        prompt = "Overwrite? (y/N): ",
      }, function(response)
        if not response or string.lower(response) ~= "y" then
          vim.notify("Rename cancelled", vim.log.levels.INFO)
          return
        end
        perform_rename(filepath, new_filepath, new_name)
      end)
      return -- CRITICAL: Stop execution here to wait for user confirmation
    end

    -- File doesn't exist, proceed with rename
    perform_rename(filepath, new_filepath, new_name)
  end)
end

return M
