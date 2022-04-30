-- Installing a treesitter grammar for this file format requires a compiler with c++14 support
-- On MacOS call
-- CC="g++ -std=c++14" nvim -c "TSInstall norg"

require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.norg.concealer"] = {},
		["core.gtd.base"] = {
			config = {
				workspace = "tasks",
			},
		},
		["core.norg.dirman"] = {
			config = {
				workspaces = {
					notes = "~/Projects/org/notes",
					tasks = "~/Projects/org/tasks",
				},
			},
		},
	},
})
