" Always have a nice view for vim split windows!
" https://github.com/zhaocai/GoldenView.Vim


" Split to tiled windows
nmap <silent> <C-M-G>  <Plug>GoldenViewSplit

" Quickly switch current window with the main pane and toggle back
nmap <silent> <F8> <Plug>GoldenViewSwitchMain
nmap <silent> <F9> <Plug>GoldenViewSwitchToggle

" Jump to next and previous window
nmap <silent> <C-M-N>  <Plug>GoldenViewNext
nmap <silent> <C-M-P>  <Plug>GoldenViewPrevious

"
nmap <silent> <F5> <Plug>GoldenViewResize
