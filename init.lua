local set = vim.o
set.number = true
set.relativenumber = true
set.clipboard = "unnamed"
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- highlight after yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 50,
		})
	end,
})

-- keybindings
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<Leader>v", "<C-w>v", opts)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opts)
vim.keymap.set("n", "<Leader>[", "<C-o>", opts)
vim.keymap.set("n", "<Leader>]", "<C-i>", opts)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			keys = {
				{ "<leader>t", ":NERDTreeToggle<CR>", desc = "toggle nerdtree" },
				{ "<leader>l", ":NERDTreeFind<CR>", desc = "nerdtree find" },
			},
			"preservim/nerdtree",
			event = "BufEnter", -- 當進入緩衝區（文件）時載入
			config = function()
				vim.cmd([[let NERDTreeShowHidden=1]])
				vim.api.nvim_create_autocmd("VimEnter", {
					callback = function()
						if vim.fn.argc() == 0 then
							vim.cmd("NERDTree")
						end
					end,
				})
			end,
			dependencies = {
				"Xuyuanp/nerdtree-git-plugin",
				"ryanoasis/vim-devicons",
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			config = function()
				require("nvim-treesitter.configs").setup({
					textobjects = {
						swap = {
							enable = true,
							swap_next = {
								["<leader>a"] = "@parameter.inner",
							},
							swap_previous = {
								["<leader>A"] = "@parameter.inner",
							},
						},
						select = {
							enable = true,

							-- Automatically jump forward to textobj, similar to targets.vim
							lookahead = true,

							keymaps = {
								-- You can use the capture groups defined in textobjects.scm
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["aa"] = "@parameter.outer",
								["ia"] = "@parameter.inner",
								["ac"] = "@class.outer",
								-- You can optionally set descriptions to the mappings (used in the desc parameter of
								-- nvim_buf_set_keymap) which plugins like which-key display
								["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
								-- You can also use captures from other query groups like `locals.scm`
								["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
							},
							-- You can choose the select mode (default is charwise 'v')
							--
							-- Can also be a function which gets passed a table with the keys
							-- * query_string: eg '@function.inner'
							-- * method: eg 'v' or 'o'
							-- and should return the mode ('v', 'V', or '<c-v>') or a table
							-- mapping query_strings to modes.
							selection_modes = {
								["@parameter.outer"] = "v", -- charwise
								["@function.outer"] = "V", -- linewise
								["@class.outer"] = "<c-v>", -- blockwise
							},
							-- If you set this to `true` (default is `false`) then any textobject is
							-- extended to include preceding or succeeding whitespace. Succeeding
							-- whitespace has priority in order to act similarly to eg the built-in
							-- `ap`.
							--
							-- Can also be a function which gets passed a table with the keys
							-- * query_string: eg '@function.inner'
							-- * selection_mode: eg 'v'
							-- and should return true of false
							include_surrounding_whitespace = true,
						},
					},
				})
			end,
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"c",
						"lua",
						"vim",
						"vimdoc",
						"markdown",
						"python",
						"javascript",
						"go",
						"terraform",
						"yaml",
						"json",
						"vrl",
						"zig",
					},
					incremental_selection = {
						enable = true,
						keymaps = {
							node_incremental = "v",
							node_decremental = "<BS>",
						},
					},
					highlight = {
						enable = true,
					},
				})
			end,
		},
		{
			"rhysd/conflict-marker.vim",
			event = "VeryLazy",
		},
		{
			event = "VeryLazy",
			"hrsh7th/nvim-cmp",
			dependencies = {
				"neovim/nvim-lspconfig",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/nvim-cmp",
				"L3MON4D3/LuaSnip",
			},
		},
		{
			"windwp/nvim-autopairs",
			event = "VeryLazy",
			config = function()
				require("nvim-autopairs").setup({})
			end,
		},
		{
			event = "VeryLazy",
			"williamboman/mason.nvim",
			build = ":MasonUpdate", -- :MasonUpdate updates registry contents
			config = function()
				require("mason").setup()
			end,
		},

		{
			event = "VeryLazy",
			"neovim/nvim-lspconfig",
			dependencies = { "williamboman/mason-lspconfig.nvim" },
		},
		{
			event = "VeryLazy",
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				local null_ls = require("null-ls")

				local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.formatting.ruff,
					},
					on_attach = function(client, bufnr)
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = augroup,
								buffer = bufnr,
								callback = function()
									-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
									vim.lsp.buf.format({ bufnr = bufnr })
								end,
							})
						end
					end,
				})
			end,
		},
		{
			"RRethy/base16-nvim",
			lazy = true,
		},
		{
			"folke/neodev.nvim",
		},
		{
			cmd = "Telescope",
			keys = {
				{ "<Leader>p", ":Telescope find_files<CR>", desc = "find files" },
				{ "<Leader>P", ":Telescope live_grep<CR>", desc = "grep file" },
				{ "<Leader>rs", ":Telescope resume<CR>", desc = "resume" },
				{ "<Leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" },
			},
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"github/copilot.vim",
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- color scheme
vim.cmd.colorscheme("base16-tomorrow-night")
-- lsp config

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
require("mason").setup()
require("mason-lspconfig").setup()

-- set up lspconfig
local common_servers = {
	"bashls",
	"yamlls",
	"pyright",
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in pairs(common_servers) do
	-- https://www.reddit.com/r/neovim/comments/mm1h0t/lsp_diagnostics_remain_stuck_can_someone_please/
	require("lspconfig")[server].setup({
		flags = {
			allow_incremental_sync = false,
			debounce_text_changes = 500,
		},
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "hs" },
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = {
					vim.api.nvim_get_runtime_file("", true),
					"/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
					vim.fn.expand("~/lualib/share/lua/5.4"),
					vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
					"/opt/homebrew/opt/openresty/lualib",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- terraform-ls
require("lspconfig").terraformls.setup({})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.tf", "*.tfvars" },
	callback = function()
		vim.lsp.buf.format()
	end,
})

-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings

-- nvim cmp
-- Set up nvim-cmp.
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- they way you will only jump inside the snippet region
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-c>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

-- https://www.reddit.com/r/neovim/comments/sk70rk/using_github_copilot_in_neovim_tab_map_has_been/
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- 具體高亮組
vim.api.nvim_set_hl(0, "@lsp.type.variable.lua", { link = "Normal" })
vim.api.nvim_set_hl(0, "Identifier", { link = "Normal" })
vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })
