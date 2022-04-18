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
opt.spelllang = { "en_us" }

-- Encoding options
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Editor appearance
vim.cmd([[
	let g:everforest_background = 'hard'
	colorscheme everforest
]])

-- Remember the last cursor position
vim.cmd([[
	filetype plugin indent on

    augroup vim-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
]])

-- Always show signs column
opt.signcolumn = "yes:1"

opt.mouse = "a"

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.background = "dark"
opt.colorcolumn = "120"
opt.splitright = true
opt.splitbelow = true

-- Global status line for neovim 0.7+
opt.laststatus = 3

-- Default formatting options
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.ai = true
opt.si = true

-- Search options
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.showmatch = true

-- Disable swap files. No need because of version control systems
g.nobackup = true
g.noswapfile = true
g.nounofile = true

-- Using treesitter to fold/unfold
vim.wo.foldlevel = 20
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- Highlight yanked text
vim.cmd([[
	augroup highlight_yank
		autocmd!
		au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=400}
	augroup END
]])

-- Autocompletion
opt.completeopt = "menu,menuone,noselect"

-- Code highlight in markdown files
g.markdown_fenced_languages = { "rust", "cs", "typescript", "javascript", "python", "css", "json" }

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
