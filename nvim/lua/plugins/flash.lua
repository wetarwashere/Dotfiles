return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
  -- stylua: ignore
    keys = {
        { "s", mode = { "n", "x", "o" },
            function()
                vim.go.ignorecase = true
                vim.go.smartcase = false
                require("flash").jump()
            end },
        { "S", mode = { "n", "x", "o" },
            function()
                vim.go.ignorecase = true
                vim.go.smartcase = false
                require("flash").treesitter()
            end },
        { "r", mode = "o",
            function()
                vim.go.ignorecase = true
                vim.go.smartcase = false
                require("flash").remote()
            end },
        { "R", mode = { "o", "x" },
            function()
                vim.go.ignorecase = true
                vim.go.smartcase = false
                require("flash").treesitter_search()
            end },
        { "<C-s>", mode = { "c" },
            function()
                vim.go.ignorecase = true
                vim.go.smartcase = false
                require("flash").toggle()
            end },
    },
}
