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
          ruby = { "rubocop" },
          javascript = { "prettier" },
          php = { "pint" },
          xml = { "xmllint" },
          yaml = { "prettier" },
          blade = { "prettier", "pint" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          cs = { "clang-format" },
          python = { "black" },
          rust = { "rustfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
        notify_on_error = true,

        vim.keymap.set("n", "<leader>fm", function()
          require("conform").format()
        end, { silent = true, desc = "Format current document" }),
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "eslint",
          "cssls",
          "emmet_language_server",
          "tailwindcss",
          "pylsp",
          "rust_analyzer",
          "html",
          "lemminx",
          "gopls",
          "ts_ls",
          "phpactor",
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
      vim.lsp.enable("ols")
      vim.lsp.enable("lemminx")
      vim.lsp.enable("eslint")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("cssls")
      vim.lsp.config["emmet_language_server"] = {
        filetypes = { "html", "css", "php", "blade", "jsx", "javascript", "typescript" },
        init_options = {
          html = {
            options = {
              ["bem.enabled"] = true,
            },
          },
        },
      }

      vim.lsp.enable("emmet_language_server")
      vim.lsp.config["html"] = {
        filetypes = { "html", "php", "blade", "htm" },
        init_options = {
          configurationSection = { "html", "css", "typescript", "javascript", "tsx" },
          embeddedLanguages = {
            css = true,
            javascript = true,
          },
          provideFormatter = true,
        },
      }
      vim.lsp.enable("html")
      vim.lsp.config["phpactor"] = {
        root_dir = vim.fs.root(0, { "composer.json", ".git" }) or vim.fn.getcwd(),
      }
      vim.lsp.enable("phpactor")
      vim.lsp.enable("clangd")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("pylsp")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.config["qmlls6"] = {
        cmd = { "qmlls6" },
        filetypes = { "qml" },
      }
      vim.lsp.config["ruby_lsp"] = {
        cmd = { "/home/wetar/.local/share/gem/ruby/3.4.0/bin/ruby-lsp" },
      }
      vim.lsp.enable("ruby_lsp")
      vim.lsp.enable("qmlls6")
      vim.lsp.enable("gopls")
      vim.lsp.enable("tailwindcss")
      vim.keymap.set(
        { "n", "v" },
        "<leader>ca",
        vim.lsp.buf.code_action,
        { silent = true, desc = "Show code action from configured LSP" }
      )
    end,
  },
}
