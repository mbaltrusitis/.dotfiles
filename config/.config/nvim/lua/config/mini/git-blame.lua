local M = {}

M.ns_id = vim.api.nvim_create_namespace("current_line_blame")
M.enabled = false
M.cache = {}
M.loading = {} -- Track which buffers are currently loading

-- Async git blame for entire file
local function get_file_blame_async(filepath, buf, callback)
  -- Mark as loading to prevent duplicate calls
  if M.loading[buf] then
    return
  end
  M.loading[buf] = true

  local stdout_data = {}

  -- Use vim.system (Neovim 0.10+) for async
  vim.system({ "git", "blame", "--line-porcelain", filepath }, {
    stdout = function(_, data)
      if data then
        for line in data:gmatch("[^\r\n]+") do
          table.insert(stdout_data, line)
        end
      end
    end,
  }, function(result)
    M.loading[buf] = nil

    if result.code ~= 0 then
      callback(nil)
      return
    end

    -- Parse blame data
    local blame_data = {}
    local line_num = 0
    local current_commit, current_author, current_date, current_summary

    for _, line in ipairs(stdout_data) do
      if line:match("^%x+%s") then
        current_commit = line:match("^(%x+)")
        if current_commit:match("^0+$") then
          current_commit = nil
        else
          current_commit = current_commit:sub(1, 7)
        end
      elseif line:match("^author ") then
        current_author = line:match("^author (.+)$")
      elseif line:match("^author%-time ") then
        local timestamp = tonumber(line:match("^author%-time (.+)$"))
        current_date = os.date("%Y-%m-%d", timestamp)
      elseif line:match("^summary ") then
        current_summary = line:match("^summary (.+)$")
      elseif line:match("^filename ") then
        line_num = line_num + 1

        if current_commit then
          blame_data[line_num] = {
            commit = current_commit,
            author = current_author,
            date = current_date,
            summary = current_summary,
          }
        end

        current_commit = nil
        current_author = nil
        current_date = nil
        current_summary = nil
      end
    end

    callback(blame_data)
  end)
end

-- Update blame for current line (instant from cache or trigger async load)
local function update_blame()
  local buf = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(buf)

  vim.api.nvim_buf_clear_namespace(buf, M.ns_id, 0, -1)

  if not M.enabled or filepath == "" or not vim.uv.fs_stat(filepath) then
    return
  end

  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  -- If cache exists, show immediately
  if M.cache[buf] then
    local blame = M.cache[buf][line_num]

    if blame then
      local text = string.format("   %s, %s - %s", blame.author, blame.date, blame.summary)

      local opts = {
        virt_text = { { text, "Comment" } },
        virt_text_pos = "eol",
        priority = 100,
      }

      vim.api.nvim_buf_set_extmark(buf, M.ns_id, line_num - 1, 0, opts)
    end
  elseif not M.loading[buf] then
    -- Cache doesn't exist and not loading - start async load
    -- Show loading indicator
    local opts = {
      virt_text = { { "   Loading blame...", "Comment" } },
      virt_text_pos = "eol",
      priority = 100,
    }
    vim.api.nvim_buf_set_extmark(buf, M.ns_id, line_num - 1, 0, opts)

    -- Load async
    get_file_blame_async(filepath, buf, function(blame_data)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        M.cache[buf] = blame_data

        -- Update display after loading
        if M.enabled and vim.api.nvim_get_current_buf() == buf then
          update_blame()
        end
      end)
    end)
  end
  -- If loading, do nothing - will update when load completes
end

function M.enable()
  M.enabled = true

  local group = vim.api.nvim_create_augroup("CurrentLineBlame", { clear = true })

  -- INSTANT updates - uses cache or triggers async load
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    callback = update_blame,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = update_blame,
  })

  -- Clear cache on buffer changes
  vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = group,
    callback = function(args)
      M.cache[args.buf] = nil
      M.loading[args.buf] = nil
    end,
  })

  -- Clear virtual text in insert mode
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_clear_namespace(buf, M.ns_id, 0, -1)
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = update_blame,
  })

  -- Clear cache when buffer is deleted
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      M.cache[args.buf] = nil
      M.loading[args.buf] = nil
    end,
  })

  update_blame()
  vim.notify("Current line blame enabled", vim.log.levels.INFO)
end

function M.disable()
  M.enabled = false

  vim.api.nvim_del_augroup_by_name("CurrentLineBlame")

  -- Clear cache and loading state
  M.cache = {}
  M.loading = {}

  -- Clear all buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_clear_namespace(buf, M.ns_id, 0, -1)
    end
  end

  vim.notify("Current line blame disabled", vim.log.levels.INFO)
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

-- Manual cache refresh
function M.refresh()
  local buf = vim.api.nvim_get_current_buf()
  M.cache[buf] = nil
  M.loading[buf] = nil
  update_blame()
  vim.notify("Blame cache refreshed", vim.log.levels.INFO)
end

return M
