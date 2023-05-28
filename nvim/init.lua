vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"goolord/alpha-nvim",
	"MunifTanjim/nui.nvim",
})

require("scratch.alpha").commands()

vim.keymap.set("n", "<leader><UP>", ":CommandUp <cr>")
vim.keymap.set("n", "<leader>h", vim.cmd.CommandHome)
vim.keymap.set("n", "<leader><Down>", ":CommandDown<cr>")
vim.keymap.set("n", "<leader><Left>", ":CommandLeft<cr>")
vim.keymap.set("n", "<leader><Right>", ":CommandRight<cr>")
vim.cmd.CommandHome()
