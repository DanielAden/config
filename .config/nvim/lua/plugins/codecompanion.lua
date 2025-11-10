return {
	{
		"olimorris/codecompanion.nvim",
		-- Adding this to ensure it loads before Telescope specifically, to solve an issue where the line with the search term is not
		-- being highlighted in Telescope preview windows, which I traced to this plugin.  Completely removing codecompanion
		-- fixes the issue so its definitely related to this plugin, but I am still unsure why
		-- priority = 1000,
		cmd = { "CodeCompanion", "CodeCompanionChat" },
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
	{ "github/copilot.vim" },
}
