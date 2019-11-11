set rtp+=/usr/local/opt/fzf


" https://medium.com/@jesseleite/its-dangerous-to-vim-alone-take-fzf-283bcff74d21
"
" File Finder
nmap <Leader>f :GFiles<CR>
nmap <Leader>F :Files<CR>

" Buffer Finder
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>

" Tag Finder
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>

" Line Finder
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>' :Marks<CR>

" Project Finder
nmap <Leader>/ :Ag<Space>

" Help Finder
nmap <Leader>H :Helptags!<CR>

" Command Finder
nmap <Leader>C :Commands<CR>
nmap <Leader>: :History:<CR>

" Key Mapping Finder
nmap <Leader>M :Maps<CR>

" Misc
nmap <Leader>S :Filetypes<CR>


let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-e': 'edit',
  \ 'enter': 'vsplit' }
let g:preview_height = float2nr(&lines * 0.6)
let $FZF_DEFAULT_OPTS=" --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:2,prompt:2,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4 --preview 'if file -i {}|grep -q binary; then file -b {}; else bat --style=changes --color always --line-range :40 {}; fi' --preview-window bottom:" . g:preview_height

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')
  call setbufvar(buf, '&number', 0)
  call setbufvar(buf, '&relativenumber', 0)

  let height = float2nr(&lines * 0.7)
  let width = float2nr(&columns * 0.5)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 2

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction
