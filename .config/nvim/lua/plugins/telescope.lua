-- Telescope default mappings: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
local lga_actions = require("telescope-live-grep-args.actions")
local actions = require("telescope.actions")
local putils = require("telescope.previewers.utils")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
local utils = require("utils")

local ignore_glob_pattern = {
	"!**/acceptance/**",
	"!**/__test__/**",
	"!*.test.*",
	"!**/mocks/**",
	"!package-lock.json",
	"!**/test/**",
}

return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use Telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of `help_tags` options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- Telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			defaults = {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
					width = 0.95,
					height = 0.90,
					-- preview_width = 0.5,
				},
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<tab>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({
							postfix = "  --iglob ",
						}),
						["<C-t>"] = lga_actions.quote_prompt({
							postfix = "  --type ",
						}),
						-- freeze the current list and start a fuzzy search in the frozen list
						["<C-space>"] = actions.to_fuzzy_refine,
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
								string.format("Preview disabled for %s files", excluded[1]:sub(5, -1))
							)
							return false
						end
						return true
					end,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension("scope"))

		-- -- See `:help telescope.builtin`
		-- local builtin = require("telescope.builtin")
		-- vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		-- vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		-- vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		-- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		-- vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		-- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		-- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		-- vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		-- vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		--
		-- -- Slightly advanced example of overriding default behavior and theme
		-- vim.keymap.set("n", "<leader>/", function()
		-- 	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		-- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		-- 		winblend = 10,
		-- 		previewer = false,
		-- 	}))
		-- end, { desc = "[/] Fuzzily search in current buffer" })
		--
		-- -- It's also possible to pass additional configuration options.
		-- --  See `:help telescope.builtin.live_grep()` for information about particular keys
		-- vim.keymap.set("n", "<leader>s/", function()
		-- 	builtin.live_grep({
		-- 		grep_open_files = true,
		-- 		prompt_title = "Live Grep in Open Files",
		-- 	})
		-- end, { desc = "[S]earch [/] in Open Files" })
		--
		-- -- Shortcut for searching your Neovim configuration files
		-- vim.keymap.set("n", "<leader>sn", function()
		-- 	builtin.find_files({ cwd = vim.fn.stdpath("config") })
		-- end, { desc = "[S]earch [N]eovim files" })

		-- See `:help telescope.builtin`
		vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sg", require("telescope.builtin").git_files, { desc = "[S]earch [G]it Files" })

		vim.keymap.set(
			"n",
			"<leader>st",
			require("telescope").extensions.live_grep_args.live_grep_args,
			{ desc = "[S]earch by [T]ext" }
		)

		local function telescope_search_word_ignore_test_files()
			local ignore_args = utils.map(ignore_glob_pattern, function(s)
				return "--iglob=" .. s
			end)
			live_grep_args_shortcuts.grep_word_under_cursor({
				prompt_title = "Search Word (Ignoring Test Files)",
				additional_args = ignore_args,
			})
		end
		vim.keymap.set("n", "<leader>sw", telescope_search_word_ignore_test_files, { desc = "[S]earch current [W]ord" })

		vim.keymap.set(
			"n",
			"<leader>sW",
			require("telescope.builtin").grep_string,
			{ desc = "[S]earch current [W]ord + Line" }
		)

		local function grep_visual_selection_ignore_test_files()
			local ignore_args = utils.map(ignore_glob_pattern, function(s)
				return "--iglob=" .. s
			end)
			live_grep_args_shortcuts.grep_visual_selection({
				prompt_title = "Search Visual Selection (Ignoring Test Files)",
				additional_args = ignore_args,
			})
		end
		vim.keymap.set(
			"v",
			"<leader>sw",
			grep_visual_selection_ignore_test_files,
			{ desc = "[S]earch Visual Selection (Ignoring Test Files)" }
		)

		vim.keymap.set(
			"v",
			"<leader>sW",
			live_grep_args_shortcuts.grep_visual_selection,
			{ desc = "[S]earch Visual Selection" }
		)

		vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch [B]uffers" })
		vim.keymap.set("n", "<leader>sr", function()
			require("telescope.builtin").oldfiles({
				only_cwd = true,
			})
		end, { desc = "[S]earch [R]ecent" })

		vim.keymap.set(
			"n",
			"<leader>ss",
			require("telescope.builtin").builtin,
			{ desc = "[S]earch [S]elect Telescope" }
		)
		vim.keymap.set("n", "<leader>sm", require("telescope.builtin").marks, { desc = "[S]earch [M]arks" })
		vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>se", function()
			require("telescope.builtin").diagnostics({
				severity_limit = vim.diagnostic.severity.ERROR,
			})
		end, { desc = "[S]earch [E]rror Diagnostics" })
		vim.keymap.set("n", "<leader>sl", require("telescope.builtin").resume, { desc = "[S]earch [L]ast" })

		local function telescope_live_grep_args_ignore_test_files()
			local ignore_args = utils.map(ignore_glob_pattern, function(s)
				return "--iglob=" .. s
			end)
			require("telescope").extensions.live_grep_args.live_grep_args({
				prompt_title = "Find Text (Ignoring Test Files)",
				additional_args = ignore_args,
			})
		end

		vim.keymap.set(
			"n",
			"<leader>si",
			telescope_live_grep_args_ignore_test_files,
			{ desc = "Search Files (Ignoring Test Files)" }
		)

		vim.keymap.set(
			"n",
			"<leader>so",
			require("telescope.builtin").current_buffer_fuzzy_find,
			{ desc = "[S]earch [O]pen Buffer" }
		)

		local function telescope_live_search_config_files()
			local config_root = vim.fn.stdpath("config")
			require("telescope.builtin").find_files({
				prompt_title = "Search Config Files",
				search_dirs = { config_root },
			})
		end
		vim.keymap.set("n", "<leader>sc", telescope_live_search_config_files, { desc = "Search Config Files" })

		local function telescope_live_grep_config_files()
			local config_root = vim.fn.stdpath("config")
			require("telescope.builtin").live_grep({
				prompt_title = "Grep Config Files",
				search_dirs = { config_root },
				glob_pattern = "!lazy-lock.json",
			})
		end
		vim.keymap.set("n", "<leader>sC", telescope_live_grep_config_files, { desc = "Grep Config Files" })

		-- vim.lsp.handlers["textDocument/references"] = require("telescope/builtin").lsp_references

		vim.api.nvim_create_user_command("SF", function(t)
			local filetype = t.args
			require("telescope.builtin").live_grep({
				type_filter = filetype,
			})
		end, { nargs = 1, desc = "Search by Filetype" })
	end,
}
