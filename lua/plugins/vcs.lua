return {
	{ "rhysd/conflict-marker.vim", event = "VeryLazy" },
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
			-- convert
			vim.cmd.cnoreabbrev([[git Git]])
		end,
	},
}
