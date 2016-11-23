scriptencoding utf-8


" https://github.com/vim-ctrlspace/vim-ctrlspace
"
"
" Glob Command
" Another important setting is the Glob command. This command is used to
" collect all files in your project directory. Specifically, ag is recommended,
" as it respects .gitignore rules and is really fast.
if executable('rg')
    let g:CtrlSpaceGlobCommand = 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
elseif executable('ag')
    let g:CtrlSpaceGlobCommand = 'ag -S --nocolor --hidden --ignore-dir=.git -g ""'
endif


" Search Timing
" If you usually have to deal with huge projects having 100 000 files you can
" increase plugin fuzzy search delay to make it even more responsible by
" providing a higher g:CtrlSpaceSearchTiming value:
let g:CtrlSpaceSearchTiming = 100


" Automatically Saving Workspace
" Ctrl-Space can automatically save your workspace status based on
" configurations below:
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|Godeps)[\/]'

" key mappings
nnoremap <Leader><leader>o :CtrlSpace O<CR>
nnoremap <Leader><leader>l :CtrlSpace l<CR>
nnoremap <Leader><leader>h :CtrlSpace h<CR>
nnoremap <Leader><leader>b :CtrlSpace b<CR>
nnoremap <Leader><leader>b :CtrlSpace w<CR>
