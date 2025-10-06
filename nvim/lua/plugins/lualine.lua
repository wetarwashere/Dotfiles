return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							if str == "NORMAL" then
								return " NORMAL"
							elseif str == "INSERT" then
								return " INSERT"
							elseif str == "VISUAL" then
								return " VISUAL"
							elseif str == "REPLACE" then
								return "󰬲 REPLACE"
							elseif str:find("PENDING") then
								return " PENDING"
							elseif str:find("BLOCK") then
								return " BLOCK"
							else
								return str
							end
						end,
					},
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "warn", "error", "info", "hint" },
						diagnostics_color = {
							error = { fg = "#ff2b66" },
							warn = { fg = "#ccff14" },
							hint = { fg = "#ffffff" },
							info = { fg = "#ff7214" },
						},
						symbols = {
							error = " ",
							warn = " ",
							info = "󰋼 ",
							hint = "󰯪 ",
						},
					},
				},
				lualine_b = {
					{
						function()
							local ft = vim.bo.filetype
							local filename = vim.fn.expand("%:t")
							local icon = require("nvim-web-devicons").get_icon(ft)
							local status = ""

							if vim.bo.modified then
								status = status .. " [+]"
							elseif vim.bo.readonly then
								status = status .. " [!]"
							end

							if filename == "" then
								return " File" .. status
							end

							if icon then
								return icon .. " " .. filename .. status
							else
								return " " .. filename .. status
							end
						end,
					},
				},
				lualine_x = {
					function()
						return " Linux"
					end,
				},
				lualine_z = {
					{
						function()
							return vim.fn.line(".") .. ":" .. vim.fn.col(".") .. " "
						end,
					},
				},
			},
			options = {
				icons_enabled = true,
				theme = "wetar",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "neo-tree", "alpha" },
				ignore_focus = { "neo-tree", "alpha" },
				always_divide_middle = true,
			},
		})
	end,
}
