" Basic Settings
set nocompatible
set number
set relativenumber
set ruler
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent
set wrap
set linebreak
set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
set history=1000
set wildmenu
set wildmode=longest:full,full
set mouse=a
set clipboard=unnamed
set backspace=indent,eol,start

" Color scheme
syntax enable
set background=dark

" Key mappings
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" File type specific settings
filetype plugin indent on
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType typescript setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2

" Backup settings
set nobackup
set nowritebackup
set noswapfile