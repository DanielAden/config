-- Highlighted searches centers to middle of the page
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "gy", "yiw")
vim.keymap.set("n", "gY", "yiW")

vim.keymap.set('n', '<leader>kw', ":close<CR>", { desc = '[k]ill [w]indow' })
vim.keymap.set('n', '<leader>kt', ":tabclose<CR>", { desc = '[k]ill [t]ab' })
-- using this instead of :bd<CR> to not affect current window/tab
-- https://stackoverflow.com/a/63201958
vim.keymap.set('n', '<leader>kc', ":bp|bd#<CR>", { desc = '[k]ill [c]urrent buffer' })


-- Tabs
vim.keymap.set('n', '<leader>tn', ":tabnext<CR>", { desc = 'Tab Next' })
vim.keymap.set('n', '<leader>tp', ":tabprev<CR>", { desc = 'Tab Prev' })
vim.keymap.set('n', '<leader>ta', ":tabnew<CR>", { desc = 'Tab Add' })

-- Git
vim.keymap.set('n', '<leader>gl', "<cmd>lua require 'gitsigns'.blame_line()<cr>", { desc = 'Git Blame Line' })
vim.keymap.set('n', '<leader>di', ":DiffviewOpen<CR>", { desc = '[D]iffview [I]ndex' })
vim.keymap.set('n', '<leader>df', ":DiffviewFileHistory %<CR>", { desc = '[D]iffview [F]ile History' })
vim.keymap.set('n', '<leader>db', ":DiffviewFileHistory<CR>", { desc = '[D]iffview [F]ile History' })

-- ADO
local utils = require('utils')
vim.keymap.set('n', '<leader>ob', utils.openFileInADO, { desc = 'Open File and Branch in ADO' })
vim.keymap.set('n', '<leader>of', function() utils.openFileInADO('feature-int') end, { desc = 'Open Dev Branch in ADO' })
vim.keymap.set('n', '<leader>od', function() utils.openFileInADO('develop') end, { desc = 'Open Test Branch in ADO' })

-- code
vim.keymap.set('n', '<leader>co', ':OrganizeImports<CR>', { desc = '[O]rganize Imports' })
vim.keymap.set('n', '<leader>ca', ':AutoformatToggle<CR>', { desc = '[A]utoformat Toggle' })
vim.keymap.set('n', '<leader>cj', '<cmd>!cjson %:p<CR>', { desc = 'Format nested json'})
vim.keymap.set('n', '<leader>cm', [[<cmd>%s/\r/\r/g<CR>]], { desc = 'Convert ^M Carriage Returns to Normal Returns'})
