return function(_, on_attach)
	require("lspconfig").pyright.setup({
		on_attach = on_attach,
	})
end
