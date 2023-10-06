
local Just = require('just-nvim.just')
just_handle = Just.new()


local M = {Opts = {}, }









function M.setup(opts)
   if not just_handle:init() then
      vim.notify("just not found", vim.log.levels.INFO)
   end
end

function M.handle()
   return just_handle
end

return M
