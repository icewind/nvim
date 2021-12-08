require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		extended_mode = true
	},

	-- TODO: Check if I like to use autotag for anything else than html...
	autotag = {
		enable = true,
		filetypes = {
			'html'
		}
	},

	indent = {
		enable = true
	}
}
