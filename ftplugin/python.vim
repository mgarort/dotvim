function! CopyCellToIPython()
    " Copy cell (delimited by ##{ and ##}) to register t
    exe '?##{?+1;/##}/-1y t'
    " Move to bottom window (where the terminal is)
    call feedkeys("\<C-w>j")
    " Paste register t to IPython command line and move back
    " to previous window
    " Type register t to IPython command. For this:
    " 1. Replace newlines by <CR> so that Vim types newlines
    let regt = getreg('t')
    let regt = substitute(regt,"\n","\<CR>",'g')
    " let regt2 = "hello\<CR>"
    " 2. Prepare iPython to receive several lines of code, rather than
    " executing after the first line
    call feedkeys("\<C-o>")
    " 3. Make Vim type the register t
    call feedkeys(regt)
    " 4. Indicate to iPython that this is the last line of code by adding an
    " extra newline
    call feedkeys("\<CR>")
    " Return to the top window
    call feedkeys("\<C-w>k")
    " Move to the last character of the previously yanked text 
    " (copied from vim-cellmode)
    execute "normal! ']"
    " Move three line down
    execute "normal! 3j"
endfunction
nnoremap <C-b> :call CopyCellToIPython()<CR>
