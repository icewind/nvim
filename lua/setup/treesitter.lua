require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		disable = { "typescript", "tsx", "typescriptreact" },
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
