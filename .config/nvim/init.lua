vim.cmd([[
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
]])

vim.g.which_comp = os.getenv("WHICH_COMP")
vim.g.servicebus_config_location = os.getenv("SERVICEBUS_CONFIG_LOCATION")

require("lazy-bootstrap")

require("lazy").setup({
	{
		import = "plugins",
		cond = function()
			return not vim.g.vscode
		end,
	},
	-- { import = "user.plugins_always",    cond = true },
	{
		import = "vscode_plugins",
		cond = function()
			return vim.g.vscode
		end,
	},
})

if vim.g.vscode then
	require("vscode_setup")
else
	vim.g.auto_format_enabled = true
	-- vim.g.inlay_hints_enabled = false

	-- require('firenvim')
	--
	require("ui")

	require("options")

	require("keymaps")

	require("nvim-tree-config")

	require("which-key-setup")

	require("bufferline-config")

	require("treesitter-setup")

	require("vim-test-setup")

	require("cmp-setup")

	require("scratch")

	require("servicebus")

	require("codecompanion-setup")
end
