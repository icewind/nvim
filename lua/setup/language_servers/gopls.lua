-- Gopls installed using standard golang installer
return function(_, on_attach)
	require("lspconfig").gopls.setup({
		on_attach = on_attach,
	})
end
