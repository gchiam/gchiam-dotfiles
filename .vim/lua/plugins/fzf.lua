-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- https://github.com/junegunn/fzf.vim

use "junegunn/fzf"
use "junegunn/fzf.vim"

--  File Finder
nmap("<Leader>f", "<cmd>:GFiles<CR>")
nmap("<Leader>F", "<cmd>:Files<CR>")
--  Buffer Finder
nmap("<Leader>b", "<cmd>:Buffers<CR>")
nmap("<Leader>h", "<cmd>:History<CR>")

--  Tag Finder
nmap("<Leader>t", "<cmd>:BTags<CR>")
nmap("<Leader>T", "<cmd>:Tags<CR>")

--  Line Finder
nmap("<Leader>l", "<cmd>:BLines<CR>")
nmap("<Leader>L", "<cmd>:Lines<CR>")
nmap("<Leader>'", "<cmd>:Marks<CR>")

--  Project Finder
nmap("<Leader>/", "<cmd>:Ag<Space>")

--  Help Finder
nmap("<Leader>H", "<cmd>:Helptags!<CR>")

--  Command Finder
nmap("<Leader>c", "<cmd>:Commands<CR>")
nmap("<Leader>:", "<cmd>:History:<CR>")

--  Key Mapping Finder
nmap("<Leader>M", "<cmd>:Maps<CR>")

--  Misc
nmap("<Leader>S", "<cmd>:Filetypes<CR>")
