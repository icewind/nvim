local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ','
vim.g.maplocalleader = ','

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Switch buffers
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")

--After searching, pressing escape stops the highlight
map("n", "<esc>", ":noh<cr><esc>", { silent = true })

-- Call the floaterm
-- This not currently works as expected since after you open a terminal there is no way to toggle it in MacOS...
-- map("n", "<F12>", ":FloatermToggle<CR>")

-- Hop(EasyMotion) for normal and visual modes
map("n", "<leader>s", "<cmd>lua require'hop'.hint_char1()<cr>")
map("v", "<leader>s", "<cmd>lua require'hop'.hint_char1()<cr>")

-- Symbols outline
map("n", "<leader>o", ":SymbolsOutline<cr>")

-- Filetree
map('n', '<M-b>', ':NvimTreeToggle<CR>')
map('n', '<leader>r', ':NvimTreeRefresh<CR>')
map('n', '<leader>n', ':NvimTreeFindFile<CR>')

-- Telescope
map("n", "<leader>p", '<cmd>lua require("telescope.builtin").find_files()<cr>')
map("n", "<leader>g", '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map("n", "<leader>b", '<cmd>lua require("telescope.builtin").buffers()<cr>')

map("n", "<leader>i", '<cmd>lua require("telescope.builtin").git_status()<cr>')

map("n", "<leader>ca", '<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>')
map("n", "<leader>cs", '<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>')
map("n", "<leader>cd", '<cmd>lua require("telescope.builtin").diagnostics{ bufnr=0 }<cr>')
map("n", "<leader>cr", '<cmd>lua require("telescope.builtin").lsp_references()<cr>')

-- Display diagnostics messages
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
