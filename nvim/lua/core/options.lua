vim.g.mapleader = " "
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.scrolloff = 4
vim.wo.relativenumber = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove("t")
vim.opt.linebreak = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.fillchars = { eob = " " }
