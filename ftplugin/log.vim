" Do not accidentally write or modify log files
setlocal readonly
setlocal nomodifiable
" Do not fold
setlocal nofoldenable

set wrap


" t for viewing in table format
function! ViewTable()
    set nowrap
    set nowrite
    RainbowAlign
endfunction
nnoremap ,t :call ViewTable()<CR>
