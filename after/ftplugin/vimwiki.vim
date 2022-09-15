" Configure <CR> for choosing from an autocomplete list in Vimwiki, while
" keeping the native Vimwiki <CR> in insert, which is useful for writing lists
" with several levels.
" Autocommand from section "8. Lists" in the Vimwiki docs
inoremap <expr><buffer> <CR> pumvisible() ? '<Esc>a' : '<C-]><Esc>:VimwikiReturn 3 5<CR>'

" Unmap \ww from vimwiki's default usage (go to index note) and map it to go
" to the note of the Monday of the current week
silent! nunmap <leader>ww
nnoremap <leader>ww :call OpenMonday()<CR>

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

" Unmap Vimwiki mappings starting with gl so that I can use gl for creating
" link to note
map <leader><leader><leader><leader><leader>bLbab <Plug>VimwikiRemoveSingleCB
map <leader><leader><leader><leader><leader>a8oie <Plug>VimwikiRemoveCBInList
map <leader><leader><leader><leader><leader>cKcbc <Plug>VimwikiRenumberList
map <leader><leader><leader><leader><leader>oqh44 <Plug>VimwikiRenumberAllLists
map <leader><leader><leader><leader><leader>dJdcd <Plug>VimwikiIncreaseLvlSingleItem
map <leader><leader><leader><leader><leader>eHede <Plug>VimwikiDecreaseLvlSingleItem
map <leader><leader><leader><leader><leader>fGfef <Plug>VimwikiDecrementListItem
map <leader><leader><leader><leader><leader>gFgfg <Plug>VimwikiDecrementListItem
map <leader><leader><leader><leader><leader>hEhgh <Plug>VimwikiIncrementListItem
map <leader><leader><leader><leader><leader>jDjhj <Plug>VimwikiIncrementListItem
map <leader><leader><leader><leader><leader>kCkjk <Plug>VimwikiToggleRejectedListItem
map <leader><leader><leader><leader><leader>lBlkl <Plug>VimwikiToggleRejectedListItem
" map <leader><leader><leader><leader><leader>libgk <Plug>VimwikiChangeSymbolInListTo
silent! unmap <buffer> glA
silent! unmap <buffer> gla
silent! unmap <buffer> glI
silent! unmap <buffer> gli
silent! unmap <buffer> gLi
silent! unmap <buffer> gl1
silent! unmap <buffer> gl#
silent! unmap <buffer> gl*
silent! unmap <buffer> gl-
silent! unmap <buffer> gll
silent! unmap <buffer> glh
silent! unmap <buffer> glp
silent! unmap <buffer> gln
silent! unmap <buffer> glx


" Same as above, but with <C-d> so that we can use it for deleting, just as in the shell
silent! iunmap <buffer> <C-d>

" Unmap this weird expression, which is mapped to <Plug>VimwikiTabnewLink and
" clashes with < action for removing indentation
silent! unmap <buffer> <D-CR>

