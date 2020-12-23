" My vimrc file. To locate in ~/.vim/vimrc and to be used with the HUGE version
" of Vim (all details about the Vim version used in corona are in
" dotvim/.vim_version_on_corona.txt). Remember that you need to install Vundle, before installing the plugins, which you do with:    
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

" VUNDLE CONFIGURATION

set nocompatible              " be iMproved, required 
filetype off                  " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" Comment out YouCompleteMe if in a cluster where you cannot compile it
Plugin 'ycm-core/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'honza/vim-snippets'
Plugin 'SirVer/ultisnips'
Plugin 'tomasiser/vim-code-dark'
Plugin 'lervag/vimtex'
Plugin 'vimwiki/vimwiki'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'justinmk/vim-sneak'
Plugin 'mechatroner/rainbow_csv'
Plugin 'qpkorr/vim-bufkill'
Plugin 'tpope/vim-fugitive'
Plugin 'wellle/targets.vim'
Plugin 'ap/vim-css-color'
Plugin 'Konfekt/vim-CtrlXA'
Plugin 'romainl/vim-cool'
Plugin 'vim-scripts/SearchComplete'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required (note that this automatically guesses indents for 
                             " Python, etc, when you're writing code, so it's very useful)
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line



" MY OWN STUFF 

" Here starts my vimwiki configuration
" vimwiki configuration (may clash with Vundle configuration)
set nocompatible
filetype plugin on
syntax on
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
" Make fuction to open Vimwiki index (in order to open the index with a simple
" i3 keybinding)
function! LaunchVimwiki()
    let index_path = g:vimwiki_list[0]['path']
    execute "cd ". index_path
    execute "e " . "index.wiki"
endfunction
" This command is relevant to the Vimwiki configuration because it
" binds <BS> (backspace) to closing the buffer so that navigation in Vimwiki
" doesn't leave a trail of open buffers behind. But it will also work for
" non-Vimwiki files. The function CloseThisBuffer() ensures that if there is
" no open buffer, <BS> will close Vim
function! CloseThisBuffer()
    if bufname("%") == ""
        q
    elseif IsFugitiveDiffScratchWindow() == 1
        bd
    elseif IsFugitiveStatusWindow() == 1
        q
    else
        BD
    endif
endfunction
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



" Set case options:
" - ignorecase ignores the case when searching
" - smartcase overrides ignorecase and pays attention to case, but only when
"   capital letters are included in the search
set ignorecase
set smartcase

" Make new windows open below and to the right
set splitbelow
set splitright

" so that vim-cellmode sends code from the cell to the right pane
let g:cellmode_tmux_panenumber=1

" map keys to copying in system clipboard, so that you can search stuff for
" instance on Firefox. Note that in order for Vim to be able to copy to system
" clipboard, it must be compiled with the +clipboard. I usually use the binary
" vim-gtk, which can be installed with
" sudo apt install vim-gtk
vmap <C-y> "+y
map <C-p> "+p
vmap <C-c> d:let @+ = @"<CR>i
" Copy the last Vim selection to clipboard
nnoremap <leader>+ :let @+=@"<CR>


" avoid an annoying beeping sound. Instead, the ``beeping" will be a white
" flash
set visualbell
" highlight searches and change highlight color (the latter needs to be done
" with the command ColorScheme, so that Vim does it after loading the
" colorscheme and doesn't overwrite it)
set hlsearch
augroup highlight_search
    au!
    au ColorScheme * hi Search cterm=NONE ctermfg=white ctermbg=DarkRed
    " IncSearch changes the color for the current match in search and replace with
    " confirmation. That way you can distinguish the one you're currently looking
    " at from all the others
    au ColorScheme * hi IncSearch cterm=NONE ctermfg=white ctermbg=DarkGreen
augroup END
" noh to avoid highlighting upon sourcing .vimrc
noh
" remap :noh to <CR> in normal mode. :noh stops highlighting until next
" search
" XXX This mapping may be redundant after installing romainl's vim-cool
nnoremap <C-n> :noh<CR>

" Make sure that tabs are expanded to spaces. If you do this all the time
" consistently, you'll avoid errors of mixing tabs and spaces in the same
" python file
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
" Minimize the number of types that Vim goes to a weird buffer type (bt) that
" doesn't allow you to write to files when editing over scp
autocmd BufRead scp://* :set bt=
autocmd BufWritePost scp://* :set bt=
"autocmd BufNewFile,BufRead *.py set keywordprg=pydoc
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py"

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
set completeopt-=preview  " avoid the annoying preview window, that shows the documentation of whatever function you are autocompleting, and then stays open

" This mouse behaviour is the closest to what I wanted. It only allows to
" sccroll and select cursor position with mouse in normal mode
set mouse=n

set number                     " Show current line number
set relativenumber             " Show relative line numbers
set backspace=indent,eol,start " To make sure that backspace works in every system
syntax on                      " to make sure that syntax is highlighted in every system

" Avoid mouse setting cursor
" noremap <LeftMouse> ma<LeftMouse>`a   
augroup NO_CURSOR_MOVE_ON_FOCUS
    au!
    au FocusLost * let g:oldmouse=&mouse | set mouse=
    au FocusGained * if exists('g:oldmouse') | let &mouse=g:oldmouse | unlet g:oldmouse | endif
augroup END

" Look for tags file (from ctags) in upper directories recursively
set tags=./tags;/

" Allow to open other buffers when current file is unsaved
set hidden

" Make file completion in command mode (e.g. when opening a file in a buffer
" with :e) more similar to Bash completion
set wildmenu
set wildmode=longest,list

" Set updatetime variable so that live views of tex pdfs get updated
" automatically (used by xuhdev/vim-latex-live-preview)
set updatetime=500

" Status line
set statusline=
set statusline +=[%n]\ \ \%*  "buffer number
set statusline+=%<%F          "full filepath
set statusline+=\ %m          "modified flag
set statusline+=%=            "left/right separator
set statusline+=(%c)\ \       "column number
set statusline+=%l/%L         "cursor line/total lines
set statusline+=\ \ %P          "percent through file
set laststatus=2              " Show statusline for all windows.

" My very simple script and keybinding to iterate over colorschemes upon
" pressing F12
let g:iterable_colorschemes=['codedark', 'morning', 'blackwhite']
let g:current_colorscheme_idx = 0

function! IterateColorscheme()
    let n_colorschemes = len(g:iterable_colorschemes)
    let g:current_colorscheme_idx = ( g:current_colorscheme_idx + 1 ) % n_colorschemes
    let current_colorscheme = g:iterable_colorschemes[g:current_colorscheme_idx]
    execute "colorscheme" current_colorscheme
endfunction

nnoremap <F12> :call IterateColorscheme()<CR>
imap <F12> <Esc>:call IterateColorscheme()<CR>li


" Vim isn't able to change the cursor color by itself in a colorscheme: 
" this is something that belongs to urxvt. So a little bit of wizardry is needed
if &term =~ "xterm\\|rxvt"
    " use an orange cursor in insert mode
    let &t_SI = "\<Esc>]12;orange\x7"
    " use a gray cursor otherwise
    let &t_EI = "\<Esc>]12;gray\x7"
    silent !echo -ne "\033]12;gray\007"
    " reset cursor when vim exits
    augroup ResetCursorWhenVimLeaves
        autocmd!
        autocmd VimLeave * silent !echo -ne "\033]112\007"
    augroup END
    " use \003]12;gray\007 for gnome-terminal
endif

" Netrw keybindings similar to NERDTree
" This hides the annoying netrw banner
let g:netrw_banner = 0
" This makes the listing style tree-like
let g:netrw_liststyle = 3
" This opens the file in the main (previous) Vim window rather than in the
" netrw window
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
" This makes the netrw window size only a quarter of the screen's width
"let g:netrw_winsize = 25
" The following makes Netrw be a constant addition to the left margin
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END
"

" Keybindings for buffers. Note that changing buffers is relevant for the
" entire vim session, not just the current buffer, so according to my personal
" convention I should be using <leader> instead of , . However, in this case
" we're making an exception for ergonomics.
" Display buffers and wait for input to choose one (l for ls).
nnoremap ,l :ls<CR>:b
" Same as before but display all buffers, including unlisted ones
nnoremap ,<S-l> :ls!<CR>:b
" Go to next buffer (n for next)
nnoremap ,n :bn<CR>
" Go to previous buffer (b for before)
nnoremap ,b :bp<CR>
" Go to opposite (alternate buffer)
nnoremap ,m :b#<CR>

" Similar keybinding for displaying registers
nnoremap ,r :register<CR>


" The following keybindings quickly open .vimrc (and load it), my wiki index
" and i3 config file
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>s :source $MYVIMRC<CR>
nnoremap <leader>i :call LaunchVimwiki()<CR>
nnoremap <leader>c :e ~/repos/dotfiles/config<CR>
nnoremap <leader>b :e ~/.bashrc<CR>

"python with virtualenv support TODO Check if you see any difference
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(open(activate_this).read(), dict(__file__=activate_this))
EOF

" CtrlP configuration
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'

" Keep the window margin 3 lines away from the cursor
set scrolloff=3

" The Redir command allows you to redirect the output of every command to a
" scratch window. For instance, to redirect all the lines that contain
" 'pattern', do     :Redir g/pattern
" Or to redirect the out put of ls, do     :Redir !ls
" Obtained from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
    for win in range(1, winnr('$'))
            if getwinvar(win, 'scratch')
                    execute win . 'windo close'
            endif
    endfor
    if a:cmd =~ '^!'
            let cmd = a:cmd =~' %'
                    \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
                    \ : matchstr(a:cmd, '^!\zs.*')
            if a:rng == 0
                    let output = systemlist(cmd)
            else
                    let joined_lines = join(getline(a:start, a:end), '\n')
                    let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
                    let output = systemlist(cmd . " <<< $" . cleaned_lines)
            endif
    else
            redir => output
            execute a:cmd
            redir END
            let output = split(output, "\n")
    endif
    vnew
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    call setline(1, output)
endfunction
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" Change colorscheme based on active buffer
" TODO Instead of comparing with 'wiki' explicitly, create a dictionary where
" you associate each extension to their desired colorscheme, and loop over
" the dictionaries to set the colorscheme, one extension at a time
function! AutomaticColorscheme()
    colorscheme codedark
    let extension = expand('%:e')
    if extension == 'wiki'
        colorscheme blackwhite
    endif 
    set hlsearch
    hi Search cterm=NONE ctermfg=white ctermbg=DarkRed
    hi IncSearch cterm=NONE ctermfg=white ctermbg=DarkGreen
endfunction
augroup ColorschemeForBuffers
    autocmd!
    autocmd BufEnter * :call AutomaticColorscheme()
augroup END

" Map Y to y$ so that C, D and Y behave in the same way
nnoremap <S-y> y$

" Remap : to <space> for easier typing
nnoremap <space> :
vnoremap <space> :

" Function to be able to see the changes between the current buffer and its
" saved version in the filesystem. It can be launched with :DiffSaved
" Copied from https://stackoverflow.com/questions/749297/can-i-see-changes-before-i-save-my-file-in-vim
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Make <C-a> go to the beginning of the Vim command line, like in the shell
" Note that the usual <C-e> to go to the end already works by default
cnoremap <C-a> <C-b>

" Make <C-a> and <C-e> in insert and select modes behave like in the command line, going
" to the beginning and end of the line respectively
inoremap <C-a> <Esc>^i
inoremap <C-e> <End>
snoremap <C-a> <Esc>^i
snoremap <C-e> <End><Esc>i

" Make mapping so that Shift-Arrow increase and reduce the window size in normal
" mode. As with the Vimwiki diary mappings for <C-Arrow>, first you need to
" freed <S-Arrow> and then map them.
map [a <S-Up>
map! [a <S-Up>
map [b <S-Down>
map! [b <S-Down>
map [d <S-Left>
map! [d <S-Left>
map [c <S-Right>
map! [c <S-Right>

nnoremap <S-Up> <C-w>+
nnoremap <S-Down> <C-w>-
nnoremap <S-Left> <C-w><
nnoremap <S-Right> <C-w>>

" Make mapping so that  <C-w>_ and <C-w>| create horizontal and vertical
" splits respectively
nnoremap <C-w>_ :Hex<CR><C-w>=
" Vex! creates the split to the right
nnoremap <C-w><Bar> :Vex!<CR><C-w>=

" Useful text objects by romainl (there are more at https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20)
" 24 simple text objects
" ----------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i# i=
" a_ a. a: a, a; a| a/ a\ a* a+ a- a# a=
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' , '=']
	execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
	execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
	execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor
" line text objects
" -----------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>
" number text object (integer and float)
" --------------------------------------
" in
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" <S-j> and <S-k> add blank lines below and above respectively
" Note that this stills leaves H, M and L for moving the cursor
" within the window
nnoremap <silent><S-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><S-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Add mappings to make (save) current session and load it. Three <leader> to avoid doing
" it by mistake
nnoremap <leader><leader>m :mksession! ~/.vim/.saved_session<CR>
nnoremap <leader><leader>l :source ~/.vim/.saved_session<CR>

" Add mappings to delete first swap file (useful when laptop freezes and you
" need to recover many files and also delete their many swap files)
function! DeleteFirstSwapFile()
    let dirname = expand('%:p:h')
    let filename = expand('%:t')
    " Only add the initial dot if the filename is not hidden already. If it is
    " hidden (i.e. if it already has an initial dot) then there is no need to
    " add it
    if filename[0] != '.'
        let filename = '.' . filename
    endif
    let swapfile = dirname . '/' . filename . '.swp'
    call delete(swapfile)
endfunction
nnoremap <leader><leader>d :call DeleteFirstSwapFile()<CR>

" Useful commands to view and navigate table (csv or tsv) files
" - <C-h> and <C-l> scroll half a page laterally, similarly to <C-d> and <C-u>
" - For consistency, set <C-j> and <C-k> to scroll up and down too. This is
"   probably more ergonomic as well
" - ,t activates view of the current buffer as  a table (remember that ,
"   commands usually do something related to the current buffer)
" - sidescroll=1 allows to move the screen by 1 position at a time when moving
"   the cursor with h and l
set nostartofline
set sidescroll=1
nnoremap <C-q> zH
nnoremap <C-s> zL
function! ViewTable()
    set nowrap
    set nowrite
    RainbowAlign
endfunction
nnoremap ,t :call ViewTable()<CR>

" COMMANDS USEFUL FOR TERMINAL
" Open terminal with <leader><CR>, similarly to how you open a terminal in i3 with $mod+<CR>
nnoremap <leader><CR> :term ++close ++rows=12<CR>
" Close terminal with <C-d> similar to how you close a terminal everywhere
" else
tnoremap <C-d> exit<CR>:q<CR>
" Getting to terminal mode with just pressing <Esc>. Both mappings, <Esc> and
" <Esc><Esc> are needed, since:
" - If we map only <Esc>, using the arrow keys (to go to previous commands,
"   for instance) won't work and will put the terminal in normal mode, since
"   arrow keys are represented with a code starting with <Esc>
" - If we map only <Esc><Esc>, pressing <Esc> and waiting for 1s doesnt' put
"   the terminal in normal mode
" - If we map both <Esc> and <Esc><Esc>, we can use the arrow keys and we can
"   go into terminal mode either by pressing <Esc> and waiting for 1s, and by
"   pressing <Esc> twice quickly
tnoremap <Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n>

" Maximize and minimize windows
function! ZoomInCurrentWindow()
    let bufnum = winbufnr(0) "Needed because setpos() doesn't work across buffers. See https://github.com/vim/vim/issues/1621
    let cursor_position = getcurpos()
    if exists("w:is_zoomed")
        quit
        execute "b" . bufnum
        call setpos('.', cursor_position)
    else
        tabe %
        execute "b" . bufnum
        call setpos('.', cursor_position)
        let w:is_zoomed = 1
    endif
endfunction
nnoremap <C-w>z  :call ZoomInCurrentWindow()<CR>
tnoremap <C-w>z  <C-\><C-N>:call ZoomInCurrentWindow()<CR>i

" Change windows 
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
tnoremap <C-k> <C-w>k
tnoremap <C-j> <C-w>j
inoremap <C-k> <C-o><C-w>k
inoremap <C-j> <C-o><C-w>j
inoremap <C-l> <C-o><C-w>l
inoremap <C-h> <C-o><C-w>h

" <C-h> and <C-l> are not mapped in the terminal because <C-l> is supposed to
" clear the screen in the terminal
" Freed <C-l> in Netrw
nnoremap <leader><leader><leader><leader><leader><leader>l <Plug>NetrwRefresh

" Copying in terminal mode (same as copying to clipboard in normal mode)
tnoremap <C-p> <C-w>"+p

" Make it easy to scroll in Vim terminal by going into normal mode with the
" scroll wheel, and going out of it with right click
function! ExitNormalMode()
    unmap <buffer> <silent> <RightMouse>
    call feedkeys("a")
endfunction
function! EnterNormalMode()
    if &buftype == 'terminal' && mode('') == 't'
        call feedkeys("\<c-w>N")
        call feedkeys("\<c-y>")
        map <buffer> <silent> <RightMouse> :call ExitNormalMode()<CR>
    endif
endfunction
tmap <silent> <ScrollWheelUp> <c-w>:call EnterNormalMode()<CR>

" Command to copy contents of cell
function! CopyCell()
    " Save content of clipboard in unused register
    let @z = getreg('+')
    " Copy cell (delimited by ##{ and ##}) to clipboard
    let @+ = ''
    exe '?##{?+1;/##}/-1y +'
    " Paste clipboard to IPython command line, using IPython's %paste magic
    wincmd j
    call term_sendkeys(bufnr("%"), "%paste\<CR>")
    wincmd k
    " Move to the last character of the previously yanked text (copied from
    " vim-cellmode)
    execute "normal! ']"
    " Move three line down
    execute "normal! 3j"
    " Recover the content of the clipboard (cannot do this because the
    " terminal is executed after recovering the clipboard)
    "echo getreg('+')
    "let @+ = getreg('z')
endfunction
nnoremap <silent> <C-b> :call CopyCell()<CR>
 
" Set path to search recursively for all the directories in the respos folder 
" Using ** is not the best option because it may take a very long time, but
" for my number of files it is ok
set path=~/repos/**
nnoremap <leader>f :find 

" Disable vim-sneak highlight so that it behaves more like the f and t motions
hi! link Sneak Normal
" Replace f, F, t, T for the vim-sneak versions, which can jump across lines
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" Make : be equivalent to , to be able to quickly go back in f, F, t, T and s,
" S motions. This is a good strategy because:
" - Currently, , is part of other keybindings, like ,l (to list buffers), and
"   so if we use , to go back in the motions above, we have to wait a 1s
"   timeout
" - : is usually used to access command mode, but I have the whitespace for
"   that
"nnoremap : ,
map : <Plug>Sneak_,
" XXX The above is actually very dangerous, because if any mappings with nmap
" use :, then we'll actually be pressing , instead of entering the command
" line. As a result I had to change a bunch of commands above from nmap to
" nnoremap. If problems arise, consider this a possible source


" Vimtex configuration
let g:vimtex_view_method = 'zathura'
nnoremap <localleader>lw :VimtexCountWords<CR>
" CHECK IF THE FOLLOWING WORKS. It is supposed to be a list of regex to
" filter. It DOESN'T WORK TODO 
 let g:vimtex_log_ignore = ['^.*Warning.*$']

" Display line equivalent of o and O. gO adds an additional line of space
" below because we usually want the stuff below to go away and not bother us
nnoremap go  i<CR>
nnoremap gO  i<CR><Esc><Up>A

" Display line equivalent of I and A
nnoremap gA g$a
nnoremap gI g^i

" Make Vim remember last cursor position in a file
if has("autocmd")
    augroup RememberCursorPosition
        au!
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
endif

" Make g[ select last pasted text, copying gv, which selects last seleted text
nnoremap g[ `[v`]
vnoremap g[ <Esc>`[v`]


" Make '"%P' in normal mode paste the entire path to the file (similar to '"%p', 
" which pastes just the filename)
nnoremap "%<S-p> i<C-r>=expand("%:p")<CR><Esc>
" Make an explicity keybinding '"%p' in normal mode that pastes just the
" filename. This would usually be redundant, since "%p already pastes the
" filename by default. But it is useful because Vimwiki sometimes pastes full
" path instead of just the filename due to a design flaw:  https://github.com/vimwiki/vimwiki/issues/1015
nnoremap "%p i<C-r>=expand("%:t")<CR><Esc>


" Create function that updates the title of the current file, according to the
" filename
function! UpdateTitle()
    " Get filename name
    let filename = expand('%:t')
    " Remove .wiki extension
    let filename = split(filename, '\.wiki')[0]
    " Replace '= OLD_TITLE =' by '= filename =' in line 1 only
    execute '1s/= .* =/= ' . filename . ' =/'
endfunction
command! UpdateTitle call UpdateTitle()


" Trying out this simple fold configuration from https://stackoverflow.com/questions/357785/what-is-the-recommended-way-to-use-vim-folding-for-python-code
" Maybe try this other plugin too:   https://github.com/tmhedberg/SimpylFold
" (yes, it's SimpylFold and not SimplyFold)
set foldmethod=indent
set foldnestmax=2
" If we are in the quickfix window, we don't want to change the behaviour of
" <CR>, o else we won't be able to select from the quickfix list with <CR>
" https://vi.stackexchange.com/questions/3127/how-to-map-enter-to-custom-command-except-in-quick-fix
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : 'za'
vnoremap <CR> zf
nnoremap z<CR> zO

" This will make Ctrl-XA move the cursor whenever a change happens
let g:CtrlXA_move = 1

" Keybinding to surround in codeblock
vnoremap <S-s>c dO{{{><CR><Esc>p`]a<CR>}}}<Esc>

" Keybinding to change indentation of single line with a single key press
" (note that l after < or > is an arbitrary key, it could also be j, for example)
nnoremap < <l
nnoremap > >l

" Useful visual keybindings
" Keybinding to visually select within line, without the newline at the end
" nnoremap vil ^v$<Left>
" nnoremap <C-v>ip {<Down><C-v>}<Up> "I want this to be a way to block select
" a paragraph, but it doesn't work if the paragraph is right at the end of the
" file because it requires to first go to the line below hte paragraph and
" then up

" Insert digraphs with <C-i> (can think of it as "special insert")
inoremap <C-@> <C-k>
"inoremap <C-2> <C-k>
"TODO Currently this only works after manually sourcing, probably because of a
"clash with <C-k> in UltiSnips. Fix

"Mappings for Vim fugitive
nnoremap <leader>g :G<CR>
function! IsFugitiveDiffScratchWindow()
    let buffer_name = bufname("%")
    let string_index = stridx(buffer_name,"fugitive")
    if string_index == 0
        return 1
    else
        return 0
    endif
endfunction
function! IsFugitiveStatusWindow()
    let buffer_name = bufname("%")
    let string_index = stridx(buffer_name,"\.git/index")
    if string_index == -1
        return 0
    else
        return 1
    endif
endfunction

"Mappings for quickfix window (copied from tpope's unimpaired)
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [c :cclose<CR>
nnoremap [o :copen<CR>
