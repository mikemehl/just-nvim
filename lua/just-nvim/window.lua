local window = {}

local Window = {}

local function open_float(bufnr)
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	local win_width = math.ceil(width * 0.8 - 4)
	local win_height = math.ceil(height * 0.8 - 4)
	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
	}
	return vim.api.nvim_open_win(bufnr, true, opts)
end

local function open_split(bufnr)
	vim.cmd("vsplit")
	local winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winid, bufnr)
	return winid
end

function Window:open()
	if self.method == "float" then
		self.winid = open_float(self.bufnr)
	elseif self.method == "split" then
		self.winid = open_split(self.bufnr)
	end
	print(vim.inspect(self.winid))
	vim.api.nvim_set_current_win(self.winid)
end

function Window:close()
	vim.api.nvim_win_close(self.winid, true)
end

function Window:run(cmd)
	vim.api.nvim_set_current_win(self.winid)
	local chan_id = vim.api.nvim_open_term(self.bufnr, {})
	vim.api.nvim_chan_send(chan_id, cmd .. "\n")
end

function window.new(method)
	local self = setmetatable({
		bufnr = vim.api.nvim_create_buf(false, false),
		method = method or "float",
		winid = nil,
	}, { __index = Window })
	assert(self.method == "float" or self.method == "split", "method must be float or split")
	return self
end

return window
