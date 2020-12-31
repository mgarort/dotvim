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

nnoremap <silent> <C-h> :call SearchPreviousLink()<CR>
nnoremap <silent> <C-l> :call SearchNextLink()<CR>



" Here starts my vimwiki configuration
" vimwiki configuration (may clash with Vundle configuration)




" The next is so that I can use markdown syntax instead of the original
" vimwiki syntax
"let g:vimwiki_list = [{'path': '~/vimwiki',
"  \ 'syntax': 'markdown', 'ext': '.md'}]
" The next is so that Python and C++ blocks are highlighted
"let wiki = {}
"let wiki.path = '~/my_wiki/'
"let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
" The following is so that I can have multiline list/itemize items
let g:vimwiki_list_ignore_newline = 0
" The following prevents vimwiki to automatically write buffers upon exit
let g:vimwiki_autowriteall = 0
" Recompile HTML upon writing buffer to disk. The augroup avoids creating a
" duplicate autocommand every time we source the vimrc file (see explanation
" here https://learnvimscriptthehardway.stevelosh.com/chapters/14.html).
" Before defining the augroup and clearing autocommands with autocmd!, writing
" to file took a long time after long Vim sessions
augroup CompileVimwiki
    autocmd!
    autocmd FileType vimwiki autocmd BufWritePost <buffer> silent Vimwiki2HTML
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
" This allows bulletpoints to be continued even at deeper bulletpoint levels,
" instead of only at the first level.
setlocal formatoptions=ctnqro
setlocal comments+=n:*,n:#
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

" Keymaps for quick renaming of vimwiki files
nnoremap <leader>r :VimwikiRenameFile<CR>y<CR>
nnoremap <leader>u :UpdateTitle<CR>

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
nnoremap <Leader>wb <Plug>VimwikiGoBackLink
nnoremap <BS> :call CloseThisBuffer()<CR>
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
