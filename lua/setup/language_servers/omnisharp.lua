-- .NET Development using standalone OmniSharp and neovim's builtin language server
-- The language server itself is downloaded from the Github and stored in the filesystem
-- manually downloaded from github
local pid = vim.fn.getpid()
local omnisharp_path = os.getenv("HOME") .. "/tools/omnisharp/run"

return function(capabilities, on_attach)
	require("lspconfig").omnisharp.setup({
		capabilities = capabilities,
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			-- Add lsp keymaps for this buffer
			on_attach(_, bufnr)
		end,
		cmd = {
			omnisharp_path,
			"--languageserver",
			"--hostPID",
			tostring(pid),
			"FormattingOptions:OrganizeImports=true",
		},
	})
end
