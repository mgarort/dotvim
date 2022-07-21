" Your configuration maps <C-w>z to ZoomInCurrentWindow()
" in normal mode. However, sometimes it also gets mapped
" in terminal mode. This affects the fzf popup window, as
" mentioned here https://github.com/junegunn/fzf.vim/issues/1176
" The result is that pressing <C-w> to delete the last typed
" word doesn't work until after waiting for 1s of inactivity
" (since Vim waits to see if it receives a further z). The
" solution is to unmap <C-w> in terminal mode
tunmap <C-w>z
