" Settings for Neomake
" ===================
let g:neomake_open_list = 2
map <F7> <esc>:Neomake<CR>
let g:neomake_python_pylama_maker = {
    \ 'args': [
    \   '--verbose',
    \   '--linters="pep8,pylint,pyflakes,pep257,mccabe"',
    \   '--ignore=W191,D203,D206,C0330,W0312'
    \   ],
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
let g:neomake_python_enabled_makers = ['pylama', 'pep8', 'pylint', 'pyflakes']
autocmd! BufWritePost * Neomake
