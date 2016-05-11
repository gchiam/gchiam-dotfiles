" Always have a nice view for vim split windows!
" https://github.com/zhaocai/GoldenView.Vim


" 1. split to tiled windows
nmap <silent> <C-M-G>  <Plug>GoldenViewSplit

" 2. quickly switch current window with the main pane and toggle back
nmap <silent> <C-M-F8> <Plug>GoldenViewSwitchMain
nmap <silent> <C-M-F9> <Plug>GoldenViewSwitchToggle

" 3. jump to next and previous window
nmap <silent> <C-M-N>  <Plug>GoldenViewNext
nmap <silent> <C-M-P>  <Plug>GoldenViewPrevious
