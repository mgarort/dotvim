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
" Jumping between links will create an entry in the jumplist with m'
nnoremap <silent> <C-h> m':call SearchPreviousLink()<CR>
nnoremap <silent> <C-l> m':call SearchNextLink()<CR>



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


" Keep indentation level while wrapping lines
set breakindent
" Don't break lines in the middle of words
set linebreak
