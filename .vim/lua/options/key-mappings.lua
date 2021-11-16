vim.g.mapleader = " "  -- rebind <Leader> key
nmap('.', '<NOP>')

-- disable formatting when pasting large chunks of code
opt.pastetoggle = '<F2>'


--  Open and Save
--  =============
nmap('<Leader>w', ':update<CR>')
vmap('<Leader>w', '<C-C>:update<CR>')


--  Quick quit command
--  ==================
nmap('<Leader>q', '<esc>:quit<CR>')
nmap('<Leader>Q', '<esc>:quitall<CR>')


--  Bind nohl
--  =========
nmap('//',  ':nohl<CR>')


--  easier formatting of paragraphs
--  ===============================
vmap('Q', 'gq')
nmap('Q', 'gqap')


--  Use tab and shift-tab to cycle through windows.
--  http://howivim.com/2016/andy-stewart/
nmap('<Tab>', '<C-W>w')
nmap('<S-Tab>', '<C-W>W')


--  Movement
--  ========
--  bind Ctrl+<movement> keys to move around the windows, instead of using
--  Ctrl+w + <movement>
--  Ctrl+h doesn't work under iTerm2 by default
--  See https://github.com/neovim/neovim/issues/2048#issuecomment-98307896
map('<c-j>', '<c-w>j')
map('<c-k>', '<c-w>k')
map('<c-l>', '<c-w>l')
map('<c-h>', '<c-w>h')

--  Move to begining of line
nmap(',',  '^')
--  Move to end of line
nmap('.', '$')

--  switch between tabs with Meta+1, Meta+2,...
map('<M-1>', '1gt')
map('<M-2>', '2gt')
map('<M-3>', '3gt')
map('<M-4>', '4gt')
map('<M-5>', '5gt')
map('<M-6>', '6gt')
map('<M-7>', '7gt')
map('<M-8>', '8gt')
map('<M-9>', '9gt')


--  Resize pane
--  ==========
cmd([[
  if bufwinnr(1)
    map + <C-W>>
    map - <C-W><
    map <M-+> 5<C-W>>
    map <M--> 5<C-W><
  endif
]])


--  Tab
--  ===
map('<Leader>,', '<esc>:tabprevious<CR>')
map('<Leader>.', '<esc>:tabnext<CR>')

map('<Leader>[', '<esc>:lprevious<CR>')
map('<Leader>]', '<esc>:lnext<CR>')


--  Window spliting
--  ==============
nmap('<leader>|', ':vs<CR>')
nmap('<leader>\\', ':vs<CR>')
nmap('<leader>-', ':split<CR>')


--  Custom mappings
--  ===============
vmap('<', '<gv')  --  better indentation
vmap('>', '>gv')  --  better indentation
map('<Leader>a', 'ggVG')  --  select all


--  Current line & column mappings
--  ==============================
nmap('<Leader>C', ':set cursorline! cursorcolumn!<CR>')


--  center the cursor vertically
--  ============================
nmap('<Leader>zz', ':let &scrolloff=999-&scrolloff<CR>')


--  Diff mappings
--  =============
nmap('<Leader><Leader>d', '<esc>:diffthis<CR> <esc>:set nocursorline nocursorcolumn<CR>')
nmap('<Leader><Leader>D', '<esc>:diffoff<CR> <esc>:set cursorline cursorcolumn<CR>')


--  Shift-hjkl for split resizing
--  http://www.vimbits.com/bits/562
--  -------------------------------

-- Tmux-like window resizing
cmd([[
  function! IsEdgeWindowSelected(direction)
    let l:curwindow = winnr()
    exec 'wincmd '.a:direction
    let l:result = l:curwindow == winnr()

    if (!l:result)
        -- Go back to the previous window
        exec l:curwindow.'wincmd w'
    endif

    return l:result
  endfunction

  function! GetAction(direction)
    let l:keys = ['h', 'j', 'k', 'l']
    let l:actions = ['vertical resize -', 'resize +', 'resize -', 'vertical resize +']
    return get(l:actions, index(l:keys, a:direction))
  endfunction

  function! GetOpposite(direction)
    let l:keys = ['h', 'j', 'k', 'l']
    let l:opposites = ['l', 'k', 'j', 'h']
    return get(l:opposites, index(l:keys, a:direction))
  endfunction

  function! TmuxResize(direction, amount)
    -- v >
    if (a:direction ==# 'j' || a:direction ==# 'l')
        if IsEdgeWindowSelected(a:direction)
            let l:opposite = GetOpposite(a:direction)
            let l:curwindow = winnr()
            exec 'wincmd '.l:opposite
            let l:action = GetAction(a:direction)
            exec l:action.a:amount
            exec l:curwindow.'wincmd w'
            return
        endif
    -- < ^
    elseif (a:direction ==# 'h' || a:direction ==# 'k')
        let l:opposite = GetOpposite(a:direction)
        if IsEdgeWindowSelected(l:opposite)
            let l:curwindow = winnr()
            exec 'wincmd '.a:direction
            let l:action = GetAction(a:direction)
            exec l:action.a:amount
            exec l:curwindow.'wincmd w'
            return
        endif
    endif

    let l:action = GetAction(a:direction)
    exec l:action.a:amount
  endfunction
]])

-- Map to Ctrl+hjkl to resize panes
map('<M-S-h>', ':call TmuxResize("h", 1)<CR>')
nmap('<M-S-j>', ':call TmuxResize("j", 1)<CR>')
nmap('<M-S-k>', ':call TmuxResize("k", 1)<CR>')
nmap('<M-S-l>', ':call TmuxResize("l", 1)<CR>')


nmap('<silent>', '<c-]> <cmd>lua vim.lsp.buf.definition()<CR>')
nmap('<silent>', 'K     <cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<silent>', 'gD    <cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('<silent>', '<c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>')
nmap('<silent>', '1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>')
nmap('<silent>', 'gr    <cmd>lua vim.lsp.buf.references()<CR>')
nmap('<silent>', 'g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>')
nmap('<silent>', 'gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
nmap('<silent>', 'gd    <cmd>lua vim.lsp.buf.declaration()<CR>')

