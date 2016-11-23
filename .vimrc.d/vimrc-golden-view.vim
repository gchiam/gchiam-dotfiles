scriptencoding utf-8


" Always have a nice view for vim split windows!
" https://github.com/zhaocai/GoldenView.Vim
"
let g:goldenview__enable_default_mapping = 0
let g:goldenview__enable_at_startup = 1


" Split to tiled windows
nmap <M-g>  <Plug>GoldenViewSplit

" Quickly switch current window with the main pane and toggle back
nmap <M-m> <Plug>GoldenViewSwitchMain
nmap <M-t> <Plug>GoldenViewSwitchToggle

nmap <M-l> <Plug>GoldenViewSwitchWithLargest
nmap <M-s> <Plug>GoldenViewSwitchWithSmallest

" Jump to next and previous window
nmap <leader>n <Plug>GoldenViewNext
nmap <leader>p <Plug>GoldenViewPrevious
nmap <M-tab> <Plug>GoldenViewNext

"
nmap <F5> <Plug>GoldenViewResize
