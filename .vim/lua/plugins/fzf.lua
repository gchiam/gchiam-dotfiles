-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- https://github.com/junegunn/fzf.vim

use "junegunn/fzf"
use "junegunn/fzf.vim"

local opts = { noremap=true, silent=true }

--  File Finder
vim.api.nvim_set_keymap("n", "<Leader>f", "<cmd>:GFiles<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>F", "<cmd>:Files<CR>", opts)
--  Buffer Finder
vim.api.nvim_set_keymap("n", "<Leader>b", "<cmd>:Buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>h", "<cmd>:History<CR>", opts)

--  Tag Finder
vim.api.nvim_set_keymap("n", "<Leader>t", "<cmd>:BTags<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>T", "<cmd>:Tags<CR>", opts)

--  Line Finder
vim.api.nvim_set_keymap("n", "<Leader>l", "<cmd>:BLines<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>L", "<cmd>:Lines<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>'", "<cmd>:Marks<CR>", opts)

--  Project Finder
vim.api.nvim_set_keymap("n", "<Leader>/", "<cmd>:Ag<Space>", opts)

--  Help Finder
vim.api.nvim_set_keymap("n", "<Leader>H", "<cmd>:Helptags!<CR>", opts)

--  Command Finder
vim.api.nvim_set_keymap("n", "<Leader>c", "<cmd>:Commands<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>:", "<cmd>:History:<CR>", opts)

--  Key Mapping Finder
vim.api.nvim_set_keymap("n", "<Leader>M", "<cmd>:Maps<CR>", opts)

--  Misc
vim.api.nvim_set_keymap("n", "<Leader>S", "<cmd>:Filetypes<CR>", opts)
