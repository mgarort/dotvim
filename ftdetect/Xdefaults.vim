" This ftdetect has the only purpose to automatically set the correct filetype
" for dot.Xdefaults, my urvt configuration file in my dotfiles repository
autocmd BufNewFile,BufRead dot.Xdefaults setf xdefaults
