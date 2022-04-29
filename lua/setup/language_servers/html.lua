-- Using a language server from vscode
-- npm i -g vscode-langservers-extracted
return function(capabilities, on_attach)
	require("lspconfig").html.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			-- Disable formatting. I'm using prettier for this
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false
			return on_attach(client, bufnr)
		end,
	})
end
