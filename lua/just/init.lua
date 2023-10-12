---@module 'just'
---@alias SplitMethod 'float' | 'split' | 'tmux-pane' | 'tmux-win'
local just = {}

---@type JustCmd
_G.just_handle = require("just.just_cmd").new()

---@type number[]
_G.just_windows = {}

---@type table
local default_opts = {
  ---@type SplitMethod
  method = "split",
}

---Setup the plugin.
---@param opts table
function just.setup(opts)
  _G.opts = opts or default_opts
  if not just_handle:init() then
    vim.notify("just not found", vim.log.levels.INFO)
    return
  end
  vim.api.nvim_create_user_command("Just", function(cmd)
    just.run_recipe(cmd.args)
  end, { nargs = "*" })
end

---Run a recipe.
---@param recipe string
function just.run_recipe(recipe)
  local win = just_handle:run_recipe(recipe, _G.opts.method)
  if win then
    table.insert(just_windows, win)
  end
end

---Get the available recipes.
---@return string[]
function just.get_recipes()
  return just_handle.recipes
end

---Get a reference to the just command handle.
---@return JustCmd
function just.handle()
  return just_handle
end

return just
