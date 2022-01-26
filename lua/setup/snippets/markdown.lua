local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node

return {
	snippet("date", {
		name = "Date",
		dscr = "Insert the current date in ISO8601 format",
		text(os.date("!%Y-%m-%dT%TZ")),
	}),
}
