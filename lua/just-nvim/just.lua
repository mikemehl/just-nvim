local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; local M = {Just = {}, }








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

function M.Just.new()
   local just = {}
   just.cmd = find_command()
   just.recipes = get_recipies()
   return M.Just
end

function M.Just:valid()
   return self.cmd ~= nil and #self.recipes > 0
end

return M
