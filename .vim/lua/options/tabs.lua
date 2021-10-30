local opt = vim.opt
local cmd = vim.api.nvim_command

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true

cmd("autocmd BufRead,BufNewFile *.py set tabstop=4 shiftwidth=4 softtabstop=4")
