set nocompatible              " be iMproved
filetype off                  " required

" Use UTF-8 without BOM
set encoding=utf-8 nobomb
set t_Co=256
set term=xterm-256color
set termencoding=utf-8

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
" Change mapleader
let mapleader=","

" Respect modeline in files
set modeline
set modelines=4
" Enable line numbers
set number
" Highlight current line
set cursorline
" Smart tabs
set noet sts=0 sw=4 ts=4
set cindent
set cinoptions=(0,u0,U0
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling five lines before the horizontal window border
set scrolloff=5

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Load plugins, install with :PluginInstall
Plugin 'gmarik/Vundle.vim'

" Interface plugins
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'

" Editing plugins
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'

" Language extensions
Plugin 'plasticboy/vim-markdown'
Plugin 'derekwyatt/vim-scala'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" Enable the solarized theme
syntax enable
set background=dark
colorscheme solarized

" Configure Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#mixed_indent_algo = 2

" Configure NerdTree
autocmd StdinReadPre * let s:std_in=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowHidden=1

" Add additional comment styles
autocmd FileType cmake set commentstring=#\ %s
