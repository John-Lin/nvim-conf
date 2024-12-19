local set = vim.o
set.number = true
set.relativenumber = true
set.clipboard = "unnamed"
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting


-- 複製後高亮
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function() vim.highlight.on_yank({
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
    { "RRethy/base16-nvim", lazy = true },
    {
      cmd = "Telescope",
      keys = {
      	{ "<Leader>p", ":Telescope find_files<CR>", desc = "find files" },
      	{ "<Leader>P", ":Telescope live_grep<CR>", desc = "grep file" },
      	{ "<Leader>rs", ":Telescope resume<CR>", desc = "resume" },
      	{ "<Leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" },
      },
      "nvim-telescope/telescope.nvim", tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
      event = "VeryLazy",
      "williamboman/mason.nvim",
      build = ":MasonUpdate", -- :MasonUpdate updates registry contents
      config = function()
          require("mason").setup()
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
      config = function()
	local configs = require("nvim-treesitter.configs")
        configs.setup({
             ensure_installed = { 
		"c", "lua", "vim", "vimdoc", "go", "bash", 
		"markdown", "javascript", "gomod", "gosum", 
	        "python", "yaml", "json", "terraform", "make" 
	     },
             sync_install = false,
             highlight = { enable = true },
             indent = { enable = true },  
           })
      end
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
vim.cmd.colorscheme("base16-tokyo-city-dark")
