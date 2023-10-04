local M = {Just = {}, }









function M.Just:new(just_cmd)
   return { cmd = just_cmd }
end

function M.init()
   local just_cmd = vim.system({ 'which', 'just' }, { text = true }):wait()
   if just_cmd.code ~= 0 then
      return nil
   end
   return { cmd = just_cmd, recipes = {} }
end

return M
