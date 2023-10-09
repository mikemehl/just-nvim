local window = {}

local Window = {}

function Window:open()
	self.winid = vim.api.nvim_open_win(self.bufnr, true, {
		relative = "editor",
		width = 40,
		height = 10,
		row = 1,
		col = 1,
	})
end

function Window:close()
	vim.api.nvim_win_close(self.winid, true)
end

function window.new()
	local self = setmetatable({
		bufnr = vim.api.nvim_create_buf(false, false),
		winid = nil,
	}, { __index = Window })
	return self
end

return window
