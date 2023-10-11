local just_nvim = {}

_G.just_handle = require("just-nvim.just").new()
_G.just_windows = {}

local default_opts = {
	method = "split",
}

function just_nvim.setup(opts)
	_G.opts = opts or default_opts
	if not just_handle:init() then
		vim.notify("just not found", vim.log.levels.INFO)
		return
	end
	vim.api.nvim_create_user_command("Just", function(cmd)
		just_nvim.run_recipe(cmd.args)
	end, {})
end

function just_nvim.run_recipe(recipe)
	local win = just_handle:run_recipe(recipe, _G.opts.method)
	table.insert(just_windows, win)
end

function just_nvim.handle()
	return just_handle
end

return just_nvim
