" Make sure to have Vundle installed from GitHub before starting any of the
" configs below.
" https://github.com/VundleVim/Vundle.vim#quick-start
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set nocompatible              " be iMproved, required
" let isVundleInstalled=1
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" look here for more info: http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/
" In vim type :help :Git to see man pages


" ####################
" ##    Plugins     ##
" ####################

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" For doing GitHub things
" In vim type :help :Git to see man pages
Plugin 'tpope/vim-fugitive'
" Git diffs
Plugin 'airblade/vim-gitgutter'
" Move around windows quickly
Plugin 't9md/vim-choosewin'
" Vim status/tabline 
Bundle "vim-airline/vim-airline"
" Show the number of buffers in the command bar 
Plugin 'bling/vim-bufferline'
" Syntax Highlight Themes
Plugin 'dracula/vim'
" Auto completion from buffer cache
Plugin 'Shougo/neocomplete.vim'

" ################################
" #         Syntax stuff         #
" ################################
" Syntax editing and linting
Plugin 'scrooloose/syntastic'
" PEP-8 support
Plugin 'nvie/vim-flake8'
" Python auto complete. Insure latest vim with brew
" install --with-override-system-vi
" --with-lua
" If stuck: vim -u NONE
" Plugin 'Valloric/YouCompleteMe' 

" Highlight class names and methods brightly
Plugin 'WolfgangMehner/bash-support'

" Highlight class names and methods brightly
Plugin 'vim-scripts/TagHighlight'      

" Auto indent python code
Plugin 'vim-scripts/indentpython.vim'   

" MocOS Plist support
Plugin 'darfink/vim-plist'

" Plist formatting
Plugin 'Townk/vim-autoclose'

" TOML
Plugin 'cespare/vim-toml'

"log highlighting
Plugin 'vim-log-highlighting'

" Auto close parens and other things

" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.

Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" #################################################
" All of your Plugins must be added before the following line
call vundle#end()            " required

" ##################################################

" ######################## 
" ##  General Settings  ##
" ########################

" Set indent length for PEP8 indentation
au BufNewFile, BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Flag unwanted white space
au BufRead, BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" UTF-8 support
set encoding=utf-8

" Scroll offset
set so=9999999

" Insert space in normal mode
nnoremap ss i<space><left>

" Show line numbers
set number

" Enable CursorLine
set cursorline
highlight CursorLine ctermbg=Green ctermfg=Red

" Ask about unsaved files upon quit
set confirm

" Show matching pair for [], {}, and ()
set showmatch 

" Spell check
set spell
set spelllang=en

" Enable Syntax highlighting 
syntax on
color dracula
colorscheme dracula
set background=dark

" enable all Python syntax highlighting features
let python_highlight_all = 1

" #######################
" #  Plugin  Settings  ##
" #######################

" Must have plugin manager installed (ie - Vundle) and the dracula/vim package
" installed.
" See Plugin section above

filetype plugin indent on    " required

" Statusline plugin settings 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Formmat plist files in xml format. This is primarily for work with
" preference files on macOS
let g:plist_display_format = 'xml'

" linter plugin config
let g:syntastic_enable_r_lintr_checker = 1
let g:syntastic_r_checkers = ['lintr']

" Syntastic Settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_plist_checkers = ['plutil', 'xmllint']
let g:syntastic_python_checkers = ['pylint'] 
let g:syntastic_enable_signs = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_echo_current_error = 1

" YCM Settings
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g   :YcmCompleter GoToDefinitionElseDeclaration<CR>
