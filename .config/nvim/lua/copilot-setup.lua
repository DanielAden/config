-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

-- vim.keymap.set('i', '<C-Y>', 'copilot#Accept("\\<CR>")', {
--   expr = true,
--   replace_keycodes = false
-- })
-- vim.g.copilot_no_tab_map = true

vim.keymap.set({ "n", "v" }, "<leader><leader>cc", ":CopilotChatToggle<CR>", { desc = "[C]opilot [C]hat Toggle" })
vim.keymap.set({ "n", "v" }, "<leader><leader>cx", ":CopilotChatClose<CR>", { desc = "[C]opilot [C]hat Toggle" })
vim.keymap.set({ "n", "v" }, "<leader><leader>cr", ":CopilotChatReset<CR>", { desc = "[C]opilot Chat [R]eset" })

vim.keymap.set({ "n", "v" }, "<leader><leader>ct", ":CopilotChatTests<CR>", { desc = "[C]opilot Chat [T]ests" })
vim.keymap.set({ "n", "v" }, "<leader><leader>cf", ":CopilotChatFix<CR>", { desc = "[C]opilot Chat [F]ix" })
vim.keymap.set({ "n", "v" }, "<leader><leader>cd", ":CopilotChatDocs<CR>", { desc = "[C]opilot Chat [D]ocs" })
vim.keymap.set({ "n", "v" }, "<leader><leader>co", ":CopilotChatOptimize<CR>", { desc = "[C]opilot Chat [O]ptimize" })
