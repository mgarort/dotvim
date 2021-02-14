" Configure <CR> for choosing from an autocomplete list in Vimwiki, while
" keeping the native Vimwiki <CR> in insert, which is useful for writing lists
" with several levels.
" Autocommand from section "8. Lists" in the Vimwiki docs
inoremap <expr><buffer> <CR> pumvisible() ? '<Esc>a' : '<C-]><Esc>:VimwikiReturn 3 5<CR>'
