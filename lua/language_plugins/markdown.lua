-- Markdown preview
return function(use)
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		ft = { "markdown" },
		cmd = "MarkdownPreview",
	})
end
