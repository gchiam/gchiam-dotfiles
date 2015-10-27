" Settings for Neomake
" ===================
let g:neomake_open_list = 1
map <F7> <esc>:Neomake<CR>
map <F9> <esc>:NeomakeSh ./invoke testpy<CR>
let g:neomake_python_pylama_maker = {
    \ 'args': ['--verbose', '--linters="pep8,pep257,mccabe"'],
    \ }
autocmd! BufWritePost * Neomake
