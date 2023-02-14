--------------------------------------------------------------------------------
-- Global editor options
--
-- Some of the options for older versions of NeoVim were omitted
-- since they have sane defaults in NeoVim 0.4+
--------------------------------------------------------------------------------

local set = vim.opt
local g = vim.g

set.hidden = true

-- Language settings
-- Disabled it because it works pretty bad...
set.spell = false
set.spelllang = { "en_us" }
set.spellsuggest = "5"
set.spelloptions = "camel"

-- Encoding options
set.encoding = "utf-8"
set.fileencoding = "utf-8"

-- Editor appearance
-- TODO: Port these to lua
vim.cmd([[
	let g:everforest_background = 'medium'
	let g:everforest_better_performance = 1
	colorscheme everforest
]])

-- Remember the last cursor position
-- TODO: Port these to lua
vim.cmd([[
	filetype plugin indent on

	augroup vim-remember-cursor-position
		autocmd!
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	augroup END
]])

-- Always show signs column
set.signcolumn = "yes:1"

set.mouse = "a"
set.clipboard = "unnamedplus"

set.termguicolors = true
set.number = true
set.relativenumber = true
set.ruler = true
set.background = "dark"
set.colorcolumn = "120"
set.splitright = true
set.splitbelow = true

-- Global status line for neovim 0.7+
set.laststatus = 3

-- Default formatting options
set.conceallevel = 0
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4

set.expandtab = true
set.wrap = false
set.autoindent = true
set.smarttab = true

-- Search options
set.hlsearch = true
set.incsearch = true
set.smartcase = true
set.ignorecase = true
set.showmatch = true

-- Disable swap files. No need because of version control systems
g.nobackup = true
g.noswapfile = true
g.noundofile = true

-- Using treesitter to fold/unfold
vim.wo.foldlevel = 20
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- Autocompletion
set.completeopt = { "menuone", "noselect" }

-- TODO: Move the following lines out of the main config file

-- Code highlight in markdown files
g.markdown_fenced_languages = { "rust", "go", "typescript", "javascript", "python", "sql", "css", "json" }

-- Enable typescript syntax highlight for svelte files
g.vim_svelte_plugin_use_typescript = 1

-- Prettier format on save
g["prettier#autoformat"] = 1
g["prettier#autoformat_require_pragma"] = 0

-- Rust analyzer format on save
g["rustfmt_autosave"] = 1

-- Databases
g["db_ui_use_nerd_fonts"] = 1
g["db_ui_save_location"] = "~/Projects/SQLPad"

vim.cmd(
	[[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({sources={{name='vim-dadbod-completion'}}})]]
)
