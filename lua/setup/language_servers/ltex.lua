-- Grammar and style corrections using language tool(specifically ltex-ls)
-- ltex-ls manually downloaded from the Github

-- ltex-ls implements dictionaries management using non standard commands
-- they are not part of the lspconfig so must be implemented on the client side
-- it probably would be better to make this into a separate plugin... But I have not enough spare time to maintain it

local path_separator = package.config:sub(1, 1)
local dictionaries_path = table.concat({ vim.fn.stdpath("config"), "spell" }, path_separator)

-- It is worth to add this directory in your .gitignore to not add words from your potentially private documents to the
-- repository
if vim.fn.isdirectory(dictionaries_path) == 0 then
	os.execute("mkdir " .. dictionaries_path)
end

local language = "en-US"

-- Helper funcitons

---Get a words list from the LSP action arguments
---@param arguments table
local function get_words_from_args(arguments)
	-- Not really sure if there could be more than one argument and whether I need to process them.
	return arguments[1].words[language] or {}
end

local function get_dictionary_path(type)
	local filename = string.format("%s_%s.txt", language:gsub("%-", "_"), type)
	return table.concat({ dictionaries_path, filename }, path_separator)
end

-- Simple dictionary object. Could be extended to support workspace dictionaries
local Dictionary = {}
Dictionary.__index = Dictionary

function Dictionary:new(path)
	local instance = {
		path = path,
		words = {},
	}
	setmetatable(instance, self)
	instance.__index = self

	Dictionary.read(instance)

	return instance
end

function Dictionary:read()
	-- In case there is no file with words, we will create it only if needed(Something added).
	if vim.fn.filereadable(self.path) == 0 then
		return nil
	end
	for line in io.lines(self.path) do
		table.insert(self.words, line)
	end
end

function Dictionary:add(words)
	if type(words) ~= "table" then
		words = { words }
	end
	local file = io.open(self.path, "a")
	if file then
		for _, word in ipairs(words) do
			file:write(string.format("%s\n", word))
			table.insert(self.words, word)
		end
		file:close()
	else
		vim.notify("Error saving the dictionary file")
	end
end

local dictionaryType = {
	dictionary = "dictionary",
	disabled = "disabledRules",
	hidden = "hiddenFalsePositives",
}

-- Dictionaries
local dictionaries = {
	[dictionaryType.dictionary] = Dictionary:new(get_dictionary_path(dictionaryType.dictionary)),
	[dictionaryType.disabled] = Dictionary:new(get_dictionary_path(dictionaryType.disabled)),
	[dictionaryType.hidden] = Dictionary:new(get_dictionary_path(dictionaryType.hidden)),
}

-- Notify LSP client about updated configuration
local function notifyLSPClient(dict)
	local client = nil
	for _, lsp_client in ipairs(vim.lsp.buf_get_clients()) do
		if lsp_client.name == "ltex" then
			client = lsp_client
		end
	end
	if client == nil then
		return vim.notify("ltex LSP client not found for the current buffer")
	end
	if client.config.settings.ltex[dict] == nil then
		return vim.notify(string.format("Invalid dictionary type: %s", dict))
	end
	-- Acutally update the configuration of LSP client
	client.config.settings.ltex[dict] = {
		[language] = dictionaries[dict].words,
	}
	client.notify("workspace/didChangeConfiguration", client.config.settings)
end

-- LSP action handlers
local execute_command = vim.lsp.buf.execute_command
vim.lsp.buf.execute_command = function(command)
	local affected_dictionary = ""
	if command.command == "_ltex.addToDictionary" then
		affected_dictionary = dictionaryType.dictionary
	elseif command.command == "_ltex.disableRule" then
		affected_dictionary = dictionaryType.disabled
	elseif command.command == "_ltex.hideFalsePositives" then
		affected_dictionary = dictionaryType.hidden
	else
		return execute_command(command)
	end
	dictionaries[affected_dictionary]:add(get_words_from_args(command.arguments))
	return notifyLSPClient(affected_dictionary)
end

-- Attach the language server
return function(capabilities, on_attach)
	require("lspconfig").ltex.setup({
		cmd = { os.getenv("HOME") .. "/tools/ltex-ls/bin/ltex-ls" },
		capabilities = capabilities,
		on_attach = on_attach,
		trace = { server = "verbose" },
		settings = {
			ltex = {
				language = language,
				dictionary = {
					[language] = dictionaries[dictionaryType.dictionary].words,
				},
				disabledRules = {
					[language] = dictionaries[dictionaryType.disabled].words,
				},
				hiddenFalsePositives = {
					[language] = dictionaries[dictionaryType.hidden].words,
				},
			},
		},
	})
end
