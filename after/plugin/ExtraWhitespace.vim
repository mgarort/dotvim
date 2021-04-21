" This autocommand is also defined in the function AutomaticColorscheme
" But for the highlight to work from the very beginning, without refreshing
" the buffer even once (for example with `:e<CR>`), we also have to define it
" here
augroup ExtraWhitespaceAugroup
    autocmd!
    highlight ExtraWhitespace ctermbg=green guibg=green
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
augroup END

" (Autocommands from https://stackoverflow.com/a/4617156/7998725)
