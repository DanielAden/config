vim.api.nvim_create_user_command("ClearTestBuffers", function()
  local buffers = vim.api.nvim_list_bufs()
  for index, value in ipairs(buffers) do
    local name = vim.api.nvim_buf_get_name(value)
    local hasTestCommand = string.find(name, "react%-scripts") or string.find(name, "go test") or
        string.find(name, "jest")
    local isTestBuffer = string.find(name, "term://") and hasTestCommand
    if isTestBuffer then
      vim.cmd(string.format("bw! %s", value))
    end
  end
end, { nargs = 0 })

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vert botright 120"
vim.g["test#preserve_screen"] = 0
vim.g["test#javascript#jest#options"] = "--watchAll=false"
vim.g["test#javascript#reactscripts#options"] = "--watchAll=false --env=jsdom"
vim.g["test#neovim#start_normal"] = 1
-- vim.g["test#enabled_runners"] = ["javascript#jest"];


vim.keymap.set('n', '<leader>uc', function()
  vim.cmd("ClearTestBuffers") -- Wipes any previous test buffers
end, { desc = 'Clear Test Buffers' })

vim.keymap.set('n', '<leader>ut', function()
  vim.cmd("ClearTestBuffers")                           -- Wipes any previous test buffers
  vim.cmd("TestNearest")
  vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } }) -- puts cursor in previous position
end, { desc = 'Test Nearest' })

vim.keymap.set('n', '<leader>uT', function()
  vim.cmd("ClearTestBuffers")
  vim.cmd("TestFile")
  vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } })
end, { desc = 'Test File' })

vim.keymap.set('n', '<leader>ua', function()
  vim.cmd("ClearTestBuffers")
  vim.cmd("TestSuite")
  vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } })
end, { desc = 'Test Suite' })

vim.keymap.set('n', '<leader>ul', function()
  vim.cmd("ClearTestBuffers")
  vim.cmd("TestLast")
  vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } })
end, { desc = 'Test Last' })

vim.keymap.set('n', '<leader>ug', ':TestVisit<cr>', { desc = 'Navigates to last visited test file' })
