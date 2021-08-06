-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- Setting for displaying line numbers
-- ===================================

vim.cmd "nnoremap <Leader>l :set relativenumber!<cr>"
vim.cmd ":augroup FocusLost * set norelativenumber number"
vim.cmd ":augroup FocusGained * set relativenumber number"
vim.cmd "autocmd InsertEnter * set norelativenumber number"
vim.cmd "autocmd InsertLeave * set relativenumber number"

vim.opt.number = true
vim.opt.relativenumber = true
