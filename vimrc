" My vimrc file. To locate in ~/.vim/vimrc and to be used with the HUGE version
" of Vim (all details about the Vim version used in corona are in
" dotvim/.vim_version_on_corona.txt). Remember that you need to install Vundle, before installing the plugins, which you do with:
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

" -------------------------
" SECTION:  Core configuration: Vundle, nocompatible, filetype...
" ------------------------
"
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
" Plugin 'ycm-core/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'honza/vim-snippets'
Plugin 'SirVer/ultisnips'
Plugin 'tomasiser/vim-code-dark'
Plugin 'vimwiki/vimwiki'
Plugin 'justinmk/vim-sneak'
Plugin 'mechatroner/rainbow_csv'
Plugin 'qpkorr/vim-bufkill'
Plugin 'tpope/vim-fugitive'
Plugin 'wellle/targets.vim'
Plugin 'ap/vim-css-color'
Plugin 'Konfekt/vim-CtrlXA'
Plugin 'romainl/vim-cool'
" Plugin 'vim-scripts/SearchComplete'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'ojroques/vim-oscyank'
Plugin 'godlygeek/tabular'
Plugin 'jeetsukumaran/vim-pythonsense'
Plugin 'airblade/vim-matchquote'
Plugin 'nvie/vim-flake8'
Plugin 'chrisbra/recover.vim'
Plugin 'mattn/calendar-vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required (note that this automatically guesses indents for
                             " Python, etc, when you're writing code, so it's very useful)
" To ignore plugin indent changes, instead use:
filetype plugin on

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


" To make the British keyboard more ergonomic in Vim:
" - Use # instead of \ as a leader
" - Use £ instead of # to search for previous occurrence of word under cursor
let mapleader = "#"
nnoremap £ #


" This command is relevant to the Vimwiki configuration because it
" binds <BS> (backspace) to closing the buffer so that navigation in Vimwiki
" doesn't leave a trail of open buffers behind. But it will also work for
" non-Vimwiki files. The function CloseThisBuffer() ensures that if there is
" no open buffer, <BS> will close Vim
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

function! IsCalendarWindow()
    let buffer_name = bufname("%")
    if buffer_name == '__Calendar'
        return 1
    else
        return 0
    endif
endfunction

function! CloseThisBuffer()
    if bufname("%") == ""
        q
    elseif IsFugitiveDiffScratchWindow() == 1
        bd
    elseif IsFugitiveStatusWindow() == 1
        q
    elseif IsCalendarWindow() == 1
        q
    else
        BD
    endif
endfunction
nnoremap <BS> :call CloseThisBuffer()<CR>
" Needed to freed <BS> in Vimwiki
nnoremap <leader>wb <Plug>VimwikiGoBackLink

" Set case options:
" - ignorecase ignores the case when searching
" - smartcase overrides ignorecase and pays attention to case, but only when
"   capital letters are included in the search
set ignorecase
set smartcase


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
augroup CorrectBufferTypeDuringSCP
    au!
    autocmd BufRead scp://* :set bt=
    autocmd BufWritePost scp://* :set bt=
augroup END

" TODO Check if the following line was only applicable to YouCompleteMe, or it
" is still relevant
set completeopt-=preview  " avoid the annoying preview window, that shows the documentation of whatever function you are autocompleting, and then stays open

" This mouse behaviour is the closest to what I wanted. It only allows to
" sccroll and select cursor position with mouse in normal mode
set mouse=n

set backspace=indent,eol,start " To make sure that backspace works in every system
syntax on                      " to make sure that syntax is highlighted in every system

" Avoid mouse setting cursor
" noremap <LeftMouse> ma<LeftMouse>`a
augroup NO_CURSOR_MOVE_ON_FOCUS
    au!
    au FocusLost * let g:oldmouse=&mouse | set mouse=
    au FocusGained * if exists('g:oldmouse') | let &mouse=g:oldmouse | unlet g:oldmouse | endif
augroup END

" Allow to open other buffers when current file is unsaved
set hidden




" -----------
" | SECTION | Appearance
" -----------

" Set numbers
set number                     " Show current line number
set relativenumber             " Show relative line numbers

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

" Keep the window margin 3 lines away from the curso
set scrolloff=3

" Display as much of wrapped lines as possible, rather than hiding partial
" lines
set display=lastline

" Make new windows open below and to the right
set splitbelow
set splitright


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

" Color cursor. Vim isn't able to change the cursor color by itself in a colorscheme:
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



" -----------
" | SECTION | Keybindings starting with comma
" -----------
"
" Usually the comma , is used for the following kind of actions:
" - Current buffer: show differences of the current buffer and the saved file,
"                   show the current buffer in HTML...
" - Buffer navigation: go to alternate buffer, show buffer list...
" - Lists: show buffer list, show register list, show fuzzy finder list...

" Display buffers and wait for input to choose one (l for ls).
nnoremap ,l :ls<CR>:b
" nnoremap ,l :Buffers<CR>
" Same as before but display all buffers, including unlisted ones
nnoremap ,<S-l> :ls!<CR>:b
" nnoremap ,<S-l> :BuffersAll<CR>
" Same as before but display previously opened files
nnoremap ,<C-l> :History<CR>
" Go to next buffer (n for next)
nnoremap ,n :bn<CR>
" Go to previous buffer (b for before)
nnoremap ,b :bp<CR>
" Go to opposite (alternate buffer)
nnoremap ,m :b#<CR>
" Quickly check modifications wrt the saved version
nnoremap ,d :DiffSaved<CR>

" Display registers (not related to the current buffer only, but it has a
" display similar to showing the buffer list, so it makes sense to use , as a
" mnemonic)
nnoremap ,r :register<CR>

" -----------
" | SECTION | Important keybindings starting with <leader>.
" -----------
"
" <leader> is generally used for either:
" - Actions affecting the entire state of the session: like sourcing vimrc
" - Going to an important file or location: like vimrc, bashrc, i3 config...
" - Dangerous actions that shouldn't be easily reachable so that they are not
"   performed by mistake: delete swp file, save session, load session...
"
" In contrast, comma , is generally used for:
" - Buffer actions: whereas specific to the current buffer, or related to
"   buffer motion.
" - List actions: show open buffers, unlisted buffers, past buffers... or show
"   list of registers.

"   TODO Maybe add another bulletpoint that simply says "actions that are
"   ergonomic to <leader>? Like fuzzy search

" The following keybindings quickly open important files like:
" - ~/.vim files
" - my wiki index
" - i3 config file
" - bashrc
" - etc...
" d for directory
nnoremap <leader>vd :Explore $HOME/.vim<CR>
" v for vimrc
nnoremap <leader>vv :e $MYVIMRC<CR>
" a for after
nnoremap <leader>va :Explore $HOME/.vim/after<CR>
" a for bundle
nnoremap <leader>vb :Explore $HOME/.vim/bundle<CR>
" f for filetype
nnoremap <leader>vf :Explore $HOME/.vim/ftplugin<CR>
" p for plugin
nnoremap <leader>vp :Explore $HOME/.vim/plugin<CR>
" w for wiki
nnoremap <leader>vw :e $HOME/.vim/plugin/vimwiki.vim<CR>
" r for repositories
nnoremap <leader>r :Explore $HOME/repos<CR>
nnoremap <leader>ru :Explore $HOME/repos/utils<CR>
nnoremap <leader>rg :Explore $HOME/repos/guatask<CR>
nnoremap <leader>rv :Explore $HOME/repos/dotvim<CR>
nnoremap <leader>rf :Explore $HOME/repos/dotfiles<CR>
" h for HTML (since this is the HTML template and it's written in html)
nnoremap <leader>h :e ~/repos/notes/setup/default.tpl<CR>
nnoremap <leader>i :call LaunchVimwiki()<CR>
nnoremap <leader>c :e ~/repos/dotfiles/config<CR>
nnoremap <leader>x :e ~/repos/dotfiles/dot.Xdefaults<CR>
" <leader>bb for the main .bashrc, similar to how <leader>vv takes us to the main vimrc
nnoremap <leader>bb :e ~/repos/dotfiles/bashrc/dot.bashrc_common<CR>
" Distinguish specific bashrc for the second letter
nnoremap <leader>ba :e ~/repos/dotfiles/bashrc/dot.bashrc_aliases<CR>
nnoremap <leader>bf :e ~/repos/dotfiles/bashrc/dot.bashrc_functions<CR>
nnoremap <leader>bg :e ~/repos/dotfiles/bashrc/dot.bashrc_git<CR>
nnoremap <leader>bl :e ~/repos/dotfiles/bashrc/dot.bashrc_local<CR>
nnoremap <leader>br :e ~/repos/dotfiles/bashrc/dot.bashrc_remote<CR>
nnoremap <leader>uu :UltiSnipsEdit<CR>
function! OpenVimSnippets()
    let ft = &l:filetype
    let snippets = '$HOME/.vim/bundle/vim-snippets/snippets/' . ft . '.snippets'
    echo snippets
    exe 'e' . snippets
endfunction
nnoremap <silent> <leader>us :call OpenVimSnippets()<CR>

nnoremap <leader>f :find

" The following keybinding reloads vimrc and also does :e to load filetype
" specific configurations (such as those in after/ftplugin/vimwiki.vim). This
" allows us to split the vimrc into general stuff and filetype specific stuff,
" and still be able to reload all the configurations with one keybinding.
" Also, set noautowriteall so that :e does not automatically write unsaved changes
nnoremap <leader>s :source $MYVIMRC<CR>:e<CR>
set noautowriteall

" Search with fzf
nnoremap <leader>p :Files<CR>

" Search with grep
function! SearchWithGrep()
    let search = input('Search for:  ')
    " Check if there are uppercase characters. If there are, we will grep
    " case-sensitively. If there aren't, we will grep case-insensitively. This
    " is similar to the behaviour of "set ignorecase, set smartcase"
    let is_upper = match('sdfs',"\u")
    " The redirection at the end is so that no output is printed to the
    " terminal. Otherwise grep clutters the screen for the output of later
    " commands
    if is_upper == -1
        silent exe 'grep! -i "' . search . '" *.wiki diary/*.wiki'
    else
        silent exe 'grep! "' . search . '" *.wiki'
    endif
    copen
endfunction
nnoremap <leader>o :call SearchWithGrep()<CR>



" remove conflicting/annoying maps
nmap <leader><leader><leader><leader><leader>psdfs  <Plug>BufKillAlt
nmap <leader><leader><leader><leader><leader>asdjf  <Plug>BufKillUndo
nmap <leader><leader><leader><leader><leader>khbff  <Plug>BufKillBw
nmap <leader><leader><leader><leader><leader>rfkhk  <Plug>BufKillBd
nmap <leader><leader><leader><leader><leader>slfkj  <Plug>BufKillBun
nmap <leader><leader><leader><leader><leader>nbgfh  <Plug>BufKillForward
nmap <leader><leader><leader><leader><leader>burib  <Plug>BufKillBack

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







" HERE ENDS THE SECTION TODO Remove this indication once the sections are well
" defined



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
    " Colorscheme and highlighting trailing spaces
    " - Highlighting trailing spaces is only in non-vimwiki files
    " - Highlighting trailing spaces is not done in insert mode. This is
    "   achieved through the augroup and autocommands
    let this_filetype = &l:filetype
    if this_filetype == 'vimwiki'
        colorscheme blackwhite
    elseif this_filetype == 'calendar'
        colorscheme blackwhite
    elseif this_filetype == 'tex'
        colorscheme codedark
    elseif this_filetype == 'datatable'
        :
    elseif this_filetype == 'tsv'
        :
    elseif this_filetype == 'csv'
        :
    else
        colorscheme codedark
        " Autocommands from https://stackoverflow.com/a/4617156/7998725
        augroup ExtraWhitespaceAugroup
            autocmd!
            highlight ExtraWhitespace ctermbg=green guibg=green
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
            autocmd InsertLeave * match ExtraWhitespace /\s\+$/
            autocmd BufWinLeave * call clearmatches()
        augroup END
    endif
    " Search coloring
    set hlsearch
    hi Search cterm=NONE ctermfg=white ctermbg=DarkRed
    hi IncSearch cterm=NONE ctermfg=white ctermbg=DarkGreen
endfunction
augroup ColorschemeForBuffers
    autocmd!
    autocmd BufEnter * :call AutomaticColorscheme()
    autocmd WinEnter * :call AutomaticColorscheme()
augroup END


" Function to be able to see the changes between the current buffer and its
" saved version in the filesystem. It can be launched with :DiffSaved
" Copied from https://stackoverflow.com/questions/749297/can-i-see-changes-before-i-save-my-file-in-vim
function! s:DiffWithSaved()
    " Disable diff in all buffers. This is because if there are any lingering
    " diff from previous diff comparisons, the current comparison will be
    " mangled. From https://vi.stackexchange.com/questions/701/diffoff-on-all-buffers
    bufdo diffoff
    " Save filetype for later
    let filetype=&ft
    " Enable diff in the original file
    diffthis
    " Copy the original file to a new vertical split, and remove the spurious
    " empty first line that results from copying
    vnew | r # | normal! 1Gdd
    " Diff the copy
    diffthis
    " In the copy's buffer, indicate:
    " - buftype nofile: buffer not related to any file and which won't be
    "   written
    " - bufhidden wipe: when the buffer stops being displayed, wipe it out
    "   from the buffer list
    " - nobuflisted: don't show buffer in the buffer list
    " - readonly: do not write
    " - filetype: set to whatever it was saved at the beginning
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    " Fold everything possible. Needed because sometimes the new split is not
    " folded automatically after vimdiff
    normal! zM
endfunction
com! DiffSaved call s:DiffWithSaved()





" -----------
" | SECTION | UltiSnips and autocomplete popup window    (Tab configuration)
" -----------
"
" This section contains the configuration for the following functionalities:

" - Snippet expansion with <Tab>
"       - Jumping forward and backward in snippets with <Tab> and <S-Tab>
" - Autocomplete popup with <S-Tab>
"       - Iterating forward and backward in the autocomplete popup with <Tab and <S-Tab>

" Triggering autocompletion doesn't automatically select the first item in the
" list. The user has to explicitly choose an item
set completeopt=menu,preview,noselect,menuone

" Expansion trigger will be <Tab>, but it needs to be manually and very finely
" configured. So we set it to <F11> here so that UltiSnips doesn't take over
let g:UltiSnipsExpandTrigger='<F11>'
let g:UltiSnipsJumpForwardTrigger='<C-j>'
let g:UltiSnipsJumpBackwardTrigger='<C-k>'

" TODO Autocomplete more finely for filename completion in Python filename
" strings. Maybe autocomplete should first try file
" completion, and if it doesn't work, word completion. Sometimes we'll want
" word completion even if there is a slash in the current line, because there
" could be a slash somewhere else, but we could be outside of a filename
" string
" is_there_sk
" TODO in addition to Python filename strings, activate filename completion
" also when we are in a Vimwiki link, since you very often create links to
" other notes (files), so it would be very useful.
"
"
"
" If autocomplete popup window is visible, <S-Tab> returns <C-p>. If not
" visible, it tries to open either filepath completion (if current line
" contains slashes '/' ) or word completion (if current line does not contain
" slashes)
" function! CheckWhetherSlashInQuotes()
" endfunction
" function! CheckWheterCursorInQuotes()
" endfunction
" function! CheckWhetherCursorInFilename()
"     let is_cursor_in_quotes = CheckWhetherCursorInQuotes()
"     let is_slash_in_quotes = CheckWhetherSlashInQuotes()
"     " Check syntax of the next, not sure if correct
"     let is_cursor_in_filename = is_cursor_in_quotes & is_slash_in_quotes
"     return is_cursor_in_filename
" endfunction

" <S-Tab> triggers completion from current buffer
function! ShiftTab()
    let is_popup_visible = pumvisible()
    if is_popup_visible
        return "\<C-p>"
    else
        " We suppose to be completing filepaths if current line has slashes
        " TODO Use another method (see previous TODO)
        " Maybe we could do:
        " let is_cursor_in_filename = CheckWhetherCursorInFilename()
        let is_there_slash = match(getline('.'),'/')
        if is_there_slash == -1
            return "\<C-x>\<C-n>"
        else
            return "\<C-x>\<C-f>"
        endif
    endif
endfunction
inoremap <expr> <S-Tab> ShiftTab()
" If a desired word is not found, we can also include other loaded buffers and
" open windows to complete from with <F1>
set complete=.,b,w
inoremap <expr> <F1> pumvisible() ? '<Esc>a<C-n>' : '<F1>'
" If we want to return to the original completion list from only the current
" buffer, we can do that with <F2>
inoremap <expr> <F2> pumvisible() ? '<Esc>a<C-x><C-n>' : '<F2>'
" To select one entry and go back to normal mode, press <Esc> (this is Vim
" default). But to select one entry and stay in normal mode, press <CR> (this
" is my own config)
inoremap <expr> <CR> pumvisible() ? '<Esc>a' : '<C-G>u<CR>'

" We will map <Tab> to our own function ExpandSnippetIfPossibleAndGetResult,
" so that we can create the following behaviour:

" - If upon pressing <Tab> we can expand a snippet, then we don't do anything
"   else. We check that the snippet has been expanded because
"   g:ulti_expand_res = 1.

" - If upon pressing <Tab> we cannot expand a snippet, then we can do one of
"   two things. We check that the snippet has not been expanded because
"   g:ulti_expand_res = 0.

"        - If autocomplete (pumvisible() returns 1), do <C-n> to iterate to the
"        next element of the autocomplete list.
"        - If not autocomplete (pumvisible() returns 0), do <C-g>u<Tab>

let g:ulti_expand_res = 0
function! ExpandSnippetIfPossibleAndGetResult()
    call UltiSnips#ExpandSnippet()
    return g:ulti_expand_res
endfunction

function! TabOrIteratePopup()
    let is_popup_visible = pumvisible()
    if is_popup_visible
        return "\<C-n>"
    else
        return "\<C-g>u\<Tab>"
    endif
endfunction
" If return value of ExpandSnippetIfPossibleAndGetResult is 1, then nothing
" ('') is inserted, but if result is 0, then <C-g>u<Tab> is done
inoremap <silent> <Tab> <C-R>=(ExpandSnippetIfPossibleAndGetResult() > 0) ? '' : TabOrIteratePopup()<CR>




" -----------
" | SECTION | Windows
" -----------

" Make mapping so that  <C-w>_ and <C-w>| create horizontal and vertical
" splits respectively
" nnoremap <C-w>_ :Hex<CR><C-w>=
nnoremap <C-w>_ :sp<CR>
" Vex! creates the split to the right
" nnoremap <C-w><Bar> :Vex!<CR><C-w>=
noremap <C-w><Bar> :vsp<CR>

" Make mapping so that Shift-Arrow increase and reduce the window size in normal
" mode. As with the Vimwiki diary mappings for <C-Arrow>, first you need to
" freed <S-Arrow> and then map them.
set <S-Up>=[a
set <S-Down>=[b
set <S-Left>=[d
set <S-Right>=[c
nmap <S-Up>    <C-w>+
nmap <S-Down>  <C-w>-
nmap <S-Left>  <C-w><
nmap <S-Right> <C-w>>

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



" <C-h> and <C-l> are not mapped in the terminal because <C-l> is supposed to
" clear the screen in the terminal
" Freed <C-l> in Netrw
nnoremap <leader><leader><leader><leader><leader><leader>l <Plug>NetrwRefresh


" Open explorer window to the left
nnoremap <leader>e 20Lexplore


" -------------------------
" SECTION:  Help and info
" ------------------------
"
" Disable <F1> to open the help, which frequently and annoyingly opens help by
" mistake
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
" Maximize help and man windows by default
" From https://stackoverflow.com/questions/24477083/in-vim-how-can-i-automatically-maximize-the-help-window
augroup LargeHelpWindow
    autocmd!
    autocmd BufWinEnter * if &l:buftype ==# 'help' | wincmd _ | endif
    autocmd FileType man wincmd _
augroup END

" Use Vim as a man pager
runtime ftplugin/man.vim
function! ViewManFromCommandLine(command)
    " View doc
    exe "silent! Man " . a:command
    " If man documentation for that command exists, close all other windows.
    if &l:filetype == 'man'
        only
    " Else quit Vim
    elseif &l:filetype == ''
        quit
    endif
endfunction

" Add last-modified info to the message by g<C-g>
function! Improved_g_CTRL_g()
    redir => message
        silent exe "norm! g\<C-g>"
    redir END
    let modified_time = strftime("%c", getftime(bufname("%")))
    let message = message . "\n\n" . modified_time . " (last modified)\n"
    echo message
endfunction
nnoremap g<C-g>  :call Improved_g_CTRL_g()<CR>




" -----------
" | SECTION | Terminal mode
" -----------
"
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

" Left, right, up and down
tnoremap <M-Left> <Left>
tnoremap <M-Right> <Right>
tnoremap <M-Up> <Up>
tnoremap <M-Down> <Down>

" Set path to search recursively for all the directories in the respos folder
" Using ** is not the best option because it may take a very long time, but
" for my number of files it is ok
set path=~/repos/**




" Vimtex configuration
let g:vimtex_view_method = 'zathura'
nnoremap <localleader>lw :VimtexCountWords<CR>
" CHECK IF THE FOLLOWING WORKS. It is supposed to be a list of regex to
" filter. It DOESN'T WORK TODO
 let g:vimtex_log_ignore = ['^.*Warning.*$']



" Make '"%P' in normal mode paste the entire path to the file (similar to '"%p',
" which pastes just the filename)
nnoremap "%<S-p> i<C-r>=expand("%:p")<CR><Esc>
" Make an explicity keybinding '"%p' in normal mode that pastes just the
" filename. This would usually be redundant, since "%p already pastes the
" filename by default. But it is useful because Vimwiki sometimes pastes full
" path instead of just the filename due to a design flaw:  https://github.com/vimwiki/vimwiki/issues/1015
nnoremap "%p i<C-r>=expand("%:t")<CR><Esc>


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

" Insert digraphs with <C-q>
inoremap <C-q> <C-k>

"Mappings for Vim fugitive
nnoremap <leader>g :G<CR>

"Mappings for quickfix window (copied from tpope's unimpaired)
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [c :cclose<CR>
nnoremap [o :copen<CR>



" -----------
" | SECTION | Command line mode
" -----------
"
" Make the command line similar to the shell (emacs keybindings)
"
" Make file completion in command mode (e.g. when opening a file in a buffer
" with :e) more similar to Bash completion
set wildmenu
set wildmode=longest,list

" Better UX for substitution in visual selections
"  From https://www.reddit.com/r/vim/comments/ixs9mv/how_to_avoid_writing_v_in_visual_mode/
function! Cs()
	let cmdline = getcmdline()
        " If the text in the command line starts by "^'<,'>" and the cursor is
        " at position 6, that's because we've just started a command line
        " while a text selection was active. In that case:
        " - If the first character you press is a `s`, then you are starting a
        "   substitution
        " - Since there is an active text selection, substitute in the
        "   selection only by adding \%V
	if cmdline =~ "^'<,'>" && getcmdpos() == 6
		return "s/\\%V"
        " If you are not in the situation above, then typing s doesn't mean
        " that you are starting a substitution in a visual selection. So just
        " type s
	else
		return "s"
	endif
endfunction
cnoremap <expr> s Cs()

" Better UX for tabularizing
" Pressing T in sixth posiiton in visual selection will type 'Tabularize /'
" directly
function! CT()
	let cmdline = getcmdline()
	if cmdline =~ "^'<,'>" && getcmdpos() == 6
		return 'Tabularize /'
	else
		return 'T'
	endif
endfunction
cnoremap <expr> T CT()

" Abbreviate GPull to Gpull and GPush to Gpull since you often type it wrong
cabbrev GPull Git pull
cabbrev GPush Git push
cabbrev gpull Git pull
cabbrev gpush Git push

" Abbreviate :bq to :q so that we can close the buffer list by just pressing q
abbrev bq b

" Abbreviate w] to w to avoid accidentally writing to ]
abbrev w] w


" -----------
" | SECTION | Motions and text editing
" -----------
"
" Make Vim remember last cursor position in a file
if has("autocmd")
    augroup RememberCursorPosition
        au!
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
endif

" Disable gg and change for <S-h> to go to top of file, because you often
" press it by mistake when pressing hh to move couple of characters left
nnoremap gg <Esc>
nnoremap <S-h> gg
xnoremap <S-h> gg

" Make g[ select last pasted text, copying gv, which selects last seleted text
nnoremap g[ `[v`]
vnoremap g[ <Esc>`[v`]

" Enable jumping to matching angle bracket with %
" source: https://www.reddit.com/r/vim/comments/kr9rnu/how_to_jump_to_matching_anglebracket_using/
set matchpairs+=<:>

" Allow to select rectangular blocks even in regions with no text
set virtualedit=block

" With these format options:
" - new comment characters will be added to extend current comments
" - comment characters will be stripped when joining lines with J
set formatoptions=tcroqj

" Stay in same character column when moving with vertical motions like
" <C-d> and <C-u>
set nostartofline
" Move screen by 1 position at a time when moving the cursor with h and l
set sidescroll=1
nnoremap <C-q> zH
nnoremap <C-s> zL

" Map <C-b> to do nothing in insert mode, since I often press it by mistake
" while trying to copy from clipboard and that scrolls the page and makes me
" lose my focus. In the future I can map it to just vimwiki so that I am able
" to execute the current cell in python with <C-b> from insert mode
inoremap <C-b> <Nop>

" If the cursor is quiet for 10s or more, add that position to the jumplist so
" that we can easily return to it
set updatetime=10000
augroup CursorHoldToJumplist
    autocmd!
    autocmd CursorHold * normal! m'
augroup END

" Disable K to look up for documentation, because you never use it
" and it's a hindrance rather than any help
vnoremap <S-k> <Nop>

" Repeat last substitution with & in visual mode too
xnoremap <silent> & :'<,'>s<CR>

" Recognize `.tags` file as well as `tags` file (for ctags), and look for tags in
" upper directories recursively
set tags=./tags;,tags;./.tags;,.tags;

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
nmap dz  <Plug>Dsurround
nmap cz  <Plug>Csurround
omap s <Plug>Sneak_s
" S mapped with v to make it inclusive, similarly to other backward motions in
" my config (0 mapped to v0, ^ mapped to v^, etc)
omap S v<Plug>Sneak_S

" Map Y to y$ so that C, D and Y behave in the same way
nnoremap <S-y> y$

" Remap : to <space> for easier typing
nnoremap <space> :
xnoremap <space> :


" Make backward motions such as b or 0 inclusive (for changing with c)
onoremap b vb
onoremap B vB
omap F v<Plug>Sneak_F
omap T v<Plug>Sneak_T
onoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? 'vg0' : 'vg^'


" When using <Enter> or <Tab> in Insert-mode, do <CTRL-G>u
" first to start a new change so that I can undo these operations with
" u in Normal/Command mode, rather than undoing the entire Insert
" operation at once.
" From https://www.reddit.com/r/vim/comments/kn0cpp/key_mappings_everyone_uses/
inoremap <C-J> <C-G>u<C-J>
inoremap <NL> <C-G>u<NL>
" NOTE <Tab> is also made undoable with <C-g>u<Tab>, but <Tab> is also used to
" expand snippets and to jump forward in snippet expansions and in
" autocomplete popups, the configuration is a bit more involved. See below.
" TODO For some reason, moving the cursor with the arrow keys seems to break
" the undo sequence too. Investigate if this is the reason

" Keybinding for deleting trailing whitespaces
" Make it repeatable with repeat.vim:
" - Wrap it in a <Plug> command
" - Prepare next dot . command with repeat#set after
nnoremap <silent> <Plug>DeleteTrailingWhitespaces :s/\s\+$//<CR>:call repeat#set("\<Plug>DeleteTrailingWhitespaces")<CR>
nmap gt <Plug>DeleteTrailingWhitespaces
" Note that we are using whitespace <space> instead of colon : because <Plug>
" commands force us to use nmap instead of nnoremap

" The same for every line selected in visual mode. We define noremapgt in
xnoremap gt :s/\s\+$//<CR>

" Vim-like undo and redo
nnoremap <S-u> <C-r>
" nnoremap <C-r> <Nop>

" Jump to next and previous closed fold with gj and gk respectively
" By ib. StackOverflow user https://stackoverflow.com/questions/9403098/is-it-possible-to-jump-to-the-next-closed-fold-in-vim
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction
function! RepeatCmd(cmd) range abort
    let n = v:count < 1 ? 1 : v:count
    while n > 0
        exe a:cmd
        let n -= 1
    endwhile
endfunction
nnoremap <silent> gj :<c-u>call RepeatCmd('call NextClosedFold("j")')<cr>
nnoremap <silent> gk :<c-u>call RepeatCmd('call NextClosedFold("k")')<cr>

" Do not keep { } motions in jumplist
" By romainl on https://superuser.com/questions/836784/in-vim-dont-store-motions-in-jumplist
nnoremap } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
nnoremap { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>

" Useful text objects by romainl (there are more at https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20)
" 24 simple text objects
" ----------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i# i=
" a_ a. a: a, a; a| a/ a\ a* a+ a- a# a=
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' , '=','$']
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
" link text objects
" -----------------
function! VisualLink(mode)
    " Modes for text object could be 'in' or 'around'
    if a:mode == 'in'
        let shrink_selection = 1
    elseif a:mode == 'around'
        let shrink_selection = 0
    endif
    " Save cursor position
    let l:cursor_pos = getpos('.')
    " Use search() to search in current line only.
    " Check if there is a link is in the forward direction
    let link_found_forward = search(']]','ceW',line('.'))
    if link_found_forward != 0
        normal v
        " Try to match closing brackets. If not found, turn off visual
        " mode and restore cursor position
        let found_closing_brackets = search('[[','bcW',line('.'))
        if found_closing_brackets == 0
            normal v
            call setpos('.', l:cursor_pos)
            return
        else
            if shrink_selection
                call feedkeys('llohh')
            endif
        endif
    " If there is no link in the forward direction, check in the backward
    " direction
    else
        let link_found_backward = search('[[','bcW',line('.'))
        if link_found_backward != 0
            normal v
            " Try to match closing brackets. If not found, turn off visual
            " mode and restore cursor position
            let found_closing_brackets = search(']]','ceW',line('.'))
            if found_closing_brackets == 0
                normal v
                call setpos('.', l:cursor_pos)
                return
            else
                if shrink_selection
                    call feedkeys('hholl')
                endif
            endif
        else
            return
        endif
    endif
endfunction
xnoremap agl :<C-u>call VisualLink('around')<CR>
onoremap agl :<C-u>normal vagl<CR>
xnoremap igl :<C-u>call VisualLink('in')<CR>
onoremap igl :<C-u>normal vigl<CR>
" TODO Create text object igl
" number text object (integer and float)
" --------------------------------------
" in
function! VisualNumber()
        " First, match the last digit in the number. Explanation:
        " - \d     match a digit
        " - \([^0-9\.]\|$\)     the digit can be followed by the end of line
        "                       $, and cannot be followed by any digit (so
        "                       that we match the very last digit) or by a dot
        "                       (so that we match the very last digit even in
        "                       the presence of a decimal point).
        let match_last_digit = search('\d\([^0-9\.]\|$\)', 'cW', line('.'))
        if match_last_digit == 0
            " Corner case: sometimes the very last digit is followed by a dot,
            "              because the dot is not a decimal point, but a file
            "              extension. For example, file1234.txt . So if the
            "              previous match fails, try to match a digit followed
            "              by a dot
            let match_last_digit_with_dot = search('\d\([^0-9]\|$\)', 'cW', line('.'))
            if match_last_digit_with_dot == 0
                " If nothing works, then abort selection
                return
            endif
        endif
        normal v
        " Finally, match the first digit
        call search('\(^\|[^0-9\.]\d\)', 'becW', line('.'))
endfunction
xnoremap <silent> in :<C-u>call VisualNumber()<CR>
onoremap <silent> in :<C-u>normal vin<CR>

" Similarly to how J or <S-j> collapses many lines into a single line,
" K or <S-k> will unroll every word into its own line
function! ExpandIntoLines()
    normal `<v`>"ky
    call setreg('k', substitute(getreg('k'), '\s\+', '\n', 'g'), getregtype('k'))
    normal `<v`>"kp
endfunction
vnoremap <S-k> :<C-u>call ExpandIntoLines()<CR>

" Make <C-e> go to end of line in select mode. This is the intuitive behaviour
snoremap <C-e> <Esc>A

" Prevent inserting multiple times. I used to do this by mistake, because I
" pressed a number before `i` without intending to
nnoremap 1i i
nnoremap 2i i
nnoremap 3i i
nnoremap 4i i
nnoremap 5i i
nnoremap 6i i
nnoremap 7i i
nnoremap 8i i
nnoremap 9i i
nnoremap 1a a
nnoremap 2a a
nnoremap 3a a
nnoremap 4a a
nnoremap 5a a
nnoremap 6a a
nnoremap 7a a
nnoremap 8a a
nnoremap 9a a
nnoremap 1A A
nnoremap 2A A
nnoremap 3A A
nnoremap 4A A
nnoremap 5A A
nnoremap 6A A
nnoremap 7A A
nnoremap 8A A
nnoremap 9A A


" -------------------------
" SECTION:  Lines: actual lines vs display lines, adding lines, moving through lines, etc
" ------------------------
"
" Display line equivalent of o and O. gO adds an additional line of space
" below because we usually want the stuff below to go away and not bother us
nnoremap go  i<CR><Esc><Up>:s/\s\+$//e<CR><Down>^i
nnoremap gO  i<CR><Esc><Up>A

" Display line equivalent of I and A
nnoremap gA g$a
nnoremap gI g^i

" Make j and k move display lines instead of actual lines, unless you have a
" count. This way:
" - You can move through long lines wrapped into paragraphs more easily by
"   typing j and k instead of gj and gk
" - You can still use line numbers to move a few lines up or down
" Stolen from https://www.hillelwayne.com/post/intermediate-vim/
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Make 0 a 'smart' go to start of line:
" - if we press it once, we go to the
" - first non-blank character, and if we press it twice, we go to the actual
"   start of the line
" From https://www.reddit.com/r/vim/comments/kn0cpp/key_mappings_everyone_uses/
" TODO Make 0 mapping not depend on itself, i.e. make it go to the first
" column by using cursor() https://stackoverflow.com/questions/9953082/how-to-jump-directly-to-a-column-number-in-vim
" instead of 0. That way, we can make 0 an inclusive backward motion with omap
" instead of onoremap
nnoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
vnoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? '0' : '^'

" Map Z0 and Z$ to beginning and end of current paragraph
" Similar to how g0 and g$ go to beginning and end of line (by default Vim
" configuration)
" We use Z instead of z because z is used for surround, so if we used z we
" couldn't ever surround by 0 and $
function! MoveToFirstLineOfParagraph()
    call cursor(line("'{") + (line("'{") == line("0") ? 0 : 1),1)
endfunction
vnoremap <silent> Z0 :<C-U>call MoveToFirstLineOfParagraph()<CR>`<1v``
nnoremap <silent> Z0 :<C-U>call MoveToFirstLineOfParagraph()<CR>
onoremap <silent> Z0 :call MoveToFirstLineOfParagraph()<CR>

function! MoveToLastLineOfParagraph()
" The next line take care of the edge case in which the current paragraph is
" the end of the file, so { doesn't take us to the line after the paragraph,
" but rather to the last line of the paragraph
    call cursor(line("'}") - (line("'}") == line("$") ? 0 : 1),99999999)
endfunction
nnoremap <silent> Z$ :<C-U>call MoveToLastLineOfParagraph()<CR>
vnoremap <silent> Z$ :<C-U>call MoveToLastLineOfParagraph()<CR>`<1v``
onoremap <silent> Z$ :call MoveToLastLineOfParagraph()<CR>


" <S-j> and <S-k> add blank lines below and above respectively
" Note that this stills leaves H, M and L for moving the cursor
" within the window
" The combo exe "norm keys" allows to use especial characters
" See :h :normal and https://stackoverflow.com/questions/4010890/vim-exit-insert-mode-with-normal-command
function! AddBlankLineAbove()
    setlocal formatoptions-=cro
    let l:cursor_pos = getpos('.')
    exe "normal O\<Esc>0D"
    call setpos('.', [l:cursor_pos[0], l:cursor_pos[1]+1, l:cursor_pos[2], l:cursor_pos[3]])
    setlocal formatoptions+=cro
endfunction
function! AddBlankLineBelow()
    setlocal formatoptions-=cro
    let l:cursor_pos = getpos('.')
    exe "normal m`o\<Esc>0D"
    call setpos('.', l:cursor_pos)
    setlocal formatoptions+=cro
endfunction
nnoremap <silent><S-k> :call AddBlankLineAbove()<CR>
nnoremap <silent><S-j> :call AddBlankLineBelow()<CR>



" -------------------------
" SECTION:  Things I'm yet deciding to keep or not
" ------------------------
"
" Define motions g( and g) similar to motion ge
nnoremap g) )geh
nnoremap g( (geh

" Try setting g by default (since it's rare that you need a single
" substitution). If you DO need a single substitution, you can add g t the
" end, and it will toggle off gdefault
set gdefault







" -------------------------
" SECTION:  Keybindings that depend on urxvt and escape sequences
" ------------------------
"
" So that 'set' keybindings time out in 10ms, while the usual keybindings
" still time out at the default 1s
set ttimeout
set ttimeoutlen=10

" <C-Arrows>
" <C-Up> and <C-Down> don't have associated symbol, so we cannot use 'set'
" directly on them, but rather on function keys, and then we map to them
set <C-Left>=Od
set <C-Right>=Oc
set <F32>=Oa
set <F33>=Ob
map <F32> <C-Up>
map <F33> <C-Down>
" Left, right, up and down
cnoremap <M-Left> <Left>
cnoremap <M-Right> <Right>
cnoremap <M-Up> <Up>
cnoremap <M-Down> <Down>

" Move backward and forward by one word with <M-b> and <M-f>
" <M-b> and <M-f> are mapped to <F9> and <F10> by urxvt through escape
" sequences
cnoremap <F9> <S-Left>
cnoremap <F10> <S-Right>

" Move backward and forward by one word with <M-b> and <M-f>
" <M-b> and <M-f> are mapped to <F9> and <F10> by urxvt through escape
" sequences
inoremap <F9> <S-Left>
inoremap <F10> <Esc>ei<Right>
" Left, right, up and down
inoremap <M-Left> <Left>
inoremap <M-Right> <Right>
inoremap <M-Up> <Up>
inoremap <M-Down> <Down>

" Change character under the cursor (s action) with <M-s>
" <M-s> is mapped to <F8> by urxvt through a escape sequence
nnoremap <F8> s
inoremap <F8> s
vnoremap <F8> s

" Disable <Esc> in the command line so that you do not
" lose half-typed commands by mistake
" cnoremap <Esc> <Nop>

" -----------
" | SECTION | Not sorted yet. Things to be sorted
" -----------
"

" Do not set simple tex files to "plaintex" filetype. Set all of them
" to "tex"
let g:tex_flavor='latex'
let g:tex_indent_brace=0


" Delete text in select mode without affecting the registers TODO
" function! DeleteSelectMode()
" endfunction
" snoremap <CR> <Esc>gv"_c
" snoremap a <Esc>gv"_ca



" Define A, gA, I, gI, 0, g0 and $, g$ depending on whether wrap mode is
" activated or not, and also on whether the current line fits in a screen line
" or not. Actually, this is the key! Whether the current line fits in the
" screen line or not. Or maybe not? Mmm...
" - When we have a very long line that wraps around several screen line, then
"   g$ should go to the last character of the current screen line.
" - When we have a paragraph of many short lines, none of which exceeds the screen, then g$
"   should go to the end of the paragraph. This is because going to the last
"   character of the current line can be done with $ always, so g$ should go
"   to the end of the paragraph

" function! MoveToEndOfParagrah()
" " The next line take care of the edge case in which the current paragraph is
" " the end of the file, so { doesn't take us to the line after the paragraph,
" " but rather to the last line of the paragraph
"     call cursor(line("'}") - empty(getline(line("'}"))),0)
"     normal $
" endfunction
" Append at end of paragraph
" nnoremap gA :call MoveToEndOfParagrah()<CR>a
" Go to end of paragraph
" nnoremap g$ :call MoveToEndOfParagrah()<CR>
" onoremap g$ :call MoveToEndOfParagrah()<CR>



vnoremap gq gqgv:s/  / /<CR>


" From http://blog.ezyang.com/2010/03/vim-textwidth/
" Got the color #00005f  from
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim  Write note
" on colors for Vim
" augroup vimrc_autocmds
"   autocmd BufEnter * highlight OverLength ctermbg=17 guibg=#00005f
"   autocmd BufEnter * match OverLength /\%72v/
" augroup END


" Ensure vim-fugitive does vertical splits always
set diffopt+=vertical


" Test persistent undo
" set undofile

function! CleanCompareOutput()
    norm G
    ?STARTING TASK
    Redir .,$g/LINEAR REGRESSION\\|Fingerprints\\|R2 score (test)\\|AP (test)\\|Working with\\|STARTING TASK\\|FINISHED TASK\\|^$/p
endfunction

set iskeyword-=_
let g:CtrlXA_iskeyword = &iskeyword
set iskeyword+=_

" -------------------------
" SECTION:  Linting Python
" ------------------------
"
" This function will be executed for every buffer. If a single buffer is
" modified, a global flag variable will be set to 1
function! IsThisBufferModified()
    if &l:modified
        let g:some_buffer_modified = 1
    endif
endfunction
function! FormatAndLintPython()
    " Check if any buffer is modified
    let g:some_buffer_modified = 0
    bufdo :call IsThisBufferModified()
    if g:some_buffer_modified
        echom 'Unsaved work. Cannot format and lint.'
        sleep 1
        return
    else
        " Format and lint recursively from the repo's root directory
        let old_dir = getcwd()
        let root_dir = fnamemodify(finddir('.git', '.;'), ':h')
        exe 'cd ' . root_dir
        echo 'Formatting with yapf'
        let yapf_return = system('yapf --style=.style.yapf --in-place --recursive .')
        echo yapf_return
        sleep 2
        echo 'Linting with flake8'
        let flake8_return = system('flake8 --config=.flake8 .')
        echo flake8_return
        sleep 2
        exe 'cd ' . old_dir
        " Refresh current file after formatting and linting (only if there is
        " a file loaded)
        if bufname("%") != ''
            e
        endif
    endif
endfunction
nnoremap <leader><F7> :call FormatAndLintPython()<CR>


" flake8 configuration
" let g:flake8_cmd="flake8 --config ~/repos/dockgym/.flake8"
" autocmd FileType python map <buffer> <F3> :call flake8#Flake8()<CR>

" YAPF (Yet Another Python Formatter) configuration
" (requires `pip install yapf`)
" let &formatprg='yapf --style ~/repos/dockgym/.style.yapf'
