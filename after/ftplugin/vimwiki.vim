" Navigate to next link, either Vimwiki link or URL
nnoremap <C-h> :set nohlsearch<CR>?\[\[.*\]\]\\|http<CR>
nnoremap <C-l> :set nohlsearch<CR>/\[\[.*\]\]\\|http<CR>

nnoremap ? :set hlsearch<CR>:noh<CR>?
nnoremap / :set hlsearch<CR>:noh<CR>/

