return function(capabilites, on_attach)
	require("lspconfig").cssls.setup({
		capabilities = capabilites,
		on_attach = on_attach,
	})
end
