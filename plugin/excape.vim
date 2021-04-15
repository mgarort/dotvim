" This plugin contains useful functions and commands for navigating the ExCAPE
" database


" Function to Search Excape for a gene
function! SearchExcape(gene)
    let @/='\t\<' . a:gene . '\>\t'
    call feedkeys('n')
endfunction
com -nargs=* SE call SearchExcape(<f-args>)
nnoremap gs :SE<space>
