-- Gopls installed using standard golang installer
return function(_, on_attach)
	require('lsp_config"').gopls.setup({
		on_attach = on_attach,
	})
end
