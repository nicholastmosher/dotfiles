" Setup Vundle
source $HOME/.vim/.vimrc_vundle

" Load Bundles
source $HOME/.vim/.vimrc_bundles

" Enable mouse
set mouse=a
set ttymouse=xterm2
set foldmethod=syntax
set foldlevelstart=99
set scrolloff=2

" Remap window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Allow saving files as sudo from non-sudo sesson
cmap w!! w !sudo tee > /dev/null %

" Set window splits to the right and bottom
set splitbelow
set splitright

" Relative line numbers
set nu
set rnu

" Whitespace
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set noexpandtab
let g:indentLine_char = '|'
let g:indentLine_color_term = 239

" Tab to navigate buffers
nnoremap <tab> :bn<CR>
nnoremap <S-tab> :bp<CR>

" When pressing return or O from comment line, don't start another comment line.
au FileType * setlocal formatoptions-=cro

" Use space for collapsing blocks
nnoremap <Space> za

" Search settings
set hlsearch
set ignorecase
set smartcase

" No word-wrap, scroll off screen
set nowrap

" Switching buffers does not force save
set hidden

" Hightlight cursor line and 80 rule
set cursorline
set colorcolumn=80

" Eliminate delay in switching modes
set timeoutlen=1000 ttimeoutlen=0

" Fix slowness with ruby (and potentially other things)
" set re=1
set ttyfast
set lazyredraw

" Plugin settings below "

" Setup colorscheme
set t_Co=256
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
colorscheme Tomorrow-Night
syntax on
autocmd VimEnter * ColorHighlight " Hex and other color highlighting

" NERDTree
map <C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Airline
set laststatus=2
let g:airline_powerline_fonts=1

" Set up puppet manifest filetype
au BufRead,BufNewFile *.pp
  \ set filetype=puppet

filetype plugin indent on
