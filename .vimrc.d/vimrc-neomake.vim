" Settings for Neomake
" ===================
let g:neomake_open_list = 2
map <F7> <esc>:Neomake<CR>
map <F9> <esc>:NeomakeSh ./invoke testpy<CR>
let g:neomake_python_pylama_maker = {
    \ 'args': ['--verbose', '--linters="pep8,pyflakes,pep257,mccabe"', '--ignore=W191,D100,D101,D102,D103'],
    \ }
autocmd! BufWritePost * Neomake
