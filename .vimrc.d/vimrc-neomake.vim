scriptencoding utf-8


" Settings for Neomake
" ===================
let g:neomake_open_list = 2

nnoremap <F7> :Neomake<CR>
inoremap <F7> <C-O>:Neomake<CR>
vnoremap <F7> :Neomake<CR>

let g:neomake_python_pylama_maker = {
    \ 'args': [
    \   '--format=pep8',
    \   '--linters=pep8,pylint,pep257,mccabe',
    \   '--ignore=W191,D203,D206,C0330,W0312'
    \   ],
    \ 'errorformat': '%f:%l:%c: %t%m',
    \ }
let g:neomake_python_pep8_maker = {
    \ 'args': [
    \   '--ignore=W191'
    \   ],
    \ }
let g:neomake_python_pylint_maker = {
    \ 'args': [
    \   '--ignore=C0330,W0312'
    \   ],
    \ }
" let g:neomake_python_enabled_makers = ['python', 'frosted', 'pylama' ]
augroup my_neomake
    autocmd! BufWritePost * Neomake
    autocmd ColorScheme * hi NeomakeWarningSign ctermfg=yellow
augroup END
