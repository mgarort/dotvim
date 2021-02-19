" Configure <CR> for choosing from an autocomplete list in Vimwiki, while
" keeping the native Vimwiki <CR> in insert, which is useful for writing lists
" with several levels.
" Autocommand from section "8. Lists" in the Vimwiki docs
inoremap <expr><buffer> <CR> pumvisible() ? '<Esc>a' : '<C-]><Esc>:VimwikiReturn 3 5<CR>'

" Map the <Plug> commands that interfere with <C-l>. Needs to be done here
" because in ftplugin/vimwiki.vim there is an error when unmapping that there is no such
" mappings. This is presumably because at the time ftplugin is sourced those
" mappings haven't been created by Vimwiki, but at the time after is sourced
" they have
" Declared silent to avoid errors, as explained here 
" https://stackoverflow.com/questions/16218151/how-do-i-unmap-only-when-a-mapping-exists-in-vim
silent! iunmap <buffer> <C-l><CR>
silent! iunmap <buffer> <C-l><C-k>
silent! iunmap <buffer> <C-l><NL>
imap <C-g><C-g> <Plug>VimwikiListToggle
imap <C-g><C-k> <Plug>VimwikiListPrevSymbol
imap <C-g><C-j> <Plug>VimwikiListNextSymbol
