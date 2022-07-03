" Unmap <leader>c commands
" Otherwise pressing <leader>c to go to the i3 config
" takes 1 second (since Vim is waiting for possible
" calendar mappings, for example for an extra "al"
" to complete <leader>cal(
map <leader><leader><leader><leader><leader>bLbab <Plug>CalendarH
map <leader><leader><leader><leader><leader>a8oie <Plug>CalendarV
unmap <leader>cal
unmap <leader>caL
