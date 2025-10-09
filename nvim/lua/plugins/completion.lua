return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {
			debug = true,
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"moyiz/blink-emoji.nvim",
			"ray-x/cmp-sql",
		},

		version = "1.*",

		completion = {
			ghost_text = { enabled = true },
		},

		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<C-t>"] = { "show", "fallback" },
				["<C-w>"] = { "show_documentation", "hide_documentation", "fallback" },
				["<C-h>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = {
					function(cmp)
						return cmp.select_next()
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						return cmp.select_prev()
					end,
					"snippet_backward",
					"fallback",
				},
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-up>"] = { "scroll_documentation_up", "fallback" },
				["<C-down>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				nerd_font_variant = "bold",
			},

			completion = {
				list = {
					selection = {
						auto_insert = false,
					},
				},
				menu = {
					border = "single",
					scrollbar = false,
					winblend = 1,
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					window = {
						border = "single",
						scrollbar = false,
						winblend = 1,
					},
					auto_show = true,
				},
			},

			cmdline = {
				keymap = {
					["<C-t>"] = { "show", "fallback" },
					["<Tab>"] = {
						function(cmp)
							return cmp.select_next()
						end,
						"snippet_forward",
						"fallback",
					},
					["<S-Tab>"] = {
						function(cmp)
							return cmp.select_next()
						end,
						"snippet_backward",
						"fallback",
					},
					["<C-h>"] = { "hide", "fallback" },
					["<C-d>"] = { "show_documentation", "hide_documentation", "fallback" },
					["<CR>"] = { "accept", "fallback" },
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<C-up>"] = { "scroll_documentation_up", "fallback" },
					["<C-down>"] = { "scroll_documentation_down", "fallback" },
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
				providers = {
					emoji = {
						module = "blink-emoji",
						name = "emoji",
						score_offset = 15,
						opts = { insert = true },
					},
					sql = {
						name = "sql",
						module = "blink.compat.source",
						score_offset = -3,
						opts = {},
						should_show_items = function()
							return vim.tbl_contains({ "sql" }, vim.o.filetype)
						end,
					},
				},
			},

			signature = {
				enabled = true,
				window = {
					border = "single",
					scrollbar = false,
					winblend = 1,
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
