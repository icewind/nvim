--------------------------------------------------------------------------------
-- Global editor options
--
-- Some of the options for older versions of neovim were omitted
-- since they have sane defaults in neovim 0.4+
--------------------------------------------------------------------------------

local opt = vim.opt
local g = vim.g

-- Allows to hide the editor
opt.hidden = true

-- Language settings
-- TODO: Find another spell checker. Embedded spell checker is pretty bad dealing with CamelCase words
opt.spelllang= { 'en_us' }

-- Encoding options
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- Editor appearance
vim.cmd [[
	let g:everforest_background = 'hard'
	colorscheme everforest
]]

-- Always show signs column
opt.signcolumn = 'yes:1'

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.background = 'dark'
opt.colorcolumn = '120'
opt.splitright = true
opt.splitbelow = true

-- Formatting options
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent =true
opt.wrap = false
opt.ai = true
opt.si = true

-- Search options
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.showmatch = true

-- Disable swap files. No need because of version control systems
g.nobackup = true
g.noswapfile = true
g.nounofile = true

