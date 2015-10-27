" vimrc files
" ===========

autocmd! bufwritepost .vimrc source %
autocmd! bufwritepost vimrc-*.vim source %
"
" reload .vimrc file
" =========================
map <Leader>v :source ~/.vimrc<CR>
