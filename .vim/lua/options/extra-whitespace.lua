-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:


-- Show trailing whitespace
vim.cmd "highlight ExtraWhitespace ctermbg=red guibg=red"
vim.cmd "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red"

vim.opt.listchars = {
  space = '_',
  tab = '→ ',
  trail = "·",
  extends = "⟩",
  precedes = "⟨"
}
vim.opt.list = true

vim.cmd "au InsertEnter * match ExtraWhitespace /\\s\\+\\%#\\@<!$/"
vim.cmd "au InsertLeave * match ExtraWhitespace /\\s\\+$/"

vim.cmd "match ErrorMsg '\\s\\+$'"
vim.cmd "map <Leader>x :%s/\\s\\+$//"
