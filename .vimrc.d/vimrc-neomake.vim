" Settings for Neomake
" ===================
let g:neomake_open_list = 2
map <F7> <esc>:Neomake<CR>
map <F9> <esc>:NeomakeSh ./invoke testpy<CR>
let g:neomake_python_pylama_maker = {
    \ 'args': ['--verbose', '--linters="flake8,pep257,mccabe"', '--ignore=W191,D206'],
    \ }
autocmd! BufWritePost * Neomake
