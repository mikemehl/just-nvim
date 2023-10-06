-- Initialize handle
local Just = require('just-nvim.just')
global just_handle: Just = Just.new()

-- Declare Interface
local record M
  record Opts
  end

  just_handle: Just
  setup: function(Opts): nil 
  handle: function(): Just
end

-- Implement interface
function M.setup(opts: M.Opts): nil
  if not just_handle:init() then
    vim.notify("just not found", vim.log.levels.INFO)
  end
end

function M.handle(): Just
  return just_handle
end

return M
