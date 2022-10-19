-- npm i -g typescript-language-server
return function(capabilites, on_attach)
	require("lspconfig").tsserver.setup({
		capabilites = capabilites,
		on_attach = function(client, bufnr)
			-- Disable formatting. I'm using prettier for this
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			return on_attach(client, bufnr)
		end,
	})
end
