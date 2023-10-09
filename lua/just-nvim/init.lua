local just_nvim = {}
just_handle = require("just-nvim.just").new()

function just_nvim.setup(opts)
	if not just_handle:init() then
		vim.notify("just not found", vim.log.levels.INFO)
		return
	end
	vim.api.nvim_create_user_command("Just", function(cmd)
		print(cmd.args)
		if cmd.args == nil then
			return
		end
		just_handle:run_recipe(cmd.args)
	end, {})
end

function just_nvim.handle()
	return just_handle
end

return just_nvim
