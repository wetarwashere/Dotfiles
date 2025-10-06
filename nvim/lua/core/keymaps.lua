-- keybindings for saving file
vim.keymap.set({ "n", "v", "i" }, "<C-s>", "<Esc>:wq<CR>", { silent = true, desc = "Save file and quit" })
vim.keymap.set({ "n", "v", "i" }, "<C-q>", "<Esc>:q!<CR>", { silent = true, desc = "Force quit" })
vim.keymap.set({ "n", "v", "i" }, "<C-o>", "<Esc>:w<CR>", { silent = true, desc = "Save file" })

-- Some keybindings for faster movements
vim.keymap.set(
	{ "i" },
	"<C-g>",
	"<Esc>$i",
	{ silent = true, desc = "Move to the last char of the line (space included)" }
)
vim.keymap.set({ "i" }, "<C-d>", "<Esc>g_i", { silent = true, desc = "Move to the last char of the line" })
vim.keymap.set(
	{ "i" },
	"<C-f>",
	"<Esc>0i",
	{ silent = true, desc = "Move to the first char of the line (space included)" }
)
vim.keymap.set({ "i" }, "<C-a>", "<Esc>^i", { silent = true, desc = "Move to the first char of the line" })

vim.keymap.set(
	{ "n", "v" },
	"<C-g>",
	"$",
	{ silent = true, desc = "Move to the last char of the line (space included)" }
)
vim.keymap.set({ "n", "v" }, "<C-d>", "g_", { silent = true, desc = "Move to the last char of the line" })
vim.keymap.set(
	{ "n", "v" },
	"<C-f>",
	"0",
	{ silent = true, desc = "Move to the first char of the line (space included)" }
)
vim.keymap.set({ "n", "v" }, "<C-a>", "^", { silent = true, desc = "Move to the first char of the line" })

-- Menu
vim.keymap.set("n", "<C-m>", function()
	local filetype = vim.bo.filetype
	local options = filetype == "neo-tree" and "neo-tree" or "default"

	require("menu").open(options, { border = true })
end, { silent = true, desc = "Open menu with keybinding" })

vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
	require("menu.utils").delete_old_menus()

	vim.cmd.exec('"normal! \\<RightMouse>"')

	local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
	local options = vim.bo[buf].ft == "neo-tree" and "neo-tree" or "default"

	require("menu").open(options, { mouse = true, border = true })
end, { silent = true, desc = "Open menu with right click" })

-- Tmux keymaps
vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true, desc = "Go to the left window" })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { silent = true, desc = "Go to the bottom window" })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { silent = true, desc = "Go to the top window" })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { silent = true, desc = "Go to the right window" })
