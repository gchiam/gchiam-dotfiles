api = vim.api
cmd = vim.cmd
opt = vim.opt

function _map(mode, shortcut, command)
  api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function map(shortcut, command)
  _map('', shortcut, command)
end

function imap(shortcut, command)
  _map('i', shortcut, command)
end

function nmap(shortcut, command)
  _map('n', shortcut, command)
end

function smap(shortcut, command)
  _map('s', shortcut, command)
end

function vmap(shortcut, command)
  _map('v', shortcut, command)
end
