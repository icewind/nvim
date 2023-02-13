return function(use)
	-- Set of plugins useful for the Web-based technologies
	use("mattn/emmet-vim")

	-- The allmighty Prettier
	use({
		"prettier/vim-prettier",
		run = "yarn install",
		ft = {
			"javascript",
			"typescript",
			"typescriptreact",
			"css",
			"less",
			"scss",
			"graphql",
			"markdown",
			"vue",
			"html",
		},
	})
end
