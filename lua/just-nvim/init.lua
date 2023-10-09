Just = require("just-nvim.just").new()

local M = { Opts = {} }

function M.setup(opts)
	if not Just:init() then
		vim.notify("just not found", vim.log.levels.INFO)
		return
	end
	vim.api.nvim_create_user_command("Just", function(cmd)
		print(cmd.args)
		if cmd.args == nil then
			return
		end
		Just:run_recipe(cmd.args)
	end, {})
end

function M.handle()
	return Just
end

return M
