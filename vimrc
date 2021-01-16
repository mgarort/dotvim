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
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'ojroques/vim-oscyank'
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




" This is the minimal Vimwiki stuff that needs to be defined in my vimrc
" instead of in the vimwiki.vim specific file
set nocompatible
filetype plugin on
syntax on




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
nnoremap <BS> :call CloseThisBuffer()<CR>
" Needed to freed <BS> in Vimwiki
nnoremap <Leader>wb <Plug>VimwikiGoBackLink

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

" map keys to copy to and paste from the system clipboard. This way you can
" interact with other applications. For example, you can copy to clipboard to
" search Vim text in Firefox, and you can paste from clipboard to use a
" solution you have found online.
" - Pasting from clipboard: use the usual register + (for example to search 
"   stuff in Firefox). For Vim to be able to copy to system clipboard, it must 
"   be compiled with the +clipboard. I usually use the binary vim-gtk, which 
"   can be installed with      sudo apt install vim-gtk
" - Copying from clipboard: rather than copying to the usual clipboard
"   registers + and *, we use the terminal escape sequence OSC52. For this,
"   you need to:
"   - Enable OSC52 support by urxvt: OSC52 is not supported by default, but it
"   can be added with the perl extension "52-osc" (in your dotfiles). 
"   - Enable OSC52 functionality in Vim: through the plugin "ojroques/vim-oscyank"
vnoremap <C-y> :OSCYank<CR>
map <C-p> "+p
" Copy the last Vim selection to clipboard TODO Need to do this through
" vim-oscyank too, rather than using the system clipboard
nnoremap <leader>+ :OSCYankReg "<CR>


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


" The following keybindings quickly open important files like:
" - ~/.vim files
" - my wiki index
" - i3 config file
" - bashrc
" - etc...
nnoremap <leader>v :Explore $HOME/.vim<CR>
nnoremap <leader>vv :e $MYVIMRC<CR>
nnoremap <leader>va :Explore $HOME/.vim/after<CR>
nnoremap <leader>vp :Explore $HOME/.vim/plugin<CR>
" t for template (it is indeed the HTML template, and the extension is .tpl
" for template)
nnoremap <leader>t :e ~/repos/wiki/setup/default.tpl<CR>
nnoremap <leader>i :call LaunchVimwiki()<CR>
nnoremap <leader>c :e ~/repos/dotfiles/config<CR>
nnoremap <leader>x :e ~/.Xdefaults<CR>
nnoremap <leader>b :e ~/.bashrc<CR>

" The following keybinding reloads vimrc and also does :e to load filetype
" specific configurations (such as those in after/ftplugin/vimwiki.vim). This
" allows us to split the vimrc into general stuff and filetype specific stuff,
" and still be able to reload all the configurations with one keybinding.
" Also, set noautowriteall so that :e does not automatically write unsaved changes
nnoremap <leader>s :source $MYVIMRC<CR>:e<CR>
set noautowriteall

" Quickly check modifications wrt the saved version
nnoremap <leader>d :DiffSaved<CR>

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
let g:ctrlp_map = '<leader>,'
let g:ctrlp_cmd = 'CtrlP'

" fzf configuration
nnoremap <leader>p :Files<CR>

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

" Make <C-a> and <C-e> in insert and select modes behave like in the command line, going
" to the beginning and end of the line respectively
inoremap <C-a> <Esc>^i
inoremap <C-e> <End>
snoremap <C-a> <Esc>^i
snoremap <C-e> <End><Esc>i
" Make <C-b> and <C-f> in insert mode behave similarly to how <Alt-b> and 
" <Alt-f> behaves in the command line, i.e. going back and advancing one 
" word at a time
inoremap <C-b> <Esc><Right>bi
inoremap <C-f> <Esc><Right>ei

" Make 0 a 'smart' go to start of line: if we press it once, we go to the
" first non-blank character, and if we press it twice, we go to the actual
" start of the line
" From https://www.reddit.com/r/vim/comments/kn0cpp/key_mappings_everyone_uses/
nnoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
vnoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? '0' : '^'


" When using <CTRL-U>, <CTRL-W>, <Enter> or <Tab> in Insert-mode, do <CTRL-G>u
" first to start a new change so that I can undo these operations with
" u in Normal/Command mode, rather than undoing the entire Insert
" operation at once.
" From https://www.reddit.com/r/vim/comments/kn0cpp/key_mappings_everyone_uses/
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <C-J> <C-G>u<C-J>
inoremap <NL> <C-G>u<NL>
inoremap <C-M> <C-G>u<C-M>
inoremap <CR> <C-G>u<CR>
inoremap <Tab> <C-G>u<Tab>
" TODO For some reason, moving the cursor with the arrow keys seems to break
" the undo sequence too. Investigate if this is the reason

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

" Make vim-sneak mappings more consistent in visual mode by making s go to next match and S
" go to previous match, while keeping vim-surround functionality through z 
" (mnemonics: vim-zurround) Explained in this GitHub issue:
" https://github.com/justinmk/vim-sneak/issues/268
"
" So now the behaviour is:
" - Normal: s and S to move with sneak
" - Visual: s and S to move with sneak, z to surround (zurround)
" - cs and ds: change/delete matching characters (), [], {}... with
"   vim-surround
let g:surround_no_mappings= 1
xmap <S-s> <Plug>Sneak_S
xmap z <Plug>VSurround
nmap yzz <Plug>Yssurround
nmap yz  <Plug>Ysurround
nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround



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


" SECTION Command line mode

" Open history of previous commands with <C-r>, similar to the terminal
" :History is part of fzf.vim
cnoremap <C-r> History<CR>

" Make <C-a> go to the beginning of the Vim command line, like in the shell
" Note that the usual <C-e> to go to the end already works by default
cnoremap <C-a> <C-b>

" Make file completion in command mode (e.g. when opening a file in a buffer
" with :e) more similar to Bash completion
set wildmenu
set wildmode=longest,list





" SECTION  Not sorted yet. Things to be sorted

" Enable jumping to matching angle bracket with % 
" source: https://www.reddit.com/r/vim/comments/kr9rnu/how_to_jump_to_matching_anglebracket_using/
set matchpairs+=<:>


" Delete text in select mode without affecting the registers TODO
" function! DeleteSelectMode()
" endfunction
" snoremap <CR> <Esc>gv"_c
" snoremap a <Esc>gv"_ca



" Allow to select rectangular blocks even in regions with no text
set virtualedit=block

" Try setting g by default (since it's rare that you need a single
" substitution). If you DO need a single substitution, you can add g t the
" end, and it will toggle off gdefault
set gdefault

" Strip comment character when joining comment lines
set fo+=j
