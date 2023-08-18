  1 " Make sure to have Vundle installed from GitHub before starting any of the                                                                                                                                                                                                                                           
  2 " configs below.
  3 " https://github.com/VundleVim/Vundle.vim#quick-start
  4 " git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  5 
  6 set nocompatible              " be iMproved, required
  7 " let isVundleInstalled=1
  8 filetype off                  " required
  9 
 10 " set the runtime path to include Vundle and initialize
 11 set rtp+=~/.vim/bundle/Vundle.vim
 12 call vundle#begin()
 13 " alternatively, pass a path where Vundle should install plugins
 14 "call vundle#begin('~/some/path/here')
 15 
 16 " let Vundle manage Vundle, required
 17 " look here for more info: http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/
 18 " In vim type :help :Git to see man pages
 19 
 20 
 21 " ####################
 22 " ##    Plugins     ##
 23 " ####################
 24 
 25 " set the runtime path to include Vundle and initialize
 26 set rtp+=~/.vim/bundle/Vundle.vim
 27 call vundle#begin()
 28 " alternatively, pass a path where Vundle should install plugins
 29 "call vundle#begin('~/some/path/here')
 30 
 31 " let Vundle manage Vundle, required
 32 Plugin 'VundleVim/Vundle.vim'
 33 
 34 " The following are examples of different formats supported.
 35 " Keep Plugin commands between vundle#begin/end.
 36 
 37 " For doing GitHub things
 38 " In vim type :help :Git to see man pages
 39 Plugin 'tpope/vim-fugitive'
 40 " Git diffs
 41 Plugin 'airblade/vim-gitgutter'
 42 " Move around windows quickly
 43 Plugin 't9md/vim-choosewin'
 44 " Vim status/tabline 
 45 Bundle "vim-airline/vim-airline"
 46 " Show the number of buffers in the command bar 
 47 Plugin 'bling/vim-bufferline'
 48 " Syntax Highlight Themes
 49 Plugin 'dracula/vim'
 50 " Auto completion from buffer cache
 51 Plugin 'Shougo/neocomplete.vim'
 52 
 53 " ################################
 54 " #         Syntax stuff         #
 55 " ################################
 56 " Syntax editing and linting
 57 Plugin 'scrooloose/syntastic'
 58 " PEP-8 support
 59 Plugin 'nvie/vim-flake8'
 60 " Python auto complete. Insure latest vim with brew
 61 " install --with-override-system-vi
 NORMAL  SPELL [EN]   1:.vimrc                                                                                                                                                                                                                                          vim  utf-8[unix]  0% ㏑:1/196☰℅:1  ☲ [44]trailing 
".vimrc" 196L, 5234B
