" Functions and keybindings to navigate to next link, 
" either Vimwiki link or URL
function! SearchNextLink()
    " Get line number and column
    let [lnum, col] = searchpos('\[\[.*\]\]\|http', 'n') 
    call setpos('.', [0, lnum, col, 0])
endfunction
function! SearchPreviousLink()
    " Get line number and column
    let [lnum, col] = searchpos('\[\[.*\]\]\|http', 'bn') 
    call setpos('.', [0, lnum, col, 0])
endfunction
" Jumping between links will create an entry in the jumplist with m'
nnoremap <silent> <C-h> m':call SearchPreviousLink()<CR>
nnoremap <silent> <C-l> m':call SearchNextLink()<CR>



" Customize fzf colors to ensure that they match the Vimwiki colorscheme
" For more info check https://github.com/junegunn/fzf/blob/master/README-VIM.md#explanation-of-gfzf_colors
" Do it in ftplugin because this makes it prettier for Vimwiki but makes it
" uglier in the general case
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['bg', 'Exception'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['bg', 'Exception'],
  \ 'gutter':  ['bg', 'Normal'],
  \ 'query':   ['fg', 'Normal'] }


" Keep indentation level while wrapping lines
set breakindent
" Don't break lines in the middle of words
set linebreak

" Disable folding
set nofoldenable


""" SECTION: Prepare and view HTML

" Recompile HTML upon writing buffer to disk. The augroup avoids creating a
" duplicate autocommand every time we source the vimrc file (see explanation
" here https://learnvimscriptthehardway.stevelosh.com/chapters/14.html).
" Before defining the augroup and clearing autocommands with autocmd!, writing
" to file took a long time after long Vim sessions
augroup CompileVimwiki
    autocmd!
    autocmd BufWritePost *.wiki silent Vimwiki2HTML
augroup END
" Make blackwhite the default colorscheme for vimwiki
" Removed from now because I'm testing the function AutomaticColorscheme
" autocmd FileType vimwiki colorscheme blackwhite
" Load the html of the current file in firefox (h for html)
function! OpenThisHTML()
    let path_to_html_folder = expand(g:vimwiki_list[0]['path_html']) . '/'
    let full_path_to_wiki_file = expand('%:p')
    let note_name_with_wiki_extension = split(full_path_to_wiki_file, '/wiki/')[-1]
    let note_name = split(note_name_with_wiki_extension, '\.wiki')[0]
    " The quotes around make sure that firefox receives the full path instead
    " of just the path up to the first parenthesis
    let full_path_to_html_file = "'" . path_to_html_folder . note_name . ".html'"
    "The & at the end guarantees that firefox is executed in the background,
    "so Vim goes back to editing instead of hanging while Firefox is open
    execute "!firefox -new-window" full_path_to_html_file "&"  
endfunction
"function! OpenThisPDF()
"    let path_to_html_folder = expand(g:vimwiki_list[0]['path_html']) . '/'
"    let full_path_to_wiki_file = expand('%:p')
"    let note_name_with_wiki_extension = split(full_path_to_wiki_file, '/wiki/')[-1]
"    let note_name = split(note_name_with_wiki_extension, '\.wiki')[0]
"    " The quotes around make sure that firefox receives the full path instead
"    " of just the path up to the first parenthesis
"    let full_path_to_html_file = "'" . path_to_html_folder . note_name . ".html'"
"    let full_path_to_pdf_file  = "'./pdf" . path_to_html_folder . note_name . ".html'"
"    execute  "wkhtmltopdf -L 25mm -R 25mm -T 25mm -B 25mm" . full_path_to_html_file 2020-05-22\ Andreas.pdf
"    "The & at the end guarantees that firefox is executed in the background,
"    "so Vim goes back to editing instead of hanging while Firefox is open
"    execute "!firefox -new-window" full_path_to_html_file "&"  
"endfunction
noremap ,h :call OpenThisHTML()<CR><CR>
" Process images so that they use less space, and map keybinding to <C-c> (c
" for compress)
function! ProcessImages()
    let path_to_wiki = expand(g:vimwiki_list[0]['path'])
    let path_to_setup_folder = path_to_wiki . '/setup/'
    execute '!cd' path_to_setup_folder '; python3 process_images.py'
endfunction     
" Apparently <C-i> is mapped by default to a function that goes to the next
" Vimwiki link, which could be quite useful
"nmap <Leader>wn <Plug>VimwikiNextLink
nnoremap <C-c> :call ProcessImages()<CR>



""" SECTION: Edit text and navigate

" Map <Plug>VimwikiTextObjListSingle to something ridiculous to freed il, so
" that we can select "in line" (il). For some reason this must be in vimrc to
" work, rather than after/ftplugin/vimwiki.vim
nnoremap <leader><leader><leader><leader><leader><leader>i <Plug>VimwikiTextObjListSingle
nnoremap <leader><leader><leader><leader><leader><leader>iV <Plug>VimwikiTextObjListSingleV

" Freed <C-o> by disabling the native 'next link' functionality, which is redundant 
" after mapping <C-h> and <C-l>
nnoremap <leader><leader><leader><leader><leader><leader><leader><leader>asdfasdferqer <Plug>VimwikiNextLink

" Have multiline list/itemize items
let g:vimwiki_list_ignore_newline = 0
" Avoid automatically writing upon exit
let g:vimwiki_autowriteall = 0
" This allows bulletpoints to be continued even at deeper bulletpoint levels,
" instead of only at the first level.
setlocal formatoptions=ctnqro
setlocal comments+=n:*,n:#



""" SECTION: Create new notes and rename

" Here, I create keybindings for functions and commands defined in
" plugin/vimwiki. This way:
" - Functions work properly even when they involve changing buffers within the
"   function (remember that ftplugin is only for simple local definitions; see
"   note "ftplugin: Only for simple local definitions")
" - Keybindings will only be active in vimwiki notes. This way I won't trigger
"   them by accident in other files (for example, by pressing '<CR> in a
"   python file by mistake and triggering CreateNoteFromTitle)

" t for changing Title, u for Updating title
nnoremap ,t :VimwikiRenameFile<CR>y<CR><C-r>=expand('%:t:r')<CR>
command! UpdateTitle call UpdateTitle()
nnoremap ,u :UpdateTitle<CR>
" Create wiki notes from Anki notes
command! Wikify call Wikify()
" Create notes from 6= headers
nnoremap '<CR> :call CreateNoteFromTitle()<CR>i


" -----------
" | SECTION | Diary functionality
" -----------
"
" Keybindings for going to previous and next day's diary entries. Similarly to
" the section on creating and renaming notes, here I only create keybindings,
" and functions are defined in plugin/vimwiki.vim
nnoremap <C-Left> :call GoToPreviousDay()<CR>
nnoremap <C-Right> :call GoToNextDay()<CR>
" <leader>w<leader>y for yesterday's diary note (set by default) and
" <leader>w<leader>t for tomorrow's note (need to release it from
" TabMakeDiaryNote)
nmap <leader>w<leader>x <Plug>VimwikiTabMakeDiaryNote
nmap <leader>w<leader>t <Plug>VimwikiMakeTomorrowDiaryNote
" TODO insert the diary template if the diary buffer is empty, and don't
" insert it if it already has content

" Create new diary note (or edit existing one)
nnoremap <silent><buffer> <leader>d :call EditArbitraryDate()<CR>


" -----------
" | SECTION | Appearance
" -----------
"


" Wrap lines at 100 characters
" let custom_width=100
" let &l:columns=custom_width
" autocmd VimResized *.wiki if (&columns > custom_width) | let &l:columns=custom_width | endif
" set wrap


let b:is_prose_mode_active = 0
nnoremap <buffer> ,r :call ActivateProseMode()<CR>
