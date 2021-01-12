This repository has all my Vim configuration.

To fully configure Vim in a new computer, do:

1. `cd ~/repos`
2. `git clone git@github.com:mgarort/dotvim.git`
3. `ln -s ~/repos/dotvim ~/.vim`
4. `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
5. Open Vim, and do `:PluginInstall`
6. Install YouCompleteMe server. Follow the official installation instructions for Ubuntu (https://github.com/ycm-core/YouCompleteMe#linux-64-bit)
7. TODO Set up soft links to the directory where plugin modifications are tracked (outside `.vim/bundle`).
