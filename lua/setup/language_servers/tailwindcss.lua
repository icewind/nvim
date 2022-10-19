-- npm install -g @tailwindcss/language-server
return function(capabilites, on_attach)
	require("lspconfig").tailwindcss.setup({
		capabilities = capabilites,
		on_attach = on_attach,
	})
end
