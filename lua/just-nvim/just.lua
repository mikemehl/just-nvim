local window = require("just-nvim.window")
local just = {}

local Just = {}

local function find_command()
	local just_cmd = vim.system({ "which", "just" }, { text = true }):wait()
	if just_cmd.code ~= 0 then
		return nil
	end
	return string.gsub(just_cmd.stdout, "\n", "")
end

local function get_recipies()
	local recipes = {}
	local recipes_cmd = vim.system({ "just", "--summary" }, { text = true }):wait()
	if recipes_cmd.code == 0 then
		for line in string.gmatch(recipes_cmd.stdout, "%w+") do
			table.insert(recipes, line)
		end
	end
	return recipes
end

function Just:init()
	self.cmd = find_command()
	self.recipes = get_recipies()
	return self:valid()
end

function Just:valid()
	return self.cmd ~= nil and #self.recipes > 0
end

function Just:run_recipe(recipe, win_method)
	assert(type(recipe) == "string", "Recipe must be a string")
	if recipe == "" then
		recipe = self.recipes[1]
	end
	local win = window.new(win_method)
	win:open()
	win:run(self.cmd .. " " .. recipe)
	return true
end

function just.new()
	local self = setmetatable({}, { __index = Just })
	return self
end

return just
