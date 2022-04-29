-- npm i -g svelte-language-server
return function(capabilities, on_attach)
	require("lspconfig").svelte.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
