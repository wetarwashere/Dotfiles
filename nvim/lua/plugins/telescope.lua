return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fs", builtin.find_files, { silent = true, desc = "Find files on cwd" })
			vim.keymap.set("n", "<leader>lg", builtin.live_grep, { silent = true, desc = "Live grep a word or text" })
			vim.keymap.set("n", "<leader>km", builtin.keymaps, { silent = true, desc = "Show keymaps" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "   ",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							width = 0.8,
							preview_width = 0.4,
						},
					},
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
