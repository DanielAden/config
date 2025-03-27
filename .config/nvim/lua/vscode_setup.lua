-- Settings for when neovim is running inside of vscode

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
