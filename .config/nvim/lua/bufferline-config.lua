require("bufferline").setup {
  options = {
    custom_filter = function(buf_number, buf_numbers)
      -- filter out filetypes you don't want to see
      -- if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
      --     return true
      -- end
      local bufName = vim.fn.bufname(buf_number)
      local isTerminalBuffer = string.find(bufName, "term://")
      -- filter out by buffer name
      if isTerminalBuffer then
        return false
      end
      -- filter out based on arbitrary rules
      -- e.g. filter out vim wiki buffer from tabline in your work repo
      -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
      --   return true
      -- end
      -- -- filter out by it's index number in list (don't show first buffer)
      -- if buf_numbers[1] ~= buf_number then
      --   return true
      -- end
      return true
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      },
    },
  },
}

vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")

vim.keymap.set('n', '<leader>bj', ":BufferLinePick<CR>", { desc = 'Buffer Jump' })
vim.keymap.set('n', '<leader>bp', ":BufferLineTogglePin<CR>", { desc = 'Pin Buffer' })
vim.keymap.set('n', '<leader>kl', ":BufferLineCloseRight<CR>", { desc = '[K]ill Buffers Right' })
vim.keymap.set('n', '<leader>kh', ":BufferLineCloseLeft<CR>", { desc = '[K]ill Buffers Left' })
vim.keymap.set('n', '<leader>ko', ":BufferLineCloseOthers<CR>", { desc = '[K]ill [O]ther' })
