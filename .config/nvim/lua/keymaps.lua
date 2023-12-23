-- Highlighted searches centers to middle of the page
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "gy", "yiw")
vim.keymap.set("n", "gY", "yiW")

vim.keymap.set('n', '<leader>bc', ":bd<CR>", { desc = 'Close Buffer' })
vim.keymap.set('n', '<leader>bx', ":close<CR>", { desc = 'Close Buffer' })


-- Tabs
vim.keymap.set('n', '<leader>tn', ":tabnext<CR>", { desc = 'Tab Next' })
vim.keymap.set('n', '<leader>tp', ":tabprev<CR>", { desc = 'Tab Prev' })
vim.keymap.set('n', '<leader>ta', ":tabnew<CR>", { desc = 'Tab Add' })

-- Git
vim.keymap.set('n', '<leader>gl', "<cmd>lua require 'gitsigns'.blame_line()<cr>", { desc = 'Tab Add' })

vim.keymap.set('n', '<leader>tn', ":tabnext<CR>", { desc = 'Tab Next' })
vim.keymap.set('n', '<leader>tp', ":tabprev<CR>", { desc = 'Tab Prev' })
vim.keymap.set('n', '<leader>ta', ":tabnew<CR>", { desc = 'Tab Add' })

-- ADO
local utils = require('utils')
vim.keymap.set('n', '<leader>ob', utils.openFileInADO, { desc = 'Open File and Branch in ADO' })
vim.keymap.set('n', '<leader>of', function() utils.openFileInADO('feature-int') end, { desc = 'Open Dev Branch in ADO' })
vim.keymap.set('n', '<leader>od', function() utils.openFileInADO('develop') end, { desc = 'Open Test Branch in ADO' })
