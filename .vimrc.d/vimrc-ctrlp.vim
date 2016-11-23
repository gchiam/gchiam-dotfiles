scriptencoding utf-8


" Settings for ctrlp
" ===================
let g:ctrlp_max_height = 30
" http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" configures CtrlP to use git or silver searcher for autocompletion
let g:ctrlp_use_caching = 0

let g:ctrlp_working_path_mode = 'ra'
" 'c' - the directory of the current file.
" 'r' - the nearest ancestor that contains one of these directories or files:
"       .git .hg .svn .bzr _darcs
" 'a' - like c, but only if the current working directory outside of CtrlP
"       is not a direct ancestor of the directory of the current file.
" 0 or '' (empty string) - disable this feature.


let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

if executable('rg')
  set grepprg=rg\ --no-heading\ --color=none
  let g:ctrlp_user_command = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" %s'
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -S --nocolor --hidden -g ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif
