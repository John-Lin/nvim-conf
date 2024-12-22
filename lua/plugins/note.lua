return {
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		ft = "norg",
		opts = {
			load = {
				["core.keybinds"] = {
					config = {
						default_keybinds = false,
						hook = function(keybinds)
							keybinds.remap_event("norg", "i", "<M-CR>", "core.itero.next-iteration")
							keybinds.remap_event("norg", "n", "<M-CR>", "core.itero.next-iteration")
						end,
					},
				},
				["core.defaults"] = {}, -- Loads default behaviour
				-- ["core.presenter"] = { config = {
				-- 	zen_mode = "zen-mode",
				-- } },
				["core.export"] = {},
				["core.completion"] = { config = { engine = "nvim-cmp" } },
				["core.export.markdown"] = {
					config = {
						extensions = "all",
					},
				},
				["core.concealer"] = {
					config = {
						icon_preset = "basic",
						icons = {
							delimiter = {
								horizontal_line = {
									highlight = "@neorg.delimiters.horizontal_line",
								},
							},
							code_block = {
								-- If true will only dim the content of the code block (without the
								-- `@code` and `@end` lines), not the entirety of the code block itself.
								content_only = true,

								-- The width to use for code block backgrounds.
								--
								-- When set to `fullwidth` (the default), will create a background
								-- that spans the width of the buffer.
								--
								-- When set to `content`, will only span as far as the longest line
								-- within the code block.
								width = "content",

								-- Additional padding to apply to either the left or the right. Making
								-- these values negative is considered undefined behaviour (it is
								-- likely to work, but it's not officially supported).
								padding = {
									-- left = 20,
									-- right = 20,
								},

								-- If `true` will conceal (hide) the `@code` and `@end` portion of the code
								-- block.
								conceal = true,

								nodes = { "ranged_verbatim_tag" },
								highlight = "CursorLine",
								-- render = module.public.icon_renderers.render_code_block,
								insert_enabled = true,
							},
						},
					},
				},
			},
		},
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
}
