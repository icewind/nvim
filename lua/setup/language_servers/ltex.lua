-- Grammar and style corrections using language tool(specifically ltex-ls)
-- ltex-ls manually downloaded from the Github
return function(capabilities, on_attach)
	require("lspconfig").ltex.setup({
		cmd = { os.getenv("HOME") .. "/tools/ltex-ls/bin/ltex-ls" },
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
