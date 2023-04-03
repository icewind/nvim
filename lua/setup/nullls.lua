local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		-- Formatting
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,

		-- Code actions
		null_ls.builtins.code_actions.cspell,

		-- Diagnostics
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.cspell,
	},
})
