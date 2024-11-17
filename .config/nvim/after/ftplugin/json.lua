-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
-- set foldlevel=99

vim.opt.foldmethod = "indent"
-- Defaults folds to be open
vim.opt.foldlevel = 99

vim.keymap.set("n", "<leader>m", "<Cmd>%!jq -c . <CR>", { desc = "Minify JSON" })
