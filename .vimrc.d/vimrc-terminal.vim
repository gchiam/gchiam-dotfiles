scriptencoding utf-8


augroup termgroup
    " Auto switch to insert mode in terminal
    au BufEnter * if &buftype == 'terminal' | :startinsert | endif

    au TermClose * bd!
augroup END
