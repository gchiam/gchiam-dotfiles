" Mapping keys to set python breakpoints
" "======================================
map <Leader>B Oimport ipdb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>
map <Leader>b Oimport pudb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>
map <Leader><c-b> Oimport pdb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>


if has("unix")
  let s:uname = system("uname")
  let g:python_host_prog='/usr/bin/python'
  "if s:uname == "Darwin\n"
  ""  let g:python_host_prog='/usr/local/bin/python' # found via `which python`
  "endif
endif
