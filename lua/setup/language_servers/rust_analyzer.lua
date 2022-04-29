-- brew install rust-analyzer
return function(_, on_attach)
	require("rust-tools").setup({
		server = {
			on_attach = on_attach,
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
