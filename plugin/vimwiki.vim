"""

" The following is so that vimwiki doesn't take over Tab in insert mode
let g:vimwiki_table_mappings = 0
" This is so that my vimwiki is hosted in the repos folder
let g:vimwiki_list = [{'path': '~/repos/wiki', 
            \ 'path_html':'~/wiki_html', 
            \ 'syntax':'default', 
            \ 'template_path':'~/repos/wiki/setup',
            \ 'ext':'.wiki',
            \ 'template_default': 'default',
            \ 'template_ext': '.tpl'}]
" Make fuction to open Vimwiki index (in order to open the index with a simple
" i3 keybinding)
function! LaunchVimwiki()
    let index_path = g:vimwiki_list[0]['path']
    execute "cd ". index_path
    execute "e " . "index.wiki"
endfunction


""" SECTION: Create new notes and rename

" Here, I will define functions for creating and renaming notes, but I will
" create the keybindings to use them in ftplugin/vimwiki.vim. This way:
" - Functions work properly even when they involve changing buffers within the
"   function (remember that ftplugin is only for simple local definitions; see
"   note "ftplugin: Only for simple local definitions")
" - Keybindings will only be active in vimwiki notes. This way I won't trigger
"   them by accident in other files (for example, by pressing '<CR> in a
"   python file by mistake and triggering CreateNoteFromTitle)

function! UpdateTitle()
    " Get filename name
    let filename = expand('%:t')
    " Remove .wiki extension
    let filename = split(filename, '\.wiki')[0]
    " Replace '= OLD_TITLE =' by '= filename =' in line 1 only
    execute '1s/= .* =/= ' . filename . ' =/'
endfunction

" Make function to change Anki (Latex) to Vimwiki. Note that the e flag mutes
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
    %s#\\textbf{\(.\{-}\)}#<b>\1</b>#ge
    %s#\\textit{\(.\{-}\)}#<i>\1</i>#ge
    %s#\\item{\(.*\)}#\1#ge
    %s#\\verb|\(.\{-}\)|#`\1`#ge
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
endfunction


""" SECTION: Diary-related functionality

" Keybindings for going to previous and next day's diary entries. Similarly to
" the section on creating and renaming notes, here I define functions, and
" keybindings for those functions are created in ftplugin/vimwiki.vim

" 1) First you have to freed <C-Left> and <C-Right> from Putty, which for some reason holds
" them hostage. You can find which sequence corresponds to <C-Left> (for
" instance), in this case by pressing the following combination in insert
" mode: <C-v><C-Left>. Note that <Esc> is represented by ^[ when you do this.
map  <Esc>Od <C-Left>
map! <Esc>Od <C-Left>
map  <Esc>Oc <C-Right>
map! <Esc>Oc <C-Right>
map  <Esc>Oa <C-Up> 
map! <Esc>Oa <C-Up> 
map  <Esc>Ob <C-Down> 
map! <Esc>Ob <C-Down> 
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


" TODO Decide if you want to keep the following functionality for time
" tracking

" Keybindings for time tracking with ti. <leader>t stands for time commands
" Turn on with o
function! OnTi()
    let on_message = system('ti on $( date \+\%F ) --no-color')
    echo on_message
endfunction
nnoremap <silent> <leader>t<leader>o :call OnTi()<CR>
" Finish with f
function! FinishTi()
    let finish_message = system('ti fin --no-color')
    echo finish_message
endfunction
nnoremap <silent> <leader>t<leader>f :call FinishTi()<CR>
" Write log to current diary entry with w
function! GetDiaryTime()
    let title = getline('1')
    let diary_date = split(title, ' ')[1]
    let diary_date = substitute(diary_date, '\.', '-', 'g')
    let diary_date_log = system('ti log | grep ' . diary_date)
    if diary_date_log == ''
        let diary_date_log = '0 seconds'
    else
        let diary_date_log = split(diary_date_log, ' ')[4:]
        let diary_date_log = join(diary_date_log, ' ')
    endif
    return diary_date_log
endfunction
function! WriteTi()
    let diary_date_log = GetDiaryTime()
    execute "normal! ggo\<cr>\<cr>Time working:  " . diary_date_log . "\<cr>\<esc>"
endfunction
nnoremap <silent> <leader>t<leader>w :call WriteTi()<CR>
" Display the log of the time spent on the current diary entry's date, rather than writing it
function! LogTi()
    let diary_date_log = GetDiaryTime()
    echo diary_date_log
endfunction
nnoremap <silent> <leader>t<leader>l :call LogTi()<CR>
" Display ti status
function! StatusTi()
    let status_message = system('ti status --no-color')
    echo status_message
endfunction
nnoremap <silent> <leader>t<leader>s :call StatusTi()<CR>
" Make diary note with template, instead of empty diary note. Note that it is
" not so easy because if the note is already created then you don't want to
" insert the template. You only want to insert the template the first time you
" open the diary entry. Another option would be to do it manually when you
" first open the diary entry
"nmap <Leader>w<Leader>w VimwikiMakeDiaryNote<CR>idiary<Tab>
" Finally, note that <C-i> may be going from link to link
" Here ends my vimwiki configuration


" Make diary note for any date (or open if existing)
function! EditArbitraryDate()
    let date = input('Enter date in YYYY-MM-DD format:  ')
    let path = g:vimwiki_list[0]['path'] . '/diary/' . date . '.wiki'
    exe 'e ' . path
endfunction
