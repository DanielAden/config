--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]

--[[
 Useful Commmands:
 lua vim.print(vim.api.nvim_list_runtime_paths())
]]

-- If require can't find work-config pcall will catch the error and ignore it.
-- Used to load optional work specific config
pcall(require, "user.work-config")
pcall(require, "user.personal-config")

local SESSION_DIR = "~/.vimsessions"

lvim.colorscheme = "terafox"
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.cmd([[hi MatchParen cterm=bold gui=bold guifg=none guibg=red]])
  end,
})

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.list = true
vim.opt.listchars:append("trail:·")
vim.opt.autoread = true

lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua,*.ts,*.tsx,*.go",
  timeout = 2000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- Half page navigation automatically centers to middle of the page
lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"
lvim.keys.normal_mode["<C-u>"] = "<C-u>zz"

-- Highlighted searches centers to middle of the page
lvim.keys.normal_mode["n"] = "nzzzv"
lvim.keys.normal_mode["N"] = "Nzzzv"

-- paste over selected text while preserving yanked text
vim.keymap.set("x", "<Leader>p", '"_dP')

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- Move one or more lines up/down with indentation in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

require("lspconfig").tsserver.setup({
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
  },
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
      importModuleSpecifierEnding = "minimal",
    },
  },
})

require("lspconfig").gopls.setup({
  settings = {
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})

-- -- Disable lvim custom finder for <leader>f
lvim.builtin.which_key.mappings["f"] = {
  require("lvim.core.telescope.custom-finders").find_project_files,
  "Find File",
}

-- Reloads buffer
lvim.builtin.which_key.mappings["r"] = {
  ":checktime<CR>",
  "reload buffer",
}

lvim.builtin.which_key.mappings["x"] = {
  name = "Close",
  b = { ":bd<CR>", "Buffer" },
  w = { ":close<CR>", "Window" },
  a = { ":qa<CR>", "all" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = [[Diagnostics/Tabs]],
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
  n = { "<cmd>tabnext<cr>", "tab next" },
  p = { "<cmd>tabprev<cr>", "tab prev" },
  a = { "<cmd>tabnew<cr>", "add tab" },
}

lvim.builtin.which_key.mappings["b"]["f"] = { "<cmd>Telescope scope buffers<cr>", "Find Scoped Buffer" }

lvim.builtin.which_key.mappings["j"] = {
  name = "Terminal/JSON",
  j = { "<cmd>ToggleTerm<cr>", "Open Terminal" },
  -- Don't love this but hack to get work specific custom JSON formatter running somwhere in the keymaps
  -- Eventually need to move to work config
  f = { "<cmd>!cjson %:p<cr>", "Format JSON File" }
}

local builtin = require("telescope.builtin")
lvim.builtin.which_key.mappings["s"] = vim.tbl_extend("keep", lvim.builtin.which_key.mappings["s"], {
  w = {
    builtin.grep_string,
    "search word under cursor",
  },
  i = {
    function()
      builtin.live_grep({
        prompt_title = "Find Text (Ignoring Test Files)",
        glob_pattern = { "!**/acceptance/**", "!**/__test__/**", "!*.test.*" },
      })
    end,
    "Find Text (Ignore Test Files)",
  },
  x = {
    builtin.treesitter,
    "Search Code (Treesitter)",
  },
  o = {
    builtin.current_buffer_fuzzy_find,
    "Search Open Buffer",
  },
})

lvim.builtin.which_key.mappings["b"] = vim.tbl_extend("keep", lvim.builtin.which_key.mappings["b"], {
  o = { "<cmd>OrganizeImports<cr>", "Organize Imports" },
})

-- vim-test
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
lvim.builtin.which_key.mappings["u"] = {
  name = "Unit Tests",
  c = {
    function()
      vim.cmd("ClearTestBuffers") -- Wipes any previous test buffers
    end,
    "Clear Test Buffers",
  },
  t = {
    function()
      vim.cmd("ClearTestBuffers")                           -- Wipes any previous test buffers
      vim.cmd("TestNearest")
      vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } }) -- puts cursor in previous position
    end,
    "Test Nearest",
  },
  T = {
    function()
      vim.cmd("ClearTestBuffers")
      vim.cmd("TestFile")
      vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } })
    end,
    "Test File",
  },
  a = {
    function()
      vim.cmd("ClearTestBuffers")
      vim.cmd("TestSuite")
      vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } })
    end,
    "Test Suite",
  },
  l = {
    function()
      vim.cmd("ClearTestBuffers")
      vim.cmd("TestLast")
      vim.cmd.exe({ args = { '"normal \\<C-w>\\<C-p>"' } })
    end,
    "Run Last Test",
  },
  g = { "<cmd>TestVisit<cr>", "Navigates to last visited test file" },
}

-- function! VagrantTransform(cmd) abort
--   let vagrant_project = get(matchlist(s:cat('Vagrantfile'), '\vconfig\.vm.synced_folder ["''].+[''"], ["''](.+)[''"]'), 1)
--   return 'vagrant ssh --command '.shellescape('cd '.vagrant_project.'; '.a:cmd)
-- endfunction

-- vim.g["test#custom_transformations"] = {'vagrant': function('VagrantTransform')}
-- let g:test#transformation = 'vagrant'

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- vim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pylyzer" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
--
local actions = require("telescope.actions")
local putils = require("telescope.previewers.utils")
lvim.builtin.telescope.defaults = {
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
}

vim.lsp.handlers["textDocument/references"] = require("telescope/builtin").lsp_references

-- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  -- { command = "stylua" },
  -- {
  --   command = "prettier",
  --   -- extra_args = { "--print-width", "100" },
  --   filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  -- },
  -- {
  --   command = "eslint_d"
  -- },
  {
    command = "prettierd",
  },
  -- {
  --   { exe = "jq", args = { "--indent", "2" }, filetypes = { "json" } },
  -- }
  {
    command = "gofumpt",
  },
  {
    command = "golines",
  },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  -- { command = "flake8", filetypes = { "python" } },
  -- {
  --   command = "shellcheck",
  --   args = { "--severity", "warning" },
  -- },
  {
    command = "eslint_d",
  },
  { command = "golangci-lint" },
})

local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
  {
    exe = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
})

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  {
    "vim-test/vim-test",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "tpope/vim-repeat" },
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  {
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
  },
  {
    "ray-x/lsp_signature.nvim",
  },
  { "nvim-treesitter/playground" },
  { "norcalli/nvim-colorizer.lua" },
  { "EdenEast/nightfox.nvim" },
  { "tiagovla/scope.nvim" },
  { "windwp/nvim-ts-autotag" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "fatih/vim-go" },
  { "ggandor/leap-spooky.nvim" },
  { "christoomey/vim-tmux-navigator" }
}

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
--
--

-- require("dap-vscode-js").setup({
--   -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--   debugger_path = "/Users/dat3631/source/vscode-js-debug",                                     -- Path to vscode-js-debug installation.
--   -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
--   -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
--   -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
--   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- })
--

local masonPackages = vim.fn.stdpath("data") .. "/mason/packages/"
local dap = require("dap")
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { masonPackages .. "node-debug2-adapter/out/src/nodeDebug.js" },
}

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    {
      name = "Attach",
      type = "node2",
      request = "attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      name = "Launch App.ts",
      type = "node2",
      request = "launch",
      cwd = "${workspaceFolder}",
      args = { "-r", "ts-node/register/transpile-only", "./src/App.ts" },
    },
    {
      name = "Launch File",
      type = "node2",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
end

local cfg = {} -- add your config here
require("lsp_signature").setup(cfg)

-- Markdown Settings
vim.g.markdown_folding = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.wrap = true
    vim.opt.linebreak = true
  end,
})

require("colorizer").setup()
local trim = function(s)
  return string.gsub(s, "[\r\n]", "")
end

local split = function(str, pat)
  local t = {} -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t, cap)
    end
    last_end = e + 1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

local openFileInADO = function(branch)
  local currentBranch = branch or trim(vim.fn.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }))
  local fileName = "/" .. vim.fn.expand("%:~:.")
  local remoteOrigin = trim(vim.fn.system({ "git", "config", "--get", "remote.origin.url" }))
  local remoteUrl = split(remoteOrigin, "@")[2]

  vim.print(remoteUrl)
  local cmd = string.format(
    [[open -a "/Applications/Google Chrome.app" 'https://%s?path=%s&version=GB%s&_a=contents']],
    remoteUrl,
    fileName,
    currentBranch
  )
  os.execute(cmd)
end

lvim.builtin.which_key.mappings["a"] = {
  name = "ADO",
  b = {
    openFileInADO,
    "Open File and Branch in ADO",
  },
  f = {
    function()
      openFileInADO("feature-int")
    end,
    "Open File and Branch in ADO",
  },
  d = {
    function()
      openFileInADO("develop")
    end,
    "Open File on Develop in ADO",
  },
}

-- git blame -L 37,37 -l -- src/App.ts
--
require("scope").setup({})
require("telescope").load_extension("scope")

require("nvim-ts-autotag").setup()

-- require("nvim-tree").setup({
--   view = {
--      adaptive_size = true,
--   },
-- })
--
lvim.builtin.nvimtree.setup.view.adaptive_size = true

vim.api.nvim_create_user_command("DirectorySessionSave", function()
  local currentDirectory = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local path = SESSION_DIR .. "/" .. currentDirectory .. ".vim"
  vim.cmd("mks! " .. path);
  vim.print("Saved " .. path)
end, { nargs = 0 })

vim.api.nvim_create_user_command("DirectorySessionLoad", function()
  local currentDirectory = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local path = SESSION_DIR .. "/" .. currentDirectory .. ".vim"
  vim.cmd("source " .. path);
  vim.print("Loaded " .. path)
end, { nargs = 0 })

lvim.builtin.which_key.mappings["S"] = {
  name = "Sessions",
  s = { ":DirectorySessionSave<CR>", "Make/Save Directory Session" },
  l = { ":DirectorySessionLoad<CR>", "Load Session For Current Dir" },
}

require 'treesitter-context'.setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = "_",
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.g["go_addtags_transform"] = "camelcase"

require('leap-spooky').setup {
  -- Additional text objects, to be merged with the default ones.
  -- E.g.: {'iq', 'aq'}
  extra_text_objects = nil,
  -- Mappings will be generated corresponding to all native text objects,
  -- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.
  -- Special line objects will also be added, by repeating the affixes.
  -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
  -- window.
  affixes = {
    -- The cursor moves to the targeted object, and stays there.
    magnetic = { window = 'm', cross_window = 'M' },
    -- The operation is executed seemingly remotely (the cursor boomerangs
    -- back afterwards).
    remote = { window = 'r', cross_window = 'R' },
  },
  -- Defines text objects like `riw`, `raw`, etc., instead of
  -- targets.vim-style `irw`, `arw`. (Note: prefix is forced if a custom
  -- text object does not start with "a" or "i".)
  prefix = false,
  -- The yanked text will automatically be pasted at the cursor position
  -- if the unnamed register is in use.
  paste_on_remote_yank = false,
}
