" pathogen settings
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" general settings
syntax on
filetype plugin indent on
map <F2> :echo 'Current time is ' . strftime('%c')<CR>
" line numbers
set number
" allow backspace everywhere
set backspace=indent,eol,start

" base16-bash/vim settings
if filereadable(expand("~/.vimrc_background"))  " requires base16-bash to be installed
	let base16colorspace=256  " Access colors present in 256 colorspace
	source ~/.vimrc_background
endif

"function key assignments
map <F3> :noh<CR>
map <F4> :set paste! nopaste?<CR>
map <F5> :setlocal spell spelllang=en_us<CR>

" more modern search behavior
set ignorecase
set smartcase
set incsearch
" highlight all search patterns matches
set hlsearch

" NERDTree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$', '\.sw?']

" vim-airline
let g:airline_powerline_fonts = 1
set laststatus=2  " puts airline in the right spot when used with NERDTree
