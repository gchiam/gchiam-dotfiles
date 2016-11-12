" https://github.com/jhawthorn/fzy
"
"
function! FzyCommand(choice_command, vim_command)
  try
    let l:output = system(a:choice_command . ' | fzy ')
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(l:output)
    exec a:vim_command . ' ' . l:output
  endif
endfunction


let g:ag_command = "ag -S l --nocolor --hidden -g ''"

nnoremap <leader>E :call FzyCommand("ag -S --nocolor --hidden -g ''", ":e")<cr>
nnoremap <leader>V :call FzyCommand(g:ag_command, ":vs")<cr>
nnoremap <leader>S :call FzyCommand(g:ag_command, ":sp")<cr>
