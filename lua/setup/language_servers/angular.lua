-- npm i --save-dev @angular/language-service
return function(capabilities, on_attach)
	require("lspconfig").angularls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
