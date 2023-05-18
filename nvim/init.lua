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

require("lazy").setup({ "goolord/alpha-nvim" })

require("scratch.alpha").commands()

vim.keymap.set("n", "<UP>", ":CommandUp <cr>")
vim.keymap.set("n", "<Down>", ":CommandDown<cr>")
vim.keymap.set("n", "<Left>", ":CommandLeft<cr>")
vim.keymap.set("n", "<Right>", ":CommandRight<cr>")
vim.cmd.CommandHome()
