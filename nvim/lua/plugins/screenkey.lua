return {
	"NStefan002/screenkey.nvim",
	lazy = false,
	version = "*",
	config = function()
		require("screenkey").setup({
			win_opts = {
				title = { { "Wetar", "ScreenkeyTitle" } },
			},
		})
		vim.keymap.set("n", "<leader>sr", "<CMD>Screenkey toggle<CR>", { silent = true, desc = "Toggle screenkey" })
	end,
}
