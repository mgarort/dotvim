" My fzf configuration defines a function :BuffersAll that lists both listed
" and unlisted buffers, similar to :Buffers which only lists buffers.
"
" This script implements a new global variable needed for :BuffersAll, and
" redefines an autocommand group so that it also works for :BuffersAll
"
" It copies a global variable and augroup already defined on
" dotvim/bundle/fzf.vim/plugin/fzf.vim
"
" This script should be placed on dotvim/plugin/fzf.vim
"
" The other two pieces of my customized fzf configuration are:
" - dotvim/own/fzf.vim
" - dotvim/own/preview.sh

" Same as g:fzf#vim#buffers but doesn't filter out unlisted buffers
if !exists('g:fzf#vim#buffers_all')
  let g:fzf#vim#buffers_all = {}
endif

" fzf floating window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
" fzf split layout at the bottom instead of floating window
" let g:fzf_layout = { 'down': '~40%' }
" Disable right window that previews the notes
let g:fzf_preview_window = []

augroup fzf_buffers
  autocmd!
  if exists('*reltimefloat')
    autocmd BufWinEnter,WinEnter * let g:fzf#vim#buffers[bufnr('')] = reltimefloat(reltime())
    autocmd BufWinEnter,WinEnter * let g:fzf#vim#buffers_all[bufnr('')] = reltimefloat(reltime())
  else
    autocmd BufWinEnter,WinEnter * let g:fzf#vim#buffers[bufnr('')] = localtime()
    autocmd BufWinEnter,WinEnter * let g:fzf#vim#buffers_all[bufnr('')] = localtime()
  endif
  autocmd BufDelete * silent! call remove(g:fzf#vim#buffers, expand('<abuf>'))
  autocmd BufDelete * silent! call remove(g:fzf#vim#buffers_all, expand('<abuf>'))
augroup END
