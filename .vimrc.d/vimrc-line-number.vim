scriptencoding utf-8


" Setting for displaying line numbers
" ===================================

" Awesome line number magic
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber number
  endif
  set invnumber
  if(&number == 1)
    set number relativenumber
  endif
endfunc

nnoremap <Leader>l :set relativenumber!<cr>
nnoremap <Leader>L :call NumberToggle()<cr>
:au FocusLost * set norelativenumber number
:au FocusGained * set relativenumber number
autocmd InsertEnter * set norelativenumber number
autocmd InsertLeave * set relativenumber number
set number relativenumber
