-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- Setting for displaying line numbers
-- ===================================

local opts = { noremap=true, silent=false }

vim.api.nvim_set_keymap('n', '<Leader>l', ':set relativenumber!<CR>', opts)

vim.cmd ":augroup FocusLost * set norelativenumber number"
vim.cmd ":augroup FocusGained * set relativenumber number"
vim.cmd "autocmd InsertEnter * set norelativenumber number"
vim.cmd "autocmd InsertLeave * set relativenumber number"

vim.opt.number = true
vim.opt.relativenumber = true
