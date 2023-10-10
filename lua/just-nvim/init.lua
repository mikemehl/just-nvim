local just_nvim = {}

_G.just_handle = require("just-nvim.just").new()

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
		if cmd.args == nil then
			return
		end
		just_handle:run_recipe(cmd.args, _G.opts.method)
	end, {})
end

function just_nvim.handle()
	return just_handle
end

return just_nvim
