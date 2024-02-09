return {
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
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup()
    end,
  },
  { "nvim-treesitter/playground" },
  { "norcalli/nvim-colorizer.lua" },
  { "EdenEast/nightfox.nvim" },
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup({})
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require('treesitter-context').setup {
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
    end,
  },
  { "fatih/vim-go" },
  {
    "ggandor/leap-spooky.nvim",
    config = function()
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
        -- text objectadoes not start with "a" or "i".)
        prefix = false,
        -- The yanked text will automatically be pasted at the cursor position
        -- if the unnamed register is in use.
        paste_on_remote_yank = false,
      }
    end,
  },
  { "christoomey/vim-tmux-navigator" },
  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = { line = '<leader>/', block = '<leader>?' },
      opleader = { line = '<leader>/', block = '<leader>?' },
    }
  },
  { "nvim-tree/nvim-tree.lua" },
  -- breadcrumbs
  {
    "SmiteshP/nvim-navic",
  },

  {
    "akinsho/bufferline.nvim",
    -- config = function()
    --   require("lvim.core.bufferline").setup()
    -- end,
    branch = "main",
    event = "User FileOpened",
    enabled = true,
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  { "EdenEast/nightfox.nvim" },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = false
      })
    end,
    event = "User FileOpened",
    cmd = "Gitsigns",
    enabled = true
  },
  {
    "hrsh7th/cmp-buffer"
  },
  {
    'glacambre/firenvim',

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "sindrets/diffview.nvim" },
}
