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
		adapters = {
			acp = {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
						},
					})
				end,
			},
			http = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
						},
					})
				end,
			},
		},
		config = function()
			require("codecompanion").setup({
				-- https://codecompanion.olimorris.dev/configuration/adapters-http#changing-the-default-adapter
				interactions = {
					chat = {
						adapter = "claude_code",
					},
					inline = {
						adapter = "anthropic",
					},
					cmd = {
						adapter = "claude_code",
					},
				},
			})
		end,
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
