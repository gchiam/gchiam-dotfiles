scriptencoding utf-8


" Auto switch to insert mode in terminal
augroup termgroup
    au BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END
