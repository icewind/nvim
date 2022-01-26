return function(capabilites, on_attach)
	require("lspconfig").tsserver.setup({
		capabilites = capabilites,
		on_attach = on_attach,
	})
end
