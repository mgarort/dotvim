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

" Keymaps for quick renaming of vimwiki files (t for title and u for update)
" ,t not only prompts new filename, but inserts the old one as a starting
" point for convenience
nnoremap ,t :VimwikiRenameFile<CR>y<CR><C-r>=expand('%:t:r')<CR>
function! UpdateTitle()
    " Get filename name
    let filename = expand('%:t')
    " Remove .wiki extension
    let filename = split(filename, '\.wiki')[0]
    " Replace '= OLD_TITLE =' by '= filename =' in line 1 only
    execute '1s/= .* =/= ' . filename . ' =/'
endfunction
command! UpdateTitle call UpdateTitle()
nnoremap ,u :UpdateTitle<CR>

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
command! Wikify call Wikify()

" Given a note title surrounded by 6 equal signs in the wiki index, this
" creates a link, follows it and copies the title. Needs to use nmap and not
" nnoremap because otherwise <CR> doesn't create a link
" I tried to create a more sophisticated function but it took longer, so it's
" gonna be a mapping
" Originally I used the following mapping:
"nmap '<CR> :s/======\s*\(.\{-}\)\s*======/====== \[\[\1\]\] ======/<CR>:let @/=""<CR>:w<CR>^t]yi]<CR>ggi=<space><Esc>pa<space>=<CR><CR>
" but then I mapped : to , so I had to modify it by changing : to <space>
" where necessary  
nmap '<CR> <space>s/======\s*\(.\{-}\)\s*======/====== \[\[\1\]\] ======/<CR><space>let @/=""<CR><space>w<CR>^t]yi]<CR>ggi=<space><Esc>pa<space>=<CR><CR>
" Regex explanation:
"  - \s* matches 0 or more whitespaces
"  - \( ____ \) is a capturing group. It allows us to store a matching string
"    in the variable \1
"  - .\{-} is the same as .*, but it matches stuff lazily. This means that it
"    takes less priority over other regex pattern. In this particular case, it
"    has less priority than the two \s* left and right of the capturing group.
"    So if there are surrounding whitespaces, those will be matched by \s* and
"    not by \{-}

" TODO If the regex above is too slow, change it back to the following
" previous regex. The advantage of the regex above is that it corrects a
" different number of whitespaces left and right, but if it's too slow we can
" do without it.
"nmap '<CR> :s/====== \(.*\) ======/====== \[\[\1\]\] ======/<CR>:let @/=""<CR>:w<CR>^t]yi]<CR>ggi=<space><Esc>pa<space>=<CR><CR>



""" SECTION: Diary-related functionality

" Keybindings for going to previous and next day's diary entries. 
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
" 3) Map the previous functions
nnoremap <C-Left> :call GoToPreviousDay()<CR>
nnoremap <C-Right> :call GoToNextDay()<CR>
" Also, create a mapping for creating tomorrow's note, in case you need to
" create it in advance. Note that it makes sense to create it like this,
" because the <leader> prefix is for opening files. First you need to remap
" VimwikiTabMakeDiaryNote, which is hogging <leader>w<leader>t
nmap <leader>w<leader>x <Plug>VimwikiTabMakeDiaryNote
nmap <leader>w<leader>t <Plug>VimwikiMakeTomorrowDiaryNote
" Notice that <leader>w<leader>y creates yesterday's note if that wasn't
" already created

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
