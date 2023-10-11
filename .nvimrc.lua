vim.cmd([[set rtp+=~/code/just-nvim/]])
require("just").setup({ method = "float" })
require("telescope").load_extension("just")
