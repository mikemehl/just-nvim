local record M
  record Just 
    cmd: string
    recipes: {string}
    new: function(self: Just, just_cmd: string): Just
  end

  init: function(): Just | nil
end

function M.Just:new(just_cmd: string): M.Just
  return {cmd = just_cmd}
end

function M.init(): M.Just | nil
  local just_cmd = vim.system({'which', 'just'}, {text = true}):wait()
  if just_cmd.code ~= 0 then
    return nil
  end
  return {cmd = just_cmd, recipes = {}} as M.Just
end

return M
