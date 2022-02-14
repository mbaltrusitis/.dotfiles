function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if file_exists("/Users/heatmiser/.vimrc_background") then
  vim.cmd("let base16colorspace=256")
  vim.cmd("source /Users/heatmiser/.vimrc_background")
end

require('plugins')
require('settings')
require('keybindings')
