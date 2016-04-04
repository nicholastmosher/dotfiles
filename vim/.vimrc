" Fix shell
set shell=/bin/bash

" Not compatible with Vi
set nocompatible

" Vundle
source ~/.vimrc_vundle

" Bundles
source ~/.vimrc_bundles

" User files (optional)
silent! source ~/.vimrc_user

" Enable mouse
set mouse=a
set ttymouse=xterm2
set foldmethod=syntax
set foldlevelstart=99
set scrolloff=2
nnoremap  <tab> :bn<CR>
nnoremap  <S-tab> :bp<CR>
nnoremap  <Space>  za

" Remap window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Set window splits to the right and bottom
set splitbelow
set splitright

" Relative line numbers
set nu
set rnu

" Fix backspace
set backspace=indent,eol,start

" Colors
set t_Co=256
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
colorscheme Tomorrow-Night
syntax on

" Ruler
set colorcolumn=80

" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set noexpandtab
let g:indentLine_char = '|'
let g:indentLine_color_term = 239

" Whitespace
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

" Powerline
set laststatus=2
let g:airline_powerline_fonts = 1

" Wrapping, side-scrolling
set nowrap

" Highlight search things
set hlsearch

" When pressing return after typing a comment, don't automatically start a new
" comment
au FileType * setlocal formatoptions-=r

" When a macro is created on q, let space replay that macro
" noremap <Space> @q

" Eliminate delay in switching modes
set timeoutlen=1000 ttimeoutlen=0

" Highlight cursor line
set cursorline

" Disable spellchecking
set nospell

" Display
set encoding=utf-8
set t_Co=256

set hidden

" File type aliases
au BufNewFile,BufRead *.ejs set filetype=jst
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.swift set filetype=swift
au BufNewFile,BufRead *.imp,*.ic set filetype=scheme
au BufNewFile,BufRead *.hasm set filetype=asm

" Searching
set hlsearch
set ignorecase
set smartcase

" NERDTree
map <C-e> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
