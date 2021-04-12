" Do not accidentally write data files ending in .csv or .tsv
" (.csv and .tsv have been set set to filetype datatable)
" NOTE We cannot :set nomodifiable because then we could call the
" ViewTable() command from the rainbow_csv plugin
setlocal readonly
