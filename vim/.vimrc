"" needed vor vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'itchyny/lightline.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

colorscheme default
set nohlsearch       ""don't highlight searches
set background=dark  ""make text look prettier
set ignorecase       ""when searching, ignore case
set smartcase        ""(w/ignore) if using uppercase it will search correctly
set incsearch        ""search as you type, not wait until done
set paste            ""don't auto-indent
set laststatus=2     ""the statusbar at the bottom
set tabstop=4        ""default is 8
set wildmenu         ""tab completes for searching

"" This was too much, took too long under p4
""set path+=**         ""let vim search in to subfolders

let g:netrw_banner=0     ""disable the netrw banner
let g:netrw_liststyle=3  ""tree view

nmap \l :setlocal number!<CR>    ""line numbers
nmap \o :set paste!<CR>          ""toggles on auto=indent
nmap \cc :set cursorcolumn       ""visually show the column
