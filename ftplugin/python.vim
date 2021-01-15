" Command to copy contents of cell
function! CopyCell()
    " Save content of clipboard in unused register
    let @z = getreg('+')
    " Copy cell (delimited by ##{ and ##}) to clipboard
    let @+ = ''
    exe '?##{?+1;/##}/-1y +'
    " Paste clipboard to IPython command line, using IPython's %paste magic
    wincmd j
    call term_sendkeys(bufnr("%"), "%paste\<CR>")
    wincmd k
    " Move to the last character of the previously yanked text (copied from
    " vim-cellmode)
    execute "normal! ']"
    " Move three line down
    execute "normal! 3j"
    " Recover the content of the clipboard (cannot do this because the
    " terminal is executed after recovering the clipboard)
    "echo getreg('+')
    "let @+ = getreg('z')
endfunction
nnoremap <silent> <C-b> <Down>:call CopyCell()<CR>
