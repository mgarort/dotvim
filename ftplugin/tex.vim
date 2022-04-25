hi link texRefZone texTypeStyle
hi link texCite texSectionZone
" Simply because texBeginEnd has nice yellow pale color
hi link texMathZoneX texBeginEnd
hi link texMathSymbol texMathZoneX
hi link texMathZoneY texBeginEnd


" Adding : to the list of normal characters that can make
" up words is necessary so that Vim can jump through tags
" that contain : (such as sec:my_section)
setlocal iskeyword+=:

" t for regenerating ctags
" Function to regenerate ctags similar to the one used in Python
function! GenerateCtags()
    let root_dir = fnamemodify(finddir('.git', '.;'), ':h')
    exe '!ctags -f ' . root_dir . '/.tags ' . root_dir . '/*.tex ' . root_dir . '/*.bib'
endfunction
nnoremap <leader>t :call GenerateCtags()<CR>
" TODO This generates ctags in the directory where Vim was
" opened,rather than the directory of the current buffer. Change it so that it
" generates tags in the directory of the current buffer
