local lsp_fallback_disable_filetypes =
	{ c = true, cpp = true, typescript = true, javascript = true, typescriptreact = true, javascriptreact = true }

local tsjsConfig = {
	-- "eslint",
	"prettierd",
}

return { -- Autoformat
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			if not vim.g.auto_format_enabled then
				return nil
			end

			return {
				timeout_ms = 3000,
				lsp_fallback = not lsp_fallback_disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = tsjsConfig,
			javascript = tsjsConfig,
			typescriptreact = tsjsConfig,
			javascriptreact = tsjsConfig,
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			python = { "black" },
			--
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			-- javascript = { { "prettierd", "prettier" } },
		},
		-- Set the log level. Use `:ConformInfo` to see the location of the log file.
		log_level = vim.log.levels.DEBUG,
		-- Conform will notify you when a formatter errors
		notify_on_error = false,
	},
}
