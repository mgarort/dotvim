" Recognize dot.bashrc_{common,corona,cluster} as sh filetype to ensure
" proper syntax highlighting

autocmd BufNewFile,BufRead *.bashrc* setf sh
