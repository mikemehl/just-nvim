local window = require("just.window")

---@module 'just_cmd'
local just_cmd = {}

---@class JustCmd
local JustCmd = {}

---Find the just executable.
---@return nil|string
local function find_command()
  local which_cmd = vim.system({ "which", "just" }, { text = true }):wait()
  if which_cmd.code ~= 0 then
    return nil
  end
  local cmd_str, _ = string.gsub(which_cmd.stdout, "\n", "")
  return cmd_str
end

---Get the available recipes.
---@return string[]
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

---Initialize the just command handle.
---@return boolean true if just is available, false otherwise
function JustCmd:init()
  self.cmd = find_command()
  self.recipes = get_recipes()
  return self:valid()
end

---Determine if the just command handle is valid.
---@return boolean
function JustCmd:valid()
  return self.cmd ~= nil and #self.recipes > 0
end

---Run a recipe.
---@param recipe string
---@param win_method SplitMethod
---@return Window | nil the window that the recipe is running in, or nil if tmux is used
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

---Create a new just command handle.
---@return JustCmd
function just_cmd.new()
  local self = setmetatable({}, { __index = JustCmd })
  return self
end

return just_cmd
