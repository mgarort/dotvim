" Plugin with keybindings similar to readline in insert and command line modes


" -------------------------
" SECTION:  Insert mode
" ------------------------
"
" <F7> is bound to <A-Backspace> through a urxvt escape sequence
" inoremap <silent> <Plug>(i_backward-kill-word) <C-g>u<Esc>:set iskeyword=@,48-57<CR>a<C-w><Esc>:set iskeyword=@,48-57,_,192-255,#<CR>a
inoremap <silent> <Plug>(i_backward-kill-word) <C-g>u<C-\><C-o>:set iskeyword=@,48-57<CR><C-w><C-\><C-o>:set iskeyword=@,48-57,_,192-255,#<CR>
imap <F7> <Plug>(i_backward-kill-word)

inoremap <silent> <Plug>(i_unix-word-rubout) <C-g>u<C-\><C-o>dB
imap <C-w> <Plug>(i_unix-word-rubout)
" TODO Create command line alternative, which will need to get the command
" line to be able to set and reset 'iskeyword'

inoremap <silent> <Plug>(i_beginning-of-line) <Esc>^i
imap <C-a> <Plug>(i_beginning-of-line)

inoremap <silent> <Plug>(i_end-of-line) <End>
imap <C-e> <Plug>(i_end-of-line)

" <F9> and <F10> are bound to <A-b> and <A-f> respectively through urxvt
" escape sequences.
inoremap <silent> <Plug>(i_backward-word) <S-Left>
imap <F9> <Plug>(i_backward-word)

inoremap <silent> <Plug>(i_forward-word) <S-Right>
imap <F10> <Plug>(i_forward-word)

inoremap <Plug>(i_unix-line-discard) <C-g>u<C-u>
imap <C-u> <Plug>(i_unix-line-discard)


" -------------------------
" SECTION:  Command line mode
" ------------------------

" Backward delete with different granularities by <Alt-BS>, <C-w> and <C-u>
cnoremap <F7> <C-w>
" TODO Create <Plug>(c_backward-kill-word) and <Plug>(c_unix-word-rubout), which will need to get the command
" line to be able to set and reset 'iskeyword'
" NOTE To get the command line you can use :h getcmdline()
cnoremap <Plug>(c_unix-line-discard) <C-g>u<C-u>
cmap <C-u> <Plug>(c_unix-line-discard)

" Open history of previous commands. :History: is part of fzf.vim
" History of previous commands with <C-r> (using :History command of fzf.vim)
" Similar to how <C-r> opens fzf in the command line
cnoremap <Plug>(c_fzf-history) History:<CR>
cmap <C-r> <Plug>(c_fzf-history)
" TODO This waits for timeoutlen because <C-r> in command line mode conflicts
" with pasting registers

" Beginning and end of line with <C-a> and <C-e>
cnoremap <Plug>(c_beginning-of-line) <C-b>
cmap <C-a> <Plug>(c_beginning-of-line)
" <C-e> goes to end of line by default

" Up and down with <C-p> and <C-n>
cnoremap <Plug>(c_previous-history) <Up>
cmap <C-p> <Plug>(c_previous-history)
cnoremap <Plug>(c_next-history) <Down>
cmap <C-n> <Plug>(c_previous-history)

" Backward and forward word <Alt-b> and <Alt-f>
" <F9> and <F10> are bound to <A-b> and <A-f> respectively through urxvt
" escape sequences.
cnoremap <Plug>(c_backward-word) <S-Left>
cmap <F9> <Plug>(c_backward-word)
cnoremap <Plug>(c_forward-word) <S-Right>
cmap <F10> <Plug>(c_forward-word)
