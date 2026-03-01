-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
-- set foldlevel=99

vim.opt.foldmethod = "indent"
-- Defaults folds to be open
vim.opt.foldlevel = 99

vim.keymap.set("n", "<leader>m", "<Cmd>%!jq -c . <CR>", { desc = "Minify JSON" })

vim.keymap.set("n", "<leader>j", function()
	vim.cmd("%s/'/\"/g")
	vim.cmd("%s/None/null/g")
	vim.cmd("%s/True/true/g")
	vim.cmd("%s/False/false/g")
end, { desc = "Format Python Dict to JSON" })
