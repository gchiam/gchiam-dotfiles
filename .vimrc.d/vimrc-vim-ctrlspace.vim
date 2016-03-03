" https://github.com/vim-ctrlspace/vim-ctrlspace
"
"
" Glob Command
" Another important setting is the Glob command. This command is used to
" collect all files in your project directory. Specifically, ag is recommended,
" as it respects .gitignore rules and is really fast.
if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif


" Search Timing
" If you usually have to deal with huge projects having 100 000 files you can
" increase plugin fuzzy search delay to make it even more responsible by
" providing a higher g:CtrlSpaceSearchTiming value:
let g:CtrlSpaceSearchTiming = 500


" Automatically Saving Workspace
" Ctrl-Space can automatically save your workspace status based on
" configurations below:
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1


" key mapping
nnoremap <silent><C-o> :CtrlSpace O<CR>
nnoremap <silent><C-S-o> :CtrlSpace o<CR>
nnoremap <silent><C-l> :CtrlSpace L<CR>
nnoremap <silent><C-S-l> :CtrlSpace l<CR>
nnoremap <silent><C-h> :CtrlSpace H<CR>
nnoremap <silent><C-S-h> :CtrlSpace h<CR>
