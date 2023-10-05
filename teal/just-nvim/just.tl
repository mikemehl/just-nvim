local record M
  record Just 
    cmd: string
    recipes: {string}
    new: function(): Just
    valid: function(Just): boolean
  end
end

local function find_command(): string | nil 
  local just_cmd = vim.system({'which', 'just'}, {text = true}):wait()
  if just_cmd.code ~= 0 then
    return nil
  end
  return just_cmd.stdout as string
end

local function get_recipies(): {string}
  local recipes: {string} = {}
  local recipes_cmd = vim.system({'just', '--summary'}, {text = true}):wait()
  if recipes_cmd.code == 0 then
    for line in string.gmatch(recipes_cmd.stdout as string, "%w+") do
      print(line)
      table.insert(recipes, line)
    end
  end
  return recipes
end

function M.Just.new(): M.Just
  local just: M.Just = {}
  just.cmd = find_command()
  just.recipes = get_recipies()
  return M.Just
end

function M.Just:valid(): boolean
  return self.cmd ~= nil and #self.recipes > 0
end

return M
