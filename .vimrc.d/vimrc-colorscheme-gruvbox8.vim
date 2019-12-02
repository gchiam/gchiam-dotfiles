scriptencoding utf-8


" au ColorScheme gruvbox highlight ALEErrorSign ctermfg=1 ctermbg=1 guifg=#cc241d guibg=#3c3836
" au ColorScheme gruvbox highlight ALEWarningSign ctermfg=1 ctermbg=1 guifg=#d79921 guibg=#3c3836
" au ColorScheme gruvbox highlight link agsvLineNumMatch GruvboxYellowBold


let g:gruvbox_italic=1
let g:gruvbox_italicize_comments=1
let g:gruvbox_italicize_strings=1
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1

let g:gruvbox_contrast_light='soft'
let g:gruvbox_contrast_dark='soft'

let g:gruvbox_improved_strings=0
let g:gruvbox_improved_warnings=1

let g:gruvbox_invert_selection=0
let g:gruvbox_invert_signs=0
let g:gruvbox_invert_tabline=1

let g:gruvbox_color_column='bg1'
let g:gruvbox_number_column="bg0"
let g:gruvbox_sign_column='bg1'
let g:gruvbox_vert_split='bg1'


colorscheme gruvbox8

" highlight! link VertSplit GruvboxBg0


" if has('nvim')
"   " dark0 + gray
"   let g:terminal_color_0 = "#32302F"
"   let g:terminal_color_8 = "#928374"

"   " neurtral_red + bright_red
"   let g:terminal_color_1 = "#cc241d"
"   let g:terminal_color_9 = "#fb4934"

"   " neutral_green + bright_green
"   let g:terminal_color_2 = "#98971a"
"   let g:terminal_color_10 = "#b8bb26"

"   " neutral_yellow + bright_yellow
"   let g:terminal_color_3 = "#d79921"
"   let g:terminal_color_11 = "#fabd2f"

"   " neutral_blue + bright_blue
"   let g:terminal_color_4 = "#458588"
"   let g:terminal_color_12 = "#83a598"

"   " neutral_purple + bright_purple
"   let g:terminal_color_5 = "#b16286"
"   let g:terminal_color_13 = "#d3869b"

"   " neutral_aqua + faded_aqua
"   let g:terminal_color_6 = "#689d6a"
"   let g:terminal_color_14 = "#8ec07c"

"   " light4 + light1
"   let g:terminal_color_7 = "#a89984"
"   let g:terminal_color_15 = "#ebdbb2"
" endif


" " https://github.com/morhetz/gruvbox/wiki/Usage
" nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
" nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
" nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

" nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
" nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
" nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?
