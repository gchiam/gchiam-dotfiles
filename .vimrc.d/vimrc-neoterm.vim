" kassio/neoterm
" https://github.com/kassio/neoterm
"
" Use the same terminal for everything. The main reason for this plugin is
" reuse the terminal easily. All commands opens a terminal if it's not open or
" reuse the open terminal. REPL commands, opens a terminal and the proper REPL,
" if it's not opened.
"

filetype plugin on


let g:neoterm_position = 'horizontal'
let g:neoterm_automap_keys = ',tt'
let g:neoterm_repl_python = 'ptpython'

nnoremap <silent> <f10> :TREPLSendFile<cr>
nnoremap <silent> <f9> :TREPLSendLine<cr>
vnoremap <silent> <f9> :TREPLSendSelection<cr>


" Useful maps
" hide/close terminal
nnoremap <silent> ,th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> ,tc :call neoterm#kill()<cr>


" ptpython command
command! Tp :T ptpython


" Git commands
command! -nargs=+ Tg :T git <args:>
