require("null-ls").setup({
	sources = {
		-- Formatting
		require("null-ls").builtins.formatting.stylua,

		-- Diagnostics
		require("null-ls").builtins.diagnostics.eslint,
	},
})
