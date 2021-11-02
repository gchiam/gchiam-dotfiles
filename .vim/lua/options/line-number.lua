-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- Setting for displaying line numbers
-- ===================================

nmap('<Leader>l', ':set relativenumber!<CR>')

cmd("augroup FocusLost * set norelativenumber number")
cmd("augroup FocusGained * set relativenumber number")
cmd("autocmd InsertEnter * set norelativenumber number")
cmd("autocmd InsertLeave * set relativenumber number")

opt.number = true
opt.relativenumber = true
