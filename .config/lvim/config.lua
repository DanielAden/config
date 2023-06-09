--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.list = true
vim.opt.listchars:append("trail:·")
vim.opt.listchars:append("lead:·")


-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua,*.ts,*.tsx",
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

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- -- Disable lvim custom finder for <leader>f
lvim.builtin.which_key.mappings["f"] = {
  require("lvim.core.telescope.custom-finders").find_project_files,
  "Find File"
}

lvim.builtin.which_key.mappings["x"] = {
  name = "Close",
  b = { ":bd<CR>", "Buffer" },
  w = { ":close<CR>", "Window" },
  a = { ":qa<CR>", "all" },
}


lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.which_key.mappings["j"] = {
  name = "Terminal",
  j = { "<cmd>ToggleTerm<cr>", "Open Terminal" },
}

-- vim-test
vim.api.nvim_create_user_command(
  'ClearTestBuffers',
  function()
    local buffers = vim.api.nvim_list_bufs();
    for index, value in ipairs(buffers) do
      local name = vim.api.nvim_buf_get_name(value);
      local isTestBuffer = string.find(name, "term://") and string.find(name, "react%-scripts") or
          string.find(name, "jest");
      if (isTestBuffer) then
        vim.cmd(string.format('bw! %s', value));
      end
    end
    ;
  end,
  { nargs = 0 }
)

vim.g["test#strategy"] = "neovim";
vim.g["test#neovim#term_position"] = "vert botright 120";
vim.g["test#preserve_screen"] = 0;
vim.g["test#javascript#jest#options"] = "--watchAll=false";
vim.g["test#javascript#reactscripts#options"] = "--watchAll=false --env=jsdom";
vim.g["test#neovim#start_normal"] = 1;
-- vim.g["test#enabled_runners"] = ["javascript#jest"];
lvim.builtin.which_key.mappings["u"] = {
  name = "Unit Tests",
  c = { function()
    vim.cmd("ClearTestBuffers"); -- Wipes any previous test buffers
  end, "Clear Test Buffers" },
  t = { function()
    vim.cmd("ClearTestBuffers");                         -- Wipes any previous test buffers
    vim.cmd("TestNearest");
    vim.cmd.exe { args = { '"normal \\<C-w>\\<C-p>"' } } -- puts cursor in previous position
  end, "Test Nearest" },
  T = { function()
    vim.cmd("ClearTestBuffers");
    vim.cmd("TestFile");
    vim.cmd.exe { args = { '"normal \\<C-w>\\<C-p>"' } }
  end, "Test File" },
  a = { function()
    vim.cmd("ClearTestBuffers");
    vim.cmd("TestSuite");
    vim.cmd.exe { args = { '"normal \\<C-w>\\<C-p>"' } }
  end, "Test Suite" },
  l = { function()
    vim.cmd("ClearTestBuffers");
    vim.cmd("TestLast");
    vim.cmd.exe { args = { '"normal \\<C-w>\\<C-p>"' } }
  end, "Run Last Test" },
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
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
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
      ["<esc>"] = actions.close

    }
  }
}

vim.lsp.handlers["textDocument/references"] = require("telescope/builtin").lsp_references;


-- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "stylua" },
  -- {
  --   command = "prettier",
  --   -- extra_args = { "--print-width", "100" },
  --   filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  -- },
  -- {
  --   command = "eslint_d"
  -- },
  {
    command = "prettierd"
  },
  -- {
  --   { exe = "jq", args = { "--indent", "2" }, filetypes = { "json" } },
  -- }
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  -- { command = "flake8", filetypes = { "python" } },
  -- {
  --   command = "shellcheck",
  --   args = { "--severity", "warning" },
  -- },
  {
    command = "eslint_d"
  }
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  }
}

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


local masonPackages = vim.fn.stdpath "data" .. "/mason/packages/";
local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { masonPackages .. 'node-debug2-adapter/out/src/nodeDebug.js' },
}


for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    {
      name = "Attach",
      type = "node2",
      request = "attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      name = "Launch App.ts",
      type = "node2",
      request = "launch",
      cwd = "${workspaceFolder}",
      args = { "-r", "ts-node/register/transpile-only", "./src/App.ts" }
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


local cfg = {}; -- add your config here
require "lsp_signature".setup(cfg)


-- Markdown Settings
vim.g.markdown_folding = true;
vim.api.nvim_create_autocmd("FileType", {
  pattern = 'markdown',
  callback = function()
    vim.opt.wrap = true;
    vim.opt.linebreak = true;
  end
})
