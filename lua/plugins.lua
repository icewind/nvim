-- Automatically install packer if it is not installed at the following path
local fn = vim.fn

local packer_install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil

if fn.empty(fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = fn.system({
	  'git',
	  'clone',
	  '--depth',
	  '1',
	  'https://github.com/wbthomason/packer.nvim',
	  packer_install_path
  })
end

-- Split plugin configuration into different files in the `setup` folder.
local function get_config(name)
    return string.format('require("setup/%s")', name)
end

-- Automatically compile packer once the list of plugins changes
vim.cmd[[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

-- Add plugins
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- Package manager

	-- Select all the things with a nice UI
	use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }

	-- Superior syntax highlight
	use {
		'nvim-treesitter/nvim-treesitter',
		config = get_config('treesitter'),
		run = ':TSUpdate'
	}
  	use 'nvim-treesitter/nvim-treesitter-textobjects'

	-- Status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = {'kyazdani42/nvim-web-devicons', opt = true},
		config = get_config('lualine')
	}

	use({
    	"lewis6991/gitsigns.nvim",
      	requires = { "nvim-lua/plenary.nvim" },
      	event = "BufReadPre",
      	config = get_config("gitsigns"),
    })

	-- Autocompletion and LSP
	use {
		'neovim/nvim-lspconfig',
		config = get_config('lspconfig')
	}
    use {
		'hrsh7th/nvim-cmp',
		config = get_config('cmp')
	}
	use 'hrsh7th/cmp-nvim-lsp'

	-- Snippets and integration of snippets and cmp
	use 'saadparwaiz1/cmp_luasnip'
  	use 'L3MON4D3/LuaSnip'

	-- Display code issues
	use {
  		"folke/trouble.nvim",
  		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup()
  		end
	}

	-- .NET Development
	use { 'OmniSharp/omnisharp-vim', config = get_config('omnisharp') }

	-- Lua development(mainly for neovim)
	use 'tjdevries/nlua.nvim' -- Language server for Lua
	use 'euclidianAce/BetterLua.vim' -- Better syntax highlight
	use 'tjdevries/manillua.nvim' -- Folds for Lua code

	-- Automatically setup packer configuration after the first install
	if packer_bootstrap then
    	require('packer').sync()
  	end
end)
