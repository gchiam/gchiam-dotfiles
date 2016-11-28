scriptencoding utf-8


" Settings for vim-easymotion
" ===========================
let g:EasyMotion_do_mapping = 1 " Disable default mappings

map <Leader>m <Plug>(easymotion-prefix)

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader><leader>j <Plug>(easymotion-j)
map <Leader><leader>k <Plug>(easymotion-k)
