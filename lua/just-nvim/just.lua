local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table
local Just = {Opts = {}, }









































local function find_command()
   local just_cmd = vim.system({ 'which', 'just' }, { text = true }):wait()
   if just_cmd.code ~= 0 then
      return nil
   end
   return just_cmd.stdout
end

local function get_recipies()
   local recipes = {}
   local recipes_cmd = vim.system({ 'just', '--summary' }, { text = true }):wait()
   if recipes_cmd.code == 0 then
      for line in string.gmatch(recipes_cmd.stdout, "%w+") do
         print(line)
         table.insert(recipes, line)
      end
   end
   return recipes
end

function Just.new()
   return {}
end

function Just:init()
   self.cmd = find_command()
   self.recipes = get_recipies()
   return self:valid()
end

function Just:valid()
   return self.cmd ~= nil and #self.recipes > 0
end

local function on_recipe_exit(sys_cmd)
   if sys_cmd.code ~= 0 then
      vim.notify("Failed to run just recipe", vim.log.levels.ERROR)
   else
      vim.notify("Just recipe ran successfully", vim.log.levels.INFO)
   end
end

function Just:run_recipe(recipie, opts)
   vim.fn.systemlist({ self.cmd, recipie }, { stdin = true, stdout = true, on_exit = on_recipe_exit })
   return true
end

return Just
