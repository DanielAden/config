vim.cmd([[
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
]])

if vim.g.vscode then
  require("vscode_setup")
else
  vim.g.auto_format_enabled = true
  vim.g.inlay_hints_enabled = true

  -- require('firenvim')

  require 'lazy-bootstrap'

  require("lazy").setup("plugins")

  require 'options'

  require 'keymaps'

  require 'nvim-tree-config'

  require 'which-key-setup'

  require 'bufferline-config'

  require 'telescope-setup'

  require 'treesitter-setup'

  require 'vim-test-setup'

  require 'cmp-setup'

  require 'lsp-setup'

  require 'null_ls'

  require 'scratch'
end



-- TODO LIST
-- * look into retaining file history after close
--
