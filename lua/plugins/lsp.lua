return {
	{
		"folke/neodev.nvim",
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "pyright", "terraformls", "zls", "yamlls" },
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim", -- none-ls is an active community fork of null-ls
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = vim.list_extend(opts.sources or {}, {
				nls.builtins.formatting.shfmt,
				-- nls.builtins.code_actions.shellcheck,
				-- for go
				nls.builtins.formatting.gofmt,
				nls.builtins.formatting.goimports,
				nls.builtins.code_actions.gomodifytags,
				nls.builtins.code_actions.impl,
				-- for lua
				nls.builtins.formatting.stylua,
				-- for python
				nls.builtins.formatting.black,
			})
			return opts
		end,
	},
	{
		event = "VeryLazy",
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
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
					--	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})

			-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
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

			require("lspconfig").pyright.setup({
				capabilities = capabilities,
			})

			require("lspconfig").terraformls.setup({
				capabilities = capabilities,
				vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					pattern = { "*.tf", "*.tfvars" },
					callback = function()
						vim.lsp.buf.format()
					end,
				}),
			})

			-- Setup go language server gopls
			require("lspconfig").gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "gopls" },
				root_dir = require("lspconfig").util.root_pattern(".git", "go.mod", "."),
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			require("lspconfig").yamlls.setup({
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
							["https://json.schemastore.org/chart.json"] = "Chart.yaml",
							["https://json.schemastore.org/chart-lock.json"] = "Chart.lock",
						},
					},
				},
			})
		end,
	},
}
