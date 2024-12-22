return {
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
					["core.export.markdown"] = { config = { extensions = "all" } },
					["core.concealer"] = {
						config = {
							icon_preset = "basic",
							folds = false,
							icons = {
								delimiter = {
									horizontal_line = {
										highlight = "@neorg.delimiters.horizontal_line",
									},
								},
								todo = {
									done = { icon = "✓" },
									pending = { icon = "▶" },
									uncertain = { icon = "⁇" },
									on_hold = { icon = "⏸" },
									cancelled = { icon = "⏏" },
									undone = { icon = " " },
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
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/Documents/common/neorg/notes",
								work = "~/Documents/common/neorg/work",
							},
							default_workspace = "notes",
						},
					},
				},
			})
		end,
	},
}
