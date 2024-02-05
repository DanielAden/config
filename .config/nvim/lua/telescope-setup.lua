-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")
local putils = require("telescope.previewers.utils")
require('telescope').setup {
  defaults = {
    wrap_results = true,
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",
      width = 0.95,
      height = 0.90,
      preview_width = 0.5,
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    preview = {
      filetype_hook = function(filepath, bufnr, opts)
        -- you could analogously check opts.ft for filetypes
        local excluded = vim.tbl_filter(function(ending)
          return filepath:match(ending)
        end, {
          ".*%.svg",
        })
        if not vim.tbl_isempty(excluded) then
          putils.set_preview_message(
            bufnr,
            opts.winid,
            string.format("Preview disabled for %s files",
              excluded[1]:sub(5, -1))
          )
          return false
        end
        return true
      end,

    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

require("telescope").load_extension("scope")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = '[S]earch [G]it Files' })

vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>st', require('telescope.builtin').live_grep, { desc = '[S]earch by [T]ext' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })

vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sr', function()
  require('telescope.builtin').oldfiles {
    cwd = true
  }
end, { desc = '[S]earch [R]ecent' })

vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sl', require('telescope.builtin').resume, { desc = '[S]earch [L]ast' })
local function telescope_live_grep_ignore_test_files()
  require('telescope.builtin').live_grep {
    prompt_title = "Find Text (Ignoring Test Files)",
    glob_pattern = { "!**/acceptance/**", "!**/__test__/**", "!*.test.*", "!**/mocks/**", "!package-lock.json" },
    -- glob_pattern = { "!**/{acceptance,__test__}/*" },
  }
end
vim.keymap.set('n', '<leader>si', telescope_live_grep_ignore_test_files, { desc = "Search Files (Ignoring Test Files)" })
vim.keymap.set('n', '<leader>so', require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = "[S]earch [O]pen Buffer" })

local function telescope_live_search_config_files()
  local config_root = vim.fn.stdpath("config")
  require('telescope.builtin').find_files {
    prompt_title = "Search Config Files",
    search_dirs = { config_root },
  }
end
vim.keymap.set('n', '<leader>sc', telescope_live_search_config_files, { desc = "Search Config Files" })

local function telescope_live_grep_config_files()
  local config_root = vim.fn.stdpath("config")
  require('telescope.builtin').live_grep {
    prompt_title = "Grep Config Files",
    search_dirs = { config_root },
    glob_pattern = "!lazy-lock.json"
  }
end
vim.keymap.set('n', '<leader>sC', telescope_live_grep_config_files, { desc = "Grep Config Files" })

-- vim.lsp.handlers["textDocument/references"] = require("telescope/builtin").lsp_references

vim.api.nvim_create_user_command("SF", function(t)
  local filetype = t.args;
  require('telescope.builtin').live_grep({
    type_filter = filetype
  })
end, { nargs = 1, desc = "Search by Filetype" })

-- vim: ts=2 sts=2 sw=2 et
