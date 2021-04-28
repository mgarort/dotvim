" Launch Vim as a scrachpad with "vim -c 'call LaunchScratchpad()'"

function! LaunchScratchpad()
    let tmpfile = system('mktemp')
    exe 'edit ' . tmpfile
    colorscheme blackwhite
    startinsert
endfunction
