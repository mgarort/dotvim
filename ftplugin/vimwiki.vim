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

" - gl for linking to general note (we had to disable a lot of keybindings in
"   after/ftplugin/vimwiki to freed gl)
xmap <silent> gl  <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>i\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gl  <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>i\|<Esc><space><C-u>set nolazyredraw<CR>i
" Keybindings starting with gL for linking to:
" - gLp for papers
xmap <silent> gLp <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/papers/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLp <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/papers/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLf for files (including datasets)
xmap <silent> gLf <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/files/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLf <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/files/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLn for insulin papers (to share directory with Rafa)
xmap <silent> gLn <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/papers/insulin/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLn <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/papers/insulin/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLt for patents
xmap <silent> gLt <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/patents/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLt <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/patents/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLs for scores
xmap <silent> gLs <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/scores/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLs <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/scores/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLd for documents
xmap <silent> gLd <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/docs/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLd <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/docs/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLb book
xmap <silent> gLb <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/books/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLb <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/books/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLi image
xmap <silent> gLi <space><C-u>set lazyredraw<CR>gvz}gvz}s}}i\|style="width:550px;height:220px;"<Esc>S{{<Right><Right>ifile:../files/images/processed_\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLi <space><C-u>set lazyredraw<CR>viwz}gvz}s}}i\|style="width:550px;height:220px;"<Esc>S{{<Right><Right>ifile:../files/images/processed_\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLm for media
xmap <silent> gLm <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/media/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLm <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/media/\|<Esc><space><C-u>set nolazyredraw<CR>i
" - gLl for lectures
xmap <silent> gLl <space><C-u>set lazyredraw<CR>gvz]gvz]<Right><Right>ifile:../files/lectures/\|<Esc><space><C-u>set nolazyredraw<CR>i
nmap <silent> gLl <space><C-u>set lazyredraw<CR>viwz]gvz]<Right><Right>ifile:../files/lectures/\|<Esc><space><C-u>set nolazyredraw<CR>i

" Keybinding for removing link
nmap gLr <space><C-u>set lazyredraw<CR>dz[<Right>dz[<space><C-u>set nolazyredraw<CR>


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

" Open calendar. Very similar to the <leader>d mapping for EditArbitraryDate(),
" but with a calendar view provided by the plugin mattn/calendar.vim
" <leader>e chosen because it is very similar to <leader>d
nnoremap <silent><buffer> <leader>e :call OpenCalendar()<CR>
"TODO Instead of Calendar, consider using CalendarT, which is full screen. But
"then you have to configure it so that pressing on a particular date closes
"the calendar (in addition to opening the day)

" Keys for calendar actions
let g:calendar_keys = { 'goto_next_month': '<Down>', 'goto_prev_month': '<Up>', 'goto_next_year': '<Right>', 'goto_prev_year': '<Left>'}

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
if s:n_lines < 200
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



" -------------------------
" SECTION:  Handling several wikis
" ------------------------
"
" If you have more than one wiki, sometimes you'll need to create paths that
" are specific to the wiki you are working on. These paths will use
" information from the dictionary `g:vimwiki_list` (defined in
" plugin/vimwiki.vim) and we need the index of the current wiki to access that
" information. The following is a hacky solution to obtain that index, but it
" is dependent on the working directory being exactly the wiki directory
" (.e.g. we cannot open a .wiki file from a parent directory, we need to open
" it directly from the wiki directory)
"
let current_dir = expand('%:p:h')
" Check if current wiki is 0
let match_position =  match(current_dir, '/home/mgarort/repos/notes/wiki')
if match_position == 0
    let g:current_wiki = 0
endif
" Check if current wiki is 1
let match_position =  match(current_dir, '/home/mgarort/repos/mgarort.github.io/notes/wiki')
if match_position == 0
    let g:current_wiki = 1
endif
