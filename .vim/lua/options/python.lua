vim.g.python_highlight_all = 1

cmd([[
  if has("unix")
    let s:uname = system("uname")
    let g:python3_host_prog=$HOME . '/.pyenv/versions/neovim-py3/bin/python'
    let g:python2_host_prog=$HOME . '/.pyenv/versions/neovim-py2/bin/python'
    let g:python_host_prog=$HOME . '/.pyenv/versions/neovim-py2/bin/python'
    "endif
  endif
]])
