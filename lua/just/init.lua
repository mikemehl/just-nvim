local just = {}

_G.just_handle = require("just.just_cmd").new()
_G.just_windows = {}

local default_opts = {
	method = "split",
}

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

function just.run_recipe(recipe)
	local win = just_handle:run_recipe(recipe, _G.opts.method)
	if win then
		table.insert(just_windows, win)
	end
end

function just.get_recipes()
	return just_handle.recipes
end

function just.handle()
	return just_handle
end

return just
