function! CopyCellToIPython()
    " Copy cell (delimited by ##{ and ##}) to register t
    exe '?##{?+1;/##}/-1y t'
    " Move to bottom window (where the terminal is)
    call feedkeys("\<C-w>j")
    " Paste register t to IPython command line and move back
    " to previous window
    " 1. Prepare iPython to receive several lines of code, rather than
    " executing after the first line
    call feedkeys("%cpaste\<CR>")
    " For some reason, after %cpaste it is not possible to copy directly.
    " So we first change windows and then copy
    call feedkeys("\<C-w>k")
    call feedkeys("\<C-w>j")
    " 2. Paste register t
    call feedkeys("\<C-w>\"t")
    " 3. Indicate to iPython that this is the last line of code
    call feedkeys("--\<CR>")
    " Return to previous window and move to end of copied cell
    " ( '] indicates the end of the yanked text)
    call feedkeys("\<C-w>k")
    execute "normal! ']"
    " Move three line down
    execute "normal! 3j"
endfunction

nnoremap <C-b> :call CopyCellToIPython()<CR>
