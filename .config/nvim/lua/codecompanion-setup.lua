vim.keymap.set({ "n", "v" }, "<leader>ac", ":CodeCompanionChat Toggle<CR>", { desc = "Code Companion Chat Toggle" })

vim.keymap.set(
	{ "n", "v" },
	"<leader>aa",
	":CodeCompanionActions<CR>",
	{ noremap = true, silent = true, desc = "Code Companion Actions" }
)

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ccc CodeCompanionChat]])
