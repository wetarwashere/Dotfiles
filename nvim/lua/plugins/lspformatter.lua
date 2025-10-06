return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "single",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					html = { "prettier" },
					css = { "prettier" },
					javascript = { "prettier" },
					php = { "php-cs-fixer" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					cs = { "clang-format" },
					python = { "black" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters = {
					["php-cs-fixer"] = {
						command = "php-cs-fixer",
						args = {
							"fix",
							"--rules=@PSR12",
							"$FILENAME",
						},
						stdin = false,
					},
				},
				notify_on_error = true,

				vim.keymap.set("n", "<leader>fm", function()
					require("conform").format()
				end, { silent = true, desc = "Format current document" }),
			})
		end,
	},
	{
		"zapling/mason-conform.nvim",
		config = function()
			require("mason-conform").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"cssls",
					"phpactor",
					"clangd",
					"emmet_language_server",
					"pyright",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("cssls")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("html")
			vim.lsp.enable("phpactor")
			vim.lsp.enable("clangd")
			vim.lsp.enable("pyright")

			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				vim.lsp.buf.code_action,
				{ silent = true, desc = "Show code action from configured LSP" }
			)
		end,
	},
}
