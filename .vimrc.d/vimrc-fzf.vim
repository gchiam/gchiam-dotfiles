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
nmap <Leader>s :Filetypes<CR>

