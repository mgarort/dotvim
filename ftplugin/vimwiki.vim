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
nnoremap <silent> <C-h> :call SearchPreviousLink()<CR>
nnoremap <silent> <C-l> :call SearchNextLink()<CR>



" Customize fzf colors to ensure that they match the Vimwiki colorscheme
" For more info check https://github.com/junegunn/fzf/blob/master/README-VIM.md#explanation-of-gfzf_colors
" Do it in ftplugin because this makes it prettier for Vimwiki but makes it
" uglier in the general case
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['bg', 'Exception'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['bg', 'Exception'],
  \ 'gutter':  ['bg', 'Normal'],
  \ 'query':   ['fg', 'Normal'] }

