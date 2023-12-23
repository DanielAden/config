syntax on
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
set showmatch

filetype indent on

set nu
set relativenumber

set textwidth=120
set laststatus=2

" set list
set listchars=nbsp:+,tab:>-,trail:·

set autoread

set hls

set clipboard+=unnamedplus

set cursorline

set scrolloff=8
set sidescrolloff=8

set noswapfile

set splitbelow
set splitright

set nowrap

set whichwrap=<,>,[,],h,l

nnoremap <SPACE> <Nop>
let mapleader=" "
map <leader>q :confirm q<CR>
map <leader>w :w<CR>


" KEYMAPS -----------------------------------
" Windows
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Better indenting
vnoremap < <gv
vnoremap > >gv

" Move one or more lines up/down with indentation in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Half page navigation automatically centers to middle of the page
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" paste over selected text while preserving yanked text
xnoremap <leader>p "_dP

" remove search highlighting
nnoremap <leader>h :nohlsearch<CR>
