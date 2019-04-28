scriptencoding utf-8


" Extra Whitespace
" ================

" Show trailing whitespace
" =========================
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
"
" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
" if &listchars ==# 'eol:$'
"   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" endif
set listchars=eol:¬,tab:→\ ,trail:·,extends:⟩,precedes:⟨
set list                " Show problematic characters.

au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

match ErrorMsg '\s\+$'
map <Leader>x :%s/\s\+$//
