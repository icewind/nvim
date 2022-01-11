local on_attach = function(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>td", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
	-- Using code actions in telescope
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<cr>", opts)

	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fd", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)

	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- .NET Development using OmniSharp(standalone)
local pid = vim.fn.getpid()
local omnisharp_path = "/Users/icewind/tools/omnisharp/run"

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

-- Development of lua plugins and neovim configuration files
local runtime_path = vim.split(package.path, ";")
local lua_library = {}
local lua_globals = {}

if string.find(vim.fn.getcwd():lower(), "nvim") then
	-- Setup the environment for plugin development
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	lua_globals = { "vim" }

	-- TODO: Check if I need to exclude some plugins and adjust this table
	lua_library = vim.api.nvim_get_runtime_file("", true)
else
	-- Usual lua application/module
	table.insert(runtime_path, "?.lua")
	table.insert(runtime_path, "?/init.lua")
	lua_library = {
		"/usr/local/bin/lua",
	}
end

-- This language server installed using homebrew
require("lspconfig").sumneko_lua.setup({
	cmd = { "/usr/local/Cellar/lua-language-server/2.5.3/bin/lua-language-server" },
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "lua" },
	rootPatterns = ".git/",
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = lua_globals,
			},
			workspace = {
				library = lua_library,
				useGitIgnore = true,
			},
			telemetry = {
				enable = false,
			},
			completion = {
				showWord = "Disable",
			},
		},
	},
})

-- Custom diagnostics signs. Requires one of the nerd-fonts
local signs = {
	Error = "ﰸ",
	Warn = "",
	Hint = "",
	Info = "",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end
