" Function for submitting Guatask tasks to the cluster slurm queue, creating a
" submission file with the name slurm_TASKNAME.{wilkes2,peta-skylake4}
" a:0 is for the partition, and a:1 is for the time (integer, in hours)
" TODO Make it operate on visual selections too:
" - If currently a visual selection, iterate over the lines to submit all
"   tasks on those lines  https://vi.stackexchange.com/questions/16610/operate-on-a-visual-selection-by-looping-through-the-lines
" - If not currently a visual selection, operate on current line only
function! SbatchGuataskTask(partition,hours)
    " Get name of Guatask task under the cursor
    let task_name = getline('.')
    let task_name = split(task_name, 'class ')
    let task_name = task_name[0]
    let task_name = split(task_name, '(')
    let task_name = task_name[0]
    echo task_name
    echo "\n"
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
    echo batch_output
    let cd_command = 'cd -'
    exe cd_command
endfunction
com -nargs=* Guabatch call SbatchGuataskTask(<f-args>)
" Keybindings for guatask tasks:
" - g for guatask
" - starting with , because they affect the current buffer only (as opposed to
"   vim-fugitive Git wrapper, which is activated with <leader>g because it
"   affects the entire repository)
" - ending with a different letter based on the action:
"   - b for Guabatch
"   - l for Gualog (to open the log file)
nnoremap ,gb :Guabatch<space>
