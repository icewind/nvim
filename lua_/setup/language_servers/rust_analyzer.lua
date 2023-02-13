-- rustup component add rust-analyzer
return function(_, on_attach)
	require("rust-tools").setup({
		server = {
			on_attach = on_attach,
			cmd = { "rustup", "run", "stable", "rust-analyzer" },
			settings = {
				["rust-analyzer"] = {
					diagnostics = {
						enable = true,
						disabled = { "unresolved-macro-call" },
					},
				},
			},
		},
	})
end
