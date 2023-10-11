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

local function open_tmux_pane(cmd)
	vim.system({ "tmux", "split-window", "-h", "-p", "50", "-c", vim.fn.getcwd(), cmd .. " ; read -n 1" }):wait()
end

local function open_tmux_win(cmd)
	vim.system({ "tmux", "new-window", "-c", vim.fn.getcwd(), cmd .. " ; read -n 1" }):wait()
end

local function is_valid_method(method)
	return method == "float" or method == "split" or method == "tmux-pane" or method == "tmux-win"
end

function Window:open()
	if self.method == "float" then
		self.winid = open_float(self.bufnr)
	elseif self.method == "split" then
		self.winid = open_split(self.bufnr)
	else
		return
	end
	vim.api.nvim_set_current_win(self.winid)
end

function Window:close()
	vim.api.nvim_win_close(self.winid, true)
end

function Window:run(cmd)
	if self.method == "tmux-pane" then
		open_tmux_pane(cmd)
		return nil
	elseif self.method == "tmux-win" then
		open_tmux_win(cmd)
		return nil
	end
	vim.api.nvim_set_current_win(self.winid)
	vim.fn.termopen(cmd)
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = self.bufnr,
		callback = function()
			vim.keymap.set({ "n", "x" }, "q", function()
				self:close()
			end, { noremap = false, silent = false })
			return true
		end,
	})
end

function window.new(method)
	local self = setmetatable({
		bufnr = vim.api.nvim_create_buf(false, false),
		method = method or "float",
		winid = nil,
	}, { __index = Window })
	assert(
		is_valid_method(self.method),
		"Invalid method " .. method .. ". Must be one of: float, split, tmux-pane, tmux-win"
	)
	return self
end

return window
