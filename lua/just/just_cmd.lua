local window = require("just.window")
local just_cmd = {}

local JustCmd = {}

local function find_command()
  local which_cmd = vim.system({ "which", "just" }, { text = true }):wait()
  if which_cmd.code ~= 0 then
    return nil
  end
  return string.gsub(which_cmd.stdout, "\n", "")
end

local function get_recipes()
  local recipes = {}
  local recipes_cmd = vim.system({ "just", "--summary" }, { text = true }):wait()
  if recipes_cmd.code == 0 then
    for line in string.gmatch(recipes_cmd.stdout, "%w+") do
      table.insert(recipes, line)
    end
  end
  return recipes
end

function JustCmd:init()
  self.cmd = find_command()
  self.recipes = get_recipes()
  return self:valid()
end

function JustCmd:valid()
  return self.cmd ~= nil and #self.recipes > 0
end

function JustCmd:run_recipe(recipe, win_method)
  assert(type(recipe) == "string", "Recipe must be a string")
  if recipe == "" then
    recipe = self.recipes[1]
  end
  local win = window.new(win_method)
  win:open()
  win:run(self.cmd .. " " .. recipe)
  return win
end

function just_cmd.new()
  local self = setmetatable({}, { __index = JustCmd })
  return self
end

return just_cmd
