" Function for getting task name if the cursor is on the first line of the
" class
function! GetTaskName()
    let task_name = getline('.')
    let task_name = split(task_name, 'class ')
    let task_name = task_name[0]
    let task_name = split(task_name, '(')
    let task_name = task_name[0]
    return task_name
endfunction
" Function for submitting Guatask tasks to the cluster slurm queue, creating a
" submission file with the name slurm_TASKNAME.{wilkes2,peta-skylake4}
" a:0 is for the partition, and a:1 is for the time (integer, in hours)
" TODO Make SbatchGuataskTask and OpenGuataskLogFile work in the current
" class, even if the cursor is anywhere in the class and not necessarily on
" the class declaration. Copy how OpenGuataskLogFile gets the directory name
function! SbatchGuataskTask(partition,hours)
    " Get name of Guatask task under the cursor
    let task_name = GetTaskName()
    " Create submission file
    if a:partition == 'pascal'
        let template_file_extension = '.wilkes2'
    elseif a:partition == 'skylake'
        let template_file_extension = '.peta4-skylake'
    else
        echo 'The first argument should indicate the partition. Valid partition names are "pascal" or "skylake".'
        return
    endif
    let root_dir = fnamemodify(finddir('.git', '.;'), ':h')
    let origin = root_dir . '/submissions/' . 'slurm_TEMPLATE'     . template_file_extension
    let target = root_dir . '/submissions/' . 'slurm_' . task_name . template_file_extension
    let copy_command = 'cp ' . origin . ' ' . target
    let copy_output = system(copy_command)
    echo copy_output
    " Put the task name and the hours information into the submission file
    let sed_taskname_command = 'sed -i "s/TASK_NAME/' . task_name . '/" ' . target
    let sed_taskname_output = system(sed_taskname_command)
    echo sed_taskname_output
    let sed_hours_command = 'sed -i "s/HOURS/' . a:hours . '/" ' . target
    let sed_hours_output = system(sed_hours_command)
    echo sed_hours_output
    " Batch submission file.
    " (Change directory to ensure that the slurm-XXXXX.out file and the
    "  machine.file.XXXXX files are saved in the submissions directory
    "  rather than in the tasks directory, creating clutter)
    let cd_command = 'cd ' . root_dir . '/submissions/'
    exe cd_command
    let batch_command = 'sbatch ' . target
    let batch_output =  system(batch_command)
    echom task_name . ': ' . batch_output
    let cd_command = 'cd -'
    exe cd_command
endfunction
com -nargs=* Guabatch call SbatchGuataskTask(<f-args>)

function! OpenGuataskLogFile() abort
    " Get directory name (cursor anywhere in the class, thanks to u/monkoose and u/abraxasnister)
    let dir_line_regex = '^\s*directory\s*='
    let class_regex = '^\s*class\s\+\S\+('
    let dir_name_regex = "['\"]\\zs.*\\ze['\"]"
    let first_line = search(class_regex, 'Wncb')
    let indent_level = match(getline(first_line), 'class') + 1
    let last_line = search('\%' .. indent_level .. 'c\S\|\%$', 'Wn') - 1
    let dir_name = matchstr(matchstr(getline(first_line, last_line), dir_line_regex), dir_name_regex)
    " Get task name (cursor in the class declaration)
    let task_name = GetTaskName()
    " Get full path to LOG file
    let root_dir = fnamemodify(finddir('.git', '.;'), ':h')
    let log_path = root_dir . '/tasks/' . dir_name . '/LOG/' . task_name . '.log'
    " Open only if file exists
    if filereadable(log_path)
        exe 'e ' . log_path
    else
        echo 'Log file doesn' . "'t exist."
    endif
endfunction
com Gualog call OpenGuataskLogFile()

function! OpenGuataskOutputFile()
    " Get task name
    let task_name = GetTaskName()
    " Get full path to output file
    let root_dir = fnamemodify(finddir('.git', '.;'), ':h')
    let out_path = root_dir . '/submissions/' . task_name . '.out'
    " Open only if file exists
    if filereadable(out_path)
        exe 'e ' . out_path
    else
        echo 'Output file doesn' . "'t exist."
    endif
endfunction
com Guaout call OpenGuataskOutputFile()

" Keybindings for guatask tasks:
" - g for guatask
" - starting with , because they affect the current buffer only (as opposed to
"   vim-fugitive Git wrapper, which is activated with <leader>g because it
"   affects the entire repository)
" - ending with a different letter based on the action:
"   - b for Guabatch
"   - l for Gualog (to open the log file)
"   - o for Guaout (to open the outpue file in the submissions directory)
nnoremap ,gb :Guabatch<space>
nnoremap ,gl :Gualog<CR>
nnoremap ,go :Guaout<CR>

" Command line abbreviations for the partitions 'pascal' and 'skylake'
function! GuataskCp()
	let cmdline = getcmdline()
	if cmdline =~ "Guabatch " && getcmdpos() == 10
		return "pascal "
	else
		return "p"
	endif
endfunction
cnoremap <expr> p GuataskCp()

function! GuataskCs()
	let cmdline = getcmdline()
	if cmdline =~ "Guabatch " && getcmdpos() == 10
		return "skylake "
	else
		return "s"
	endif
endfunction
cnoremap <expr> s GuataskCs()
