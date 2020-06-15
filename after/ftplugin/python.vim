"Turn on backup option
set backup

"Where to store backups
set backupdir=~/.vim/.backup//

"Make backup before overwriting the current buffer
set writebackup

"Overwrite the original backup file
set backupcopy=yes

" Meaningful backup name, e.g. filename@2015-04-05.14:59
let hour = split(strftime("%F.%H_%M"),':')[0]
au BufWritePre * let &bex = '@' . hour
