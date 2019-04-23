scriptencoding utf-8


syntax enable

" au ColorScheme * highlight Normal guibg=None ctermbg=None
" au ColorScheme * highlight NonText ctermfg=241 guifg=#5c6370 guibg=None ctermbg=None
" au ColorScheme * highlight Whitespace ctermfg=241 guifg=#5c6370 guibg=None ctermbg=None

let g:lightline_colorscheme = "onehalfdark"


if (has("termguicolors"))
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme onehalfdark
