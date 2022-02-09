-- https://github.com/nvim-telescope/telescope.nvim-telescope

use "nvim-telescope/telescope.nvim"

nmap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>")
nmap("<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
nmap("<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>")
nmap("<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>")
