function! CopyCellToIPython()
    " Copy cell (delimited by ##{ and ##}) to register t
    exe '?##{?+1;/##}/-1y t'
    " Move to bottom window (where the terminal is)
    call feedkeys("\<C-w>j")
    " Paste register t to IPython command line and move back
    " to previous window
    " 1. Prepare iPython to receive several lines of code, rather than
    " executing after the first line
    call feedkeys("%cpaste\<CR>")
    " For some reason, after %cpaste it is not possible to copy directly.
    " So we first change windows and then copy
    call feedkeys("\<C-w>k")
    call feedkeys("\<C-w>j")
    " 2. Paste register t
    call feedkeys("\<C-w>\"t")
    " 3. Indicate to iPython that this is the last line of code
    call feedkeys("--\<CR>")
    " Return to previous window and move to end of copied cell
    " ( '] indicates the end of the yanked text)
    call feedkeys("\<C-w>k")
    execute "normal! ']"
    " Move three line down
    execute "normal! 3j"
endfunction
nnoremap <C-b> :call CopyCellToIPython()<CR>

set nowrap


" Define keybindings for tab functionality
nnoremap <C-Up>    mt:tabnew %<CR>`t
nnoremap <C-Down>  mt:tabc<CR>`t
nnoremap <C-Left>  mt:tabp<CR>`t
nnoremap <C-Right> mt:tabn<CR>`t


" t for regenerating ctags
" Function to regenerate ctags (with inspiration from
" https://stackoverflow.com/questions/27978307/how-to-run-vim-commands-scripts-from-project-root )
" The 'exclude' argument is used in case we are in a repository with guatask
" tasks and the OUTPUT directories have many files
function! GenerateCtags()
    let root_dir = fnamemodify(finddir('.git', '.;'), ':h')
    exe '!ctags -Rf ' . root_dir . '/.tags --python-kinds=-i --exclude=' . root_dir . '/tasks/*/OUTPUT ' . root_dir
endfunction
nnoremap <leader>t :call GenerateCtags()<CR>


" gp and gP for pdb
function! AddPdbAbove()
    setlocal formatoptions-=cro
    exe "normal m`O__import__('pdb').set_trace()\<Esc>``"
    setlocal formatoptions+=cro
endfunction
nnoremap gP :call AddPdbAbove()<CR>
function! AddPdbBelow()
    setlocal formatoptions-=cro
    exe "normal m`o__import__('pdb').set_trace()\<Esc>``"
    setlocal formatoptions+=cro
endfunction
nnoremap gp :call AddPdbBelow()<CR>
