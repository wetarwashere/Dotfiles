return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			window = {
				popup = {
					position = { col = "100%", row = "2" },
					size = function(state)
						local root_name = vim.fn.fnamemodify(state.path, ":~")
						local root_len = string.len(root_name) + 4
						return {
							width = math.max(root_len, 50),
							height = vim.o.lines - 6,
						}
					end,
				},
			},
			event_handlers = {
				{
					event = "file_open_requested",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.cmd("highlight! CursorLine guibg=#151515")
					end,
				},
				{
					event = "neo_tree_buffer_leave",
					handler = function()
						vim.cmd("highlight! Cursor guibg=#080808")
					end,
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},
		})
		vim.keymap.set(
			"n",
			"<C-e>",
			"<Esc>:Neotree float filesystem toggle<CR>",
			{ silent = true, desc = "Toggle file explorer" }
		)
	end,
}
