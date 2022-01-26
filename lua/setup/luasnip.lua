local ls = require("luasnip")
local files_in_folder = require("utils").files_in_folder

for _, filetype in ipairs(files_in_folder({ "setup", "snippets" })) do
	ls.snippets[filetype] = require(string.format("setup.snippets.%s", filetype)) or {}
end

require("luasnip.loaders.from_vscode").load()
