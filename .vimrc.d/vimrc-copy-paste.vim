" Settings for Copy & Paste
" =========================

" make yank copy to the global system clipboard
set clipboard=unnamed


" Fixing the copy & paste madness
" ================================
vmap <C-y> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("0 xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a



" http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" Copy & paste to system clipboard with <Space>p and <Space>y:
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P


" http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" Automatically jump to end of text you pasted:
" paste multiple lines multiple times with simple ppppp.
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
