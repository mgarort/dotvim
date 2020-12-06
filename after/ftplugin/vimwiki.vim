" Functions and keybindings to navigate to next link, 
" either Vimwiki link or URL

function! SearchNextLink()
    " Get line number and column
    let [lnum, col] = searchpos('\[\[.*\]\]\|http', 'n') 
    call setpos('.', [0, lnum, col, 0])
endfunction
function! SearchPreviousLink()
    " Get line number and column
    let [lnum, col] = searchpos('\[\[.*\]\]\|http', 'bn') 
    call setpos('.', [0, lnum, col, 0])
endfunction

nnoremap <C-h> :call SearchPreviousLink()<CR>
nnoremap <C-l> :call SearchNextLink()<CR>
