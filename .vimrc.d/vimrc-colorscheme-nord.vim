scriptencoding utf-8

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
let g:nord_bold_vertical_split_line = 1

let g:lightline_colorscheme = 'nord'

" The original comment hilighlight is too light
autocmd ColorScheme nord highlight Comment guifg=#B48EAD

" au ColorScheme nord highlight Normal guibg=None
colorscheme nord
