" Keybinding for sourcing current Vim buffer
nnoremap ,s :source %<CR>


" Define keybindings for tab functionality
nnoremap <C-Up>    mt:tabnew %<CR>`t
nnoremap <C-Down>  mt:tabc<CR>`t
nnoremap <C-Left>  mt:tabp<CR>`t
nnoremap <C-Right> mt:tabn<CR>`t
