
vim.g['go_addtags_transform'] = 'camelcase'

vim.keymap.set('n', '<leader>ct', function()
  vim.cmd("GoAddTags json") 
end, { desc = 'JSON Tags' })
