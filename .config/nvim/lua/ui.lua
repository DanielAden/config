local utils = require("utils")

-- Color paren matches bright red
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.cmd([[hi MatchParen cterm=bold gui=bold guifg=none guibg=red]])
		vim.cmd([[hi clear CursorLine]])
		vim.cmd([[hi CursorLine gui=underline cterm=underline]])
	end,
})

local colorschemes = {
	"terafox",
	-- "rose-pine",
	-- "rose-pine-moon",
	"nightfox",
	"duskfox",
	-- "retrobox",
	-- "onenord",
}

vim.cmd.colorscheme(colorschemes[utils.getRandomNumers(1, #colorschemes)])
-- vim.cmd.colorscheme("terafox")
-- vim.cmd.colorscheme("rose-pine")
--
-- vim.g.gruvbox_material_background = "hard"
-- vim.cmd.colorscheme("gruvbox-material")

local _border = "single"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = _border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = _border,
})

-- vim.cmd [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>]]
-- vim.cmd [[nnoremap <buffer><silent> ]g :lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>]]
-- vim.cmd [[nnoremap <buffer><silent> [g :lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>]]
-- vim.cmd [[highlight FloatBorder  ctermfg=NONE ctermbg=NONE cterm=NONE]]

require("lspconfig.ui.windows").default_options = {
	border = _border,
}

local icons = require("icons")
local default_diagnostic_config = {
	signs = {
		active = true,
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
		},
	},
	virtual_text = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}
vim.diagnostic.config(default_diagnostic_config)

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.o.signcolumn = "yes"
