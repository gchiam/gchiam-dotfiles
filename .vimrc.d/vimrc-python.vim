scriptencoding utf-8


let g:python_highlight_all = 1

" Mapping keys to set python breakpoints
" "======================================
map <Leader>B Oimport ipdb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>
map <Leader>b Oimport pudb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>
map <Leader><c-b> Oimport pdb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>


if has("unix")
  let s:uname = system("uname")
  let g:python3_host_prog=$HOME . '/.pyenv/versions/neovim-py3/bin/python'
  let g:python2_host_prog=$HOME . '/.pyenv/versions/neovim-py2/bin/python'
  let g:python_host_prog=$HOME . '/.pyenv/versions/neovim-py2/bin/python'
  " let g:python_host_prog=$HOME . '/Envs/neovim-py2/bin/python'
  " if s:uname == "Darwin\n"
  "  let g:python_host_prog='/usr/local/bin/python'  " found via `which python`
  "endif
endif
