" plugin/vimwiki.vim contains config that is vimwiki-specific but should not
" be loaded everytime with every new vimwiki buffer (as opposed to config in
" ftplugin/vimwiki.vim). For example, functions are defined in
" plugin/vimwiki.vim, and associated keybindings are defined in
" ftplugin/vimwiki.vim. This way:
" - Functions work properly even when they involve changing buffers within the
"   function (remember that ftplugin is only for simple local definitions; see
"   note "ftplugin: Only for simple local definitions")
" - Keybindings will only be active in vimwiki notes. This way I won't trigger
"   them by accident in other files (for example, by pressing '<CR> in a
"   python file by mistake and triggering CreateNoteFromTitle)


" -------------------------
" SECTION:  Vimwiki variables
" ------------------------
"
" The following is so that vimwiki doesn't take over Tab in insert mode
let g:vimwiki_table_mappings = 0
" Have multiline list/itemize items
let g:vimwiki_list_ignore_newline = 0
" Avoid automatically writing upon exit
" (if g:vimwiki_autowriteall is set in ftplugin, it doesn't work)
let g:vimwiki_autowriteall = 0
" This is so that my vimwiki is hosted in the repos folder
let g:vimwiki_list = [{'path': '~/repos/wiki',
            \ 'path_html':'~/wiki_html',
            \ 'syntax':'default',
            \ 'template_path':'~/repos/wiki/setup',
            \ 'ext':'.wiki',
            \ 'template_default': 'default',
            \ 'template_ext': '.tpl'}]




" ---------------------------------
"  SECTION:  Edit text and navigate
" ---------------------------------
"
" Functions to navigate to next link,
" either Vimwiki link or URL
function! SearchNextLink()
    call search('\[\[.\{-}\]\]\|http\|{{.\{-}}}', 'W')
endfunction
function! SearchPrevLink()
    call search('\[\[.\{-}\]\]\|http\|{{.\{-}}}', 'bW')
endfunction



" --------------------------------------------------------
" SECTION:  Commands and functions for fast note-writing
" --------------------------------------------------------
"
"  Here, I define commands and functions for quickly putting your ideas into
"  notes.

" Function to open Vimwiki index (in order to open the index with a simple
" i3 keybinding)
function! LaunchVimwiki()
    let index_path = g:vimwiki_list[0]['path']
    execute "cd ". index_path
    execute "e " . "index.wiki"
endfunction

" Function to create new notes from a 6-level header.
" Given a note title surrounded by 6 equal signs in the wiki index, this
" creates a link, follows it and copies the title. Needs to use nmap and not
" nnoremap because otherwise <CR> doesn't create a link
" Regex explanation:
"  - \s* matches 0 or more whitespaces
"  - \( ____ \) is a capturing group. It allows us to store a matching string
"    in the variable \1
"  - .\{-} is the same as .*, but it matches stuff lazily. This means that it
"    takes less priority over other regex pattern. In this particular case, it
"    has less priority than the two \s* left and right of the capturing group.
"    So if there are surrounding whitespaces, those will be matched by \s* and
"    not by \{-}
function! CreateNoteFromTitle()
    " Check that current line contains title. If not, return from function
    let is_title_in_current_line = match(getline('.'), '====== .\+ ======')
    if is_title_in_current_line == -1
        return
    endif
    " Make a link (and restore search register afterwards)
    let old_search = getreg("/")
    s/======\s*\(.\{-}\)\s*======/====== \[\[\1\]\] ======/
    let @/ = old_search
    " Save the modification without triggering autocommands (the autocommand
    " for compiling to HTML is too slow)
    noa write
    " Copy title, follow link to note and paste title. Use h register to leave
    " the 0th unchanged, and restore unnamed register
    execute "normal ^t]\"hyi]\<CR>ggi= \<Esc>\"hpa =\<CR>\<CR>\<CR>"
    let @" = getreg("0")
    " Start insert mode
    " (norm i doesn't work https://www.reddit.com/r/vim/comments/583uaf/how_to_enter_insert_mode_from_function/)
    startinsert
endfunction

function! UpdateTitle()
    " Get filename name
    let filename = expand('%:t')
    " Remove .wiki extension
    let filename = split(filename, '\.wiki')[0]
    " Replace '= OLD_TITLE =' by '= filename =' in line 1 only
    execute '1s/= .* =/= ' . filename . ' =/'
endfunction

" Function to change Anki (Latex) to Vimwiki. Note that the e flag mutes
" error signs when the pattern is not found
function! Wikify()
    %s/\[latex\]//ge
    %s/\[\/latex\]//ge
    " %s/\\\\//ge Removed this because in maths environments the \\ sometimes
    " has meaning and is needed
    %s/``/"/ge
    %s/\\begin{itemize}//ge "TODO Introduce multiline substitution that substitutes - at the beginning of the line for 1. when surrounded by \begin{enumerate}
    %s/\\end{itemize}//ge
    %s/\\begin{verbatim}/{{{>/ge
    %s/\\end{verbatim}/}}}/ge
    %s#\\underline{\(.\{-}\)}#<u>\1</u>#ge
    %s#\\textbf{\(.\{-}\)}#*\1*#ge
    %s#\\textit{\(.\{-}\)}#_\1_#ge
    %s#\\item{\(.*\)}#\1#ge
    %s#\\verb|\(.\{-}\)|#`\1`#e
    " The following replaces the $$....$$ equations in latex
    " for {{$....}}$ in Vimwiki. Explanation:
    " - Left hand side, \$\$  \$\$ are $$   $$ for Latex
    " - Left hand side, \(\_.\{-}\) is a capturing group
    " - Left hand side, \_ is saying to go over multiple lines
    " - Left hand side, .\{-} is saying to match everything, but being
    "   non-greedy. This is because we want $$....$$ to match the closest pair
    "   of $$, instead of the first $$ in the file and the last $$ in the file
    " - Right hand side, \1 pastes the capturing group from the left hand side
    %s/\$\$\(\_.\{-}\)\$\$/{{\$\1}}\$/ge
    " Same, but with align environments
    %s/\\begin{align.*}\(\_.\{-}\)\\end{align.*/{{\$%align%\1}}\$/ge
endfunction




" -------------------------------
" SECTION:  Diary functionality
" ------------------------------
"
" Keybindings for going to previous and next day's diary entries. Similarly to
" the section on creating and renaming notes, here I define functions, and
" keybindings for those functions are created in ftplugin/vimwiki.vim

" 1) First, you need to create mappable symbols for <C-Left,Right,Up,Down>.
" Done in vimrc.
" 2) Second, you don't use VimwikiDiaryPrevDay and VimwikiDiaryNextDay
" directly, because they leave saved buffers opened lingering around.
" Therefore, write a function that, if unsaved changes, uses these functions
" in order to leave the buffers open, and if all saved, uses these functions
" and then closes the buffer
function! GoToPreviousDay()
    let is_modified = &mod
    VimwikiDiaryPrevDay
    if is_modified == 0
        bd#
    endif
endfunction
function! GoToNextDay()
    let is_modified = &mod
    VimwikiDiaryNextDay
    if is_modified == 0
        bd#
    endif
endfunction

" Make diary note for any date (or open if existing)
function! EditArbitraryDate()
    let current_date = strftime("%Y-%m-%d")
    let date = input('Enter date in YYYY-MM-DD format:  ', current_date)
    if len(date) == 0
        echo 'Error. Cannot leave date empty!'
        sleep 2
        echo ''
    else
        let path = g:vimwiki_list[0]['path'] . '/diary/' . date . '.wiki'
        exe 'e ' . path
    endif
endfunction

" This function will insert the diary note template into empty and newly
" created diary notes
" NOTE Decided not to use it because it's better to leave empty diary notes
" blank, since that allows you to quickly see that you have nothing planned
" for that day yet
function! PopulateDiaryEntry()
    " Write diary template if the current file is empty or i
    let filesize = getfsize(expand("%"))
    let extension = expand("%:e")
    " If file is empty and is not a directory, populate with diary template
    " (necessary to check with extension becausee getfsize returns 0 both if
    " directory or if empty file)
    if extension == 'wiki' && filesize == 0
        call feedkeys("idiary\<Tab>\<Esc>gg4j")
    " If file doesn't exist (is being newly created), populate
    elseif filesize == -1
        call feedkeys("idiary\<Tab>\<Esc>gg4j")
    endif
endfunction


function OpenCalendar()
    Calendar
    setlocal filetype=calendar
    color blackwhite
    " We need to move years to get Vim to color the calendar
    call calendar#action("PrevYear")
    call calendar#action("NextYear")
    vertical resize 27
    " Color days with diary notes in blue
    hi CalMemo ctermfg=blue
endfunction

" Make calendar from the plugin mattn/calendar.vim start on Monday
" (not directly in the Vimwiki plugin but closely integrated with Vimwiki)
let g:calendar_monday = 1
" Make the plus signs + indicating that a diary note has been created for
" a day be closer to the day number
let g:calendar_mark = 'left-fit'


" -------------------------
" SECTION:  Functionality for writing in Vim
" ------------------------
"
" Prose mode for hard wrapping and smooth scrolling.
" Based on https://stackoverflow.com/questions/9922607/vim-long-lines-and-scrolling
function! ToggleProseMode()
    if b:is_prose_mode_active == 0
        nmap <buffer> <leader><leader><leader><leader><leader><leader><leader>o <Plug>VimwikiListo
        nnoremap <buffer> o o
        inoremap <expr><buffer> <CR> pumvisible() ? '<Esc>a' : '<C-G>u<CR>'
        setlocal textwidth=110
        setlocal formatoptions=wat
        let b:is_prose_mode_active = 1
        echo 'Prose mode ACTIVE'
    elseif b:is_prose_mode_active == 1
        nmap <buffer> o <Plug>VimwikiListo
        inoremap <expr><buffer> <CR> pumvisible() ? '<Esc>a' : '<C-]><Esc>:VimwikiReturn 3 5<CR>'
        setlocal textwidth=0
        setlocal formatoptions=tqn
        let b:is_prose_mode_active = 0
        echo "Prose mode INACTIVE"
    endif
endfunction

" Simple function to view summary of current wiki note
" (i.e. summary of all headers)
function! ViewSummary()
    " Save original position in mark to return later
    exe 'norm ms'
    " Create new window with the summary
    Redir %g/^=.\+=$/
    silent %s/^\(\s*[0-9]\+ = .\+ =\)$/\r\1/
    exe 'normal! ggdd'
    " Make readonly
    setlocal readonly
    setlocal nomodifiable
    " Set appropriate filetype and colorscheme
    set filetype=vimwiki
    exe 'colorscheme blackwhite'
    " Return to original position
    " 1. Go back to previous window
    wincmd p
    " 2. Go to mark
    exe 'norm `s'
endfunction



" --------------------------------
" SECTION:  Prepare and view HTML
" --------------------------------
"
" Toggle HTML compiling. Useful when working with long wiki files, since
" compiling every time we write to disk can take a long time. By toggling off
" the compilation we can save time.
function! ToggleCompileHTMLMode()
    if b:is_compile_html_mode_active == 0
        let b:is_compile_html_mode_active = 1
        echo 'Compile HTML mode ACTIVE'
    elseif b:is_compile_html_mode_active == 1
        let b:is_compile_html_mode_active = 0
        echo 'Compile HTML mode INACTIVE'
    endif
endfunction

" Recompile HTML upon writing buffer to disk. The augroup avoids creating a
" duplicate autocommand every time we source the vimrc file (see explanation
" here https://learnvimscriptthehardway.stevelosh.com/chapters/14.html).
" Before defining the augroup and clearing autocommands with autocmd!, writing
" to file took a long time after long Vim sessions
function! Compile()
    silent Vimwiki2HTML
endfunction
augroup CompileVimwiki
    autocmd!
    autocmd BufWritePost *.wiki if b:is_compile_html_mode_active ==# 1 | call Compile() | endif
augroup END
" TODO  Ask either in Reddit why wrapping the command in a function (like
" above) works, whereas using `silent Vimwiki2HTML` directly (like below)
" doesn't
" augroup CompileVimwiki
"     autocmd!
"     autocmd BufWritePost *.wiki if b:is_compile_html_mode_active ==# 1 | silent Vimwiki2HTML | endif
" augroup END
function! OpenThisHTML()
    let path_to_html_folder = expand(g:vimwiki_list[0]['path_html']) . '/'
    let full_path_to_wiki_file = expand('%:p')
    let note_name_with_wiki_extension = split(full_path_to_wiki_file, '/wiki/')[-1]
    let note_name = split(note_name_with_wiki_extension, '\.wiki')[0]
    " The quotes around make sure that firefox receives the full path instead
    " of just the path up to the first parenthesis
    let full_path_to_html_file = path_to_html_folder . note_name . ".html"
    "The & at the end guarantees that firefox is executed in the background,
    "so Vim goes back to editing instead of hanging while Firefox is open
    let full_path_to_html_file = substitute(full_path_to_html_file, "'", "\\\\'", "g")
    execute "!firefox -new-window $'" . full_path_to_html_file . "' &"
endfunction
" Process images so that they use less space, and map keybinding to <C-c> (c
" for compress)
function! ProcessImages()
    let path_to_wiki = expand(g:vimwiki_list[0]['path'])
    let path_to_setup_folder = path_to_wiki . '/setup/'
    execute '!cd' path_to_setup_folder '; python3 process_images.py'
endfunction


" -------------------------
" SECTION:  Yet to be sorted
" ------------------------
"

" Maybe create one section on unmapping Vimwiki mappings

