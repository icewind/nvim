-- Pyright is installed using pip
-- pip install pyright
return function(_, on_attach)
	require("lspconfig").pyright.setup({
		on_attach = on_attach,
	})
end
