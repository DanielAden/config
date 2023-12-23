-- vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=none]]
-- vim.cmd [[autocmd ColorScheme * highlight FloatBorder guibg=none]]
--
-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--   opts = opts or {}
--   opts.border = opts.border or border
--   return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.cmd([[hi MatchParen cterm=bold gui=bold guifg=none guibg=red]])
    vim.cmd([[hi clear CursorLine]])
    vim.cmd([[hi CursorLine gui=underline cterm=underline]])
  end,
})


vim.cmd.colorscheme('terafox')

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.o.signcolumn = 'yes'
