return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").load()
		end,
	},
	{ "EdenEast/nightfox.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
}
