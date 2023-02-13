-- Gopls installed using
-- go install golang.org/x/tools/gopls@latest
return function(_, on_attach)
	require("lspconfig").gopls.setup({
		on_attach = on_attach,
	})
end
