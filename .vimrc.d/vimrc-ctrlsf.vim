scriptencoding utf-8

" https://github.com/dyng/ctrlsf.vim


let g:ctrlsf_mapping = {
    \ 'open'    : ['<CR>', 'o'],
    \ 'openb'   : 'O',
    \ 'split'   : '<C-O>',
    \ 'vsplit'  : '<C-V>',
    \ 'tab'     : 't',
    \ 'tabb'    : 'T',
    \ 'popen'   : 'p',
    \ 'popenf'  : 'P',
    \ 'quit'    : 'q',
    \ 'next'    : '<C-J>',
    \ 'prev'    : '<C-K>',
    \ 'pquit'   : 'q',
    \ 'loclist' : '',
    \ 'chgmode' : 'M',
    \ }

nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

let g:ctrlsf_auto_close = 0
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_populate_qflist = 1
