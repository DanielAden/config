-- Settings for when neovim is running inside of vscode
--

-- Config
vim.o.ignorecase = true
vim.o.smartcase = true

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", {}),
	callback = function()
		vim.highlight.on_yank({ higroup = "Search" })
	end,
	pattern = "*",
})

-- Keymaps to call VSCode commands

vim.keymap.set("n", "H", "<Cmd>lua require('vscode-neovim').call('workbench.action.previousEditor')<CR>", { desc = "" })
vim.keymap.set("n", "L", "<Cmd>lua require('vscode-neovim').call('workbench.action.nextEditor')<CR>", { desc = "" })
vim.keymap.set(
	"n",
	"<leader>q",
	"<Cmd>lua require('vscode-neovim').call('workbench.action.closeActiveEditor')<CR>",
	{ desc = "" }
)

-- <Cmd>lua require('vscode-neovim').call('editor.action.formatSelection')<CR>
vim.keymap.set(
	"n",
	"<leader>w",
	"<Cmd>lua require('vscode-neovim').call('workbench.action.files.save')<CR>",
	{ desc = "" }
)

vim.keymap.set(
	"n",
	"rw",
	"<Cmd>lua require('vscode-neovim').call('databricks.run.runEditorContentsAsWorkflow')<CR>",
	{ desc = "" }
)
vim.keymap.set(
	"n",
	"rf",
	"<Cmd>lua require('vscode-neovim').call('databricks.run.runEditorContents')<CR>",
	{ desc = "" }
)

vim.keymap.set(
	"n",
	"<leader>e",
	"<Cmd>lua require('vscode-neovim').call('workbench.action.toggleSidebarVisibility')<CR>",
	{ desc = "" }
)
vim.keymap.set(
	"n",
	"<leader>gc",
	"<Cmd>lua require('vscode-neovim').call('workbench.panel.chat.view.copilot.focus')<CR>",
	{ desc = "" }
)

vim.keymap.set("n", "gD", ":call VSCodeNotify('editor.action.goToTypeDefinition')<cr>")
vim.keymap.set("n", "gr", ":call VSCodeNotify('references-view.findReferences')<cr>")
