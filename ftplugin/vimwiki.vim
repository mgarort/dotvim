" ftplugin/vimwiki.vim contains config that is loaded for every Vimwiki buffer
" every time a Vimwiki buffer is loaded. Associated functions are defined in
" plugin/vimwiki.vim



" ---------------------------------
"  SECTION:  Edit text and navigate
" ---------------------------------
"
" Map <Plug>VimwikiTextObjListSingle to something ridiculous to freed il, so
" that we can select "in line" (il). For some reason this must be in vimrc to
" work, rather than after/ftplugin/vimwiki.vim
nnoremap <leader><leader><leader><leader><leader><leader>i <Plug>VimwikiTextObjListSingle
nnoremap <leader><leader><leader><leader><leader><leader>iV <Plug>VimwikiTextObjListSingleV

" Freed <C-o> by disabling the native 'next link' functionality, which is redundant
" after mapping <C-h> and <C-l>
nnoremap <leader><leader><leader><leader><leader><leader><leader><leader>asdfasdferqer <Plug>VimwikiNextLink

" This allows bulletpoints to be continued even at deeper bulletpoint levels,
" instead of only at the first level.
setlocal formatoptions=cnqro
setlocal comments+=n:*,n:#

" Hard wrapping of characters at 110 characters (for manual wrapping with gq)
setlocal textwidth=110

" Jumping between links will create an entry in the jumplist with m'
nnoremap <silent> <C-p> m':call SearchPrevLink()<CR>
nnoremap <silent> <C-n> m':call SearchNextLink()<CR>

" -------------------------------------------
" SECTION:  Functionality for writing in Vim
" -------------------------------------------
"
" Prose mode for hard wrapping and smooth scrolling
let b:is_prose_mode_active = 0
nnoremap <buffer> ,p :call ToggleProseMode()<CR>
nnoremap <silent> ,s :call ViewSummary()<CR>



" --------------------------------------------------------
" SECTION:  Commands and functions for fast note-writing
" --------------------------------------------------------
"
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
nnoremap <silent> '<CR> :call CreateNoteFromTitle()<CR>
" Keybinding gl for linking to note
" Note that we had to disable a lot of keybindings in after/ftplugin/vimwiki
" to freed gl
xmap gl z]gvz]<Right><Right>i\|<Esc>i


" -------------------------------
" SECTION:  Diary functionality
" ------------------------------
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


" ----------------------
" SECTION:  Appearance
" ----------------------
"
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




" --------------------------------
" SECTION:  Prepare and view HTML
" --------------------------------
"
" Compile mode that can be turned on or off depending on whether we want to
" compile on every write (allows viewing changes in HTML, but is slow) or we
" want to not compile (not viewing changes in HTML, but don't have to wait a
" couple of seconds after each write)
let s:n_lines = line('$')
if s:n_lines < 60
    let b:is_compile_html_mode_active = 1
else
    let b:is_compile_html_mode_active = 0
endif
nnoremap <buffer> ,c :call ToggleCompileHTMLMode()<CR>

" To open the HTML of the current note
nnoremap ,h :call OpenThisHTML()<CR><CR>
" To manually compile the HTML of the current note when 'Compile HTML mode' is
" inactive. ,j is chosen as a mnemonic because 'j' is next to 'h' in the
" keyboard
nnoremap ,j :call Compile()<CR>

nnoremap <C-c> :call ProcessImages()<CR>






