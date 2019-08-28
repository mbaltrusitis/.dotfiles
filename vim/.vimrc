" pathogen settings
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" base16-bash/vim settings
if filereadable(expand("~/.vimrc_background"))  " requires base16-bash to be installed
	let base16colorspace=256  " Access colors present in 256 colorspace
	source ~/.vimrc_background
endif

" general settings
syntax on
filetype plugin indent on
" line numbers
set number
" Highlight columns 80 and 120
let &colorcolumn='80,100,120,140'
" highlight active column
set cursorcolumn
" allow backspace everywhere
set backspace=indent,eol,start

"function key assignments
map <F2> :echo 'Current time is ' . strftime('%c')<CR>
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

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion = 1

" Highlight whitespace problems.
" flags is '' to clear highlighting, or is a string to
" specify what to highlight (one or more characters):
"   e  whitespace at end of line
"   i  spaces used for indenting
"   s  spaces before a tab
"   t  tabs not at start of line
function! ShowWhitespace(flags)
	let bad = ''
	let pat = []
	for c in split(a:flags, '\zs')
		if c == 'e'
			call add(pat, '\s\+$')
		elseif c == 'i'
			call add(pat, '^\t*\zs \+')
		elseif c == 's'
			call add(pat, ' \+\ze\t')
		elseif c == 't'
			call add(pat, '[^\t]\zs\t\+')
		else
			let bad .= c
		endif
	endfor
	if len(pat) > 0
		let s = join(pat, '\|')
		exec 'syntax match ExtraWhitespace "'.s.'" containedin=ALL'
	else
		syntax clear ExtraWhitespace
	endif
	if len(bad) > 0
		echo 'ShowWhitespace ignored: '.bad
	endif
endfunction

function! ToggleShowWhitespace()
	if !exists('b:ws_show')
		let b:ws_show = 0
	endif
	if !exists('b:ws_flags')
		let b:ws_flags = 'es'  " which whitespace to show
	endif
	let b:ws_show = !b:ws_show
	if b:ws_show
		call ShowWhitespace(b:ws_flags)
	else
		call ShowWhitespace('')
	endif
endfunction

nnoremap <Leader>ws :call ToggleShowWhitespace()<CR>
highlight ExtraWhitespace ctermbg=9

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
