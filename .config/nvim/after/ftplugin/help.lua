-- Disables treesitter for help/vimdoc files.  Was getting a strange issue where tags 
-- were hidden in normal mode, but not in insert mode. This disables treesitter for 
-- the filetype, which defaults highlighting back to regex based highlighting.
vim.treesitter.stop(0)
