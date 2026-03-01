vim.o.textwidth = 0

vim.keymap.set("n", "<leader>j", "<Cmd>%!jq -c . <CR>", { desc = "Format Python to JSON" })
