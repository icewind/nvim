-- Formatting options for markdown files
local opt = vim.opt

-- Enable soft wrap
opt.wrap = true
opt.linebreak = true
opt.showbreak = "⏐"

-- Remap for dealing with word wrap
-- WARNING: These mappings are messing up the jumplist
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, noremap = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, noremap = true })
