local headers = {

  [[
▄▄ • ▌ ▄ ·.  ▄▄▄· ▄▄▄▄▄▄▄▄▄▄ ▄ .▄▄▄▄ .▄▄▌ ▐ ▄▌
██▌·██ ▐███▪▐█ ▀█ •██  •██  ██▪▐█▀▄.▀·██· █▌▐█
▐█·▐█ ▌▐▌▐█·▄█▀▀█  ▐█.▪ ▐█.▪██▀▐█▐▀▀▪▄██▪▐█▐▐▌
.▀ ██ ██▌▐█▌▐█ ▪▐▌ ▐█▌· ▐█▌·██▌▐▀▐█▄▄▌▐█▌██▐█▌
 ▀ ▀▀  █▪▀▀▀ ▀  ▀  ▀▀▀  ▀▀▀ ▀▀▀ · ▀▀▀  ▀▀▀▀ ▀▪
  ]],

  [[
   / _______ _______ _______ _______ _     _ _______ _  _  _
  /  |  |  | |_____|    |       |    |_____| |______ |  |  |
 .   |  |  | |     |    |       |    |     | |______ |__|__|
  ]],

  [[
██╗███╗   ███╗ █████╗ ████████╗████████╗██╗  ██╗███████╗██╗    ██╗
██║████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝██║  ██║██╔════╝██║    ██║
██║██╔████╔██║███████║   ██║      ██║   ███████║█████╗  ██║ █╗ ██║
╚═╝██║╚██╔╝██║██╔══██║   ██║      ██║   ██╔══██║██╔══╝  ██║███╗██║
██╗██║ ╚═╝ ██║██║  ██║   ██║      ██║   ██║  ██║███████╗╚███╔███╔╝
╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝
]],

  [[
░█░█▄█░█▀█░▀█▀░▀█▀░█░█░█▀▀░█░█
░▀░█░█░█▀█░░█░░░█░░█▀█░█▀▀░█▄█
░▀░▀░▀░▀░▀░░▀░░░▀░░▀░▀░▀▀▀░▀░▀
  ]],

  [[

                                    █
   █                    █      █    █
   █                    █      █    █
   █    ██▓█▓  ░███░  █████  █████  █▒██▒   ███  █░    █
   █    █▒█▒█  █▒ ▒█    █      █    █▓ ▒█  ▓▓ ▒█ ▓▒   ▒█
   █    █ █ █      █    █      █    █   █  █   █ ░█ █ █▒
   █    █ █ █  ▒████    █      █    █   █  █████  █▒█▒█
        █ █ █  █▒  █    █      █    █   █  █      █████
   █    █ █ █  █░ ▓█    █░     █░   █   █  ▓▓  █  ▒█▒█▒
   █    █ █ █  ▒██▒█    ▒██    ▒██  █   █   ███▒   █ █

  ]],

  [[
8
88 eeeeeee eeeee eeeee eeeee e   e eeee e   e  e
88 8  8  8 8   8   8     8   8   8 8    8   8  8
88 8e 8  8 8eee8   8e    8e  8eee8 8eee 8e  8  8
   88 8  8 88  8   88    88  88  8 88   88  8  8
88 88 8  8 88  8   88    88  88  8 88ee 88ee8ee8
  ]],
}

local headers = {
  [[
           ___/\/\____/\/\__/\/\/\/\/\/\______/\/\____/\/\/\/\/\/\______________
          ___/\/\____/\/\__/\______________/\/\/\/\______/\/\__________________
         ___/\/\/\/\/\/\__/\/\/\/\/\____/\/\____/\/\____/\/\__________________
        ___/\/\____/\/\__/\/\__________/\/\/\/\/\/\____/\/\__________________
       ___/\/\____/\/\__/\/\/\/\/\/\__/\/\____/\/\____/\/\__________________
      _____________________________________________________________________
     _/\/\______/\/\__/\/\/\/\____/\/\/\/\/\__/\/\/\/\/\/\__/\/\/\/\/\____
    _/\/\/\__/\/\/\____/\/\____/\/\__________/\____________/\/\____/\/\__
   _/\/\/\/\/\/\/\____/\/\______/\/\/\/\____/\/\/\/\/\____/\/\/\/\/\____
  _/\/\__/\__/\/\____/\/\____________/\/\__/\/\__________/\/\__/\/\____
 _/\/\______/\/\__/\/\/\/\__/\/\/\/\/\____/\/\/\/\/\/\__/\/\____/\/\__
_____________________________________________________________________
  ]],
}

-- Create highlight groups - re-apply after colorscheme changes
local function set_starter_hl()
  vim.api.nvim_set_hl(0, "MiniStarterSlash", { fg = "#ff0000", ctermfg = 196 }) -- / red
  vim.api.nvim_set_hl(0, "MiniStarterBackslash", { fg = "#ff8800", ctermfg = 208 }) -- \ orange
  vim.api.nvim_set_hl(0, "MiniStarterUnderscore", { fg = "#444444", ctermfg = 238 }) -- _ dark grey
end
set_starter_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_starter_hl })

-- Content hook to colorize header characters
-- /\ patterns: all red except the final \ which is orange
local function colorize_slashes(content)
  for _, line in ipairs(content) do
    local new_line = {}
    for _, unit in ipairs(line) do
      if unit.type == "header" then
        local str = unit.string
        local i = 1
        while i <= #str do
          local char = str:sub(i, i)

          if char == "/" then
            -- Look for /\ pattern sequence
            local j = i
            while j <= #str - 1 and str:sub(j, j) == "/" and str:sub(j + 1, j + 1) == "\\" do
              j = j + 2
            end

            if j > i then
              -- Found at least one /\ pair (j points past the last pair)
              -- Color i to j-2 as red (all but last \)
              -- Color j-1 as orange (the last \)
              if j - 1 > i then
                table.insert(new_line, { string = str:sub(i, j - 2), type = "header", hl = "MiniStarterSlash" })
              end
              table.insert(new_line, { string = str:sub(j - 1, j - 1), type = "header", hl = "MiniStarterBackslash" })
              i = j
            else
              -- Standalone / (not followed by \)
              table.insert(new_line, { string = "/", type = "header", hl = "MiniStarterSlash" })
              i = i + 1
            end

          elseif char == "\\" then
            -- Standalone \ (not part of a /\ pattern)
            table.insert(new_line, { string = "\\", type = "header", hl = "MiniStarterBackslash" })
            i = i + 1

          elseif char == "_" then
            -- Collect consecutive underscores
            local j = i
            while j <= #str and str:sub(j, j) == "_" do
              j = j + 1
            end
            table.insert(new_line, { string = str:sub(i, j - 1), type = "header", hl = "MiniStarterUnderscore" })
            i = j

          else
            -- Collect consecutive non-special chars
            local j = i
            while j <= #str do
              local c = str:sub(j, j)
              if c == "/" or c == "\\" or c == "_" then
                break
              end
              j = j + 1
            end
            table.insert(new_line, { string = str:sub(i, j - 1), type = "header", hl = "MiniStarterHeader" })
            i = j
          end
        end
      else
        table.insert(new_line, unit)
      end
    end
    -- Replace line contents
    for i = 1, #line do
      line[i] = nil
    end
    for i, unit in ipairs(new_line) do
      line[i] = unit
    end
  end
  return content
end

local starter = require("mini.starter")

return {
  header = function()
    math.randomseed(os.time())
    return headers[math.random(#headers)]
  end,
  content_hooks = {
    colorize_slashes,
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.aligning("center", "center"),
  },
}
