return function(capabilites, on_attach)
	require("lspconfig").html.setup({
		capabilities = capabilites,
		on_attach = on_attach,
	})
end
