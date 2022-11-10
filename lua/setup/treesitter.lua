require("nvim-treesitter.configs").setup({
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			-- Languages that have a single comment style
			typescript = "// %s",
			css = "/* %s */",
			scss = "/* %s */",
			html = "<!-- %s -->",
			svelte = "<!-- %s -->",
			vue = "<!-- %s -->",
			json = "",
		},
	},

	rainbow = {
		enable = true,
		extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
		max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
	},

	indent = {
		enable = true,
	},

	-- TODO: Check if I like to use autotag for anything else than html...
	autotag = {
		enable = true,
		filetypes = {
			"html",
		},
	},
})
