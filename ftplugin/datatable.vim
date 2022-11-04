" Do not accidentally write data files ending in .csv or .tsv
" (.csv and .tsv have been set set to filetype datatable)
" NOTE We cannot :set nomodifiable because then we could call the
" ViewTable() command from the rainbow_csv plugin
setlocal readonly

" Set nowrap automatically
setlocal nowrap

" t for viewing in table format
function! ViewTable()
    set nowrap
    set nowrite
    RainbowAlign
endfunction
nnoremap ,t :call ViewTable()<CR>
