-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:


-- Show trailing whitespace
cmd "highlight ExtraWhitespace ctermbg=red guibg=red"
cmd "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red"

opt.listchars = {
  space = ' ',
  tab = '→ ',
  trail = "·",
  extends = "⟩",
  precedes = "⟨"
}
opt.list = true

cmd "au InsertEnter * match ExtraWhitespace /\\s\\+\\%#\\@<!$/"
cmd "au InsertLeave * match ExtraWhitespace /\\s\\+$/"

cmd "match ErrorMsg '\\s\\+$'"
cmd "map <Leader>x :%s/\\s\\+$//"
