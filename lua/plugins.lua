-- Utils
local files_in_folder = require("utils").files_in_folder

-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Is it is the first time we starting the editor with this configuraiton
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

-- Automatically re-compile packer whenever the configuration has changed
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("$MYVIMRC"),
})

-- Split plugin configuration into different files in the `setup/plugins` folder.
local function get_config(name)
	return string.format('require("setup.%s")', name)
end

-- Add plugins
require("packer").startup(function(use)
	-- ---------------------------------------------------------------
	-- General
	-- ---------------------------------------------------------------
	-- Package manager
	use("wbthomason/packer.nvim")

	-- Better buffer close functionality
	use("moll/vim-bbye")

	-- Improve startup time
	use("lewis6991/impatient.nvim")

	-- Terminal
	use({ "akinsho/toggleterm.nvim", tag = "*", config = get_config("toggleterm") })

	-- File manager
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = get_config("tree"),
	})

	-- ---------------------------------------------------------------
	-- Appearance
	-- ---------------------------------------------------------------
	use("sainnhe/everforest")

	-- Better statusline
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = get_config("lualine"),
	})

	-- And buffers line
	use({
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = get_config("bufferline"),
	})

	-- The one and only Telescope
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			"nvim-lua/plenary.nvim",
			-- Use telescope instead of the standard ui.select
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = get_config("telescope"),
	})

	-- ---------------------------------------------------------------
	-- LSP Configuration & Plugins
	-- ---------------------------------------------------------------
	use({
		"neovim/nvim-lspconfig",
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jay-babu/mason-null-ls.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			"folke/neodev.nvim",
		},
		config = get_config("lspconfig"),
	})

	-- Show function signature on type
	use({
		"ray-x/lsp_signature.nvim",
		config = get_config("lspsignature"),
	})

	use("github/copilot.vim")

	-- ---------------------------------------------------------------
	-- Editing
	-- ---------------------------------------------------------------
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
		config = get_config("treesitter"),
	})

	-- Surround the text
	use({ "kylechui/nvim-surround", config = get_config("surround") })

	-- Additional text objects via treesitter
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	-- Quick jump to the letter or symbol on the screen
	use({
		"phaazon/hop.nvim",
		event = "BufReadPre",
		config = get_config("hop"),
	})

	-- Display code issues
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = get_config("trouble"),
	})

	-- Autocompletion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",

			-- Add kind icons into completion dropdown
			"onsails/lspkind-nvim",

			-- Get completions from the current buffer
			"hrsh7th/cmp-buffer",
		},
		config = get_config("cmp"),
	})

	use({
		"windwp/nvim-autopairs",
		config = get_config("autopairs"),
	})

	use({ "lukas-reineke/indent-blankline.nvim", config = get_config("indent-blankline") }) -- Add indentation guides even on blank lines
	use({ "numToStr/Comment.nvim", config = get_config("comment") }) -- "gc" to comment visual regions/lines
	use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically

	-- Code actions for ltex-ls
	use({ "icewind/ltex-client.nvim", config = get_config("ltex-client") })

	-- ---------------------------------------------------------------
	-- Git related plugins
	-- ---------------------------------------------------------------
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use({ "lewis6991/gitsigns.nvim", config = get_config("gitsigns") })

	-- ---------------------------------------------------------------
	-- Language/Framework specific plugins
	-- ---------------------------------------------------------------
	-- These plugins should not use `get_config` helper and contain all the required parameters in one file
	for _, name in ipairs(files_in_folder({ "language_plugins" })) do
		require(string.format("language_plugins.%s", name))(use)
	end

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	-- This might be used to add plugins you don't want to put into the main config
	local has_plugins, plugins = pcall(require, "custom.plugins")
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require("packer").sync()
	end
end)
