local util = require("lspconfig.util")

-- npm install -g @tailwindcss/language-server
return function(capabilites, on_attach)
	require("lspconfig").tailwindcss.setup({
		capabilities = capabilites,
		on_attach = on_attach,
		root_dir = function(fname)
			return util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts")(fname)
				or util.root_pattern("postcss.config.js", "postcss.config.cjs", "postcss.config.ts")(fname)
				or util.find_package_json_ancestor(fname)
				or util.find_node_modules_ancestor(fname)
				or util.find_git_ancestor(fname)
		end,
	})
end
