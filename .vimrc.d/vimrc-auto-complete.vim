scriptencoding utf-8


" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType css set omnifunc=csscomplete#CompleteCSS

set completeopt=menu,menuone,noinsert,preview

augroup gchiam_cm
    autocmd BufEnter <buffer> inoremap <expr> <buffer> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
    autocmd BufEnter <buffer> set completeopt=menu,menuone,noinsert,noselect
augroup END

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
