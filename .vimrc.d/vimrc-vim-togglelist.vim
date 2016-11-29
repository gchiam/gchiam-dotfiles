scriptencoding utf-8

" milkypostman/vim-togglelist
" https://github.com/milkypostman/vim-togglelist
"
" Functions to toggle the [Location List] and the [Quickfix List] windows.
" =============================================================================
"

let g:toggle_list_no_mappings = 1

nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>f :call ToggleQuickfixList()<CR>
