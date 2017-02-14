" Personal Infomation [CVIM]
let g:C_AuthorName='Kevin Liu'
let g:C_Email='dengzhiliu@gmail.com'
let g:C_MapLeader="`"

" Basic Settings for display
syntax on
set nocp
set ru
set foldmethod=syntax
set foldlevel=88
set laststatus=2
set sm
set ai
set sw=4
set ts=4
set noet
set lbr
set backspace=indent,eol,start
set whichwrap=b,s,<,>,[,]
set nowrap
set fo+=mB
set selectmode=
set mousemodel=popup
set mouse=a
set keymodel=startsel,stopsel
set selection=inclusive
set matchpairs+=<:>
set number
set ignorecase
set hlsearch
set incsearch
set expandtab
set tabstop=4
set nobackup
set makeprg=make
set cursorline

function! s:CheckColorSchemeExist(name)
    let pat = 'colors/'.a:name.'.vim'
    return !empty(globpath(&rtp, pat))
endfunction
if s:CheckColorSchemeExist('zenburn')
    let g:zenburn_high_Contrast=0
    colorscheme zenburn
endif

if has("gui_running")
	set lines=20
	set columns=90
	set guioptions-=m
    set guioptions-=T
"    :hi CursorLine term=NONE guibg=DarkGray guifg=White
    if has("gui_win32")
        set guifont=Dejavu_Sans_Mono:h8
        set dir=.
    else
        set guifont=Dejavu\ Sans\ Mono\ 8
        set dir=/tmp
    endif
else
"    :hi CursorLine cterm=NONE ctermbg=darkred ctermfg=gray
endif

filetype indent on
filetype plugin on

set encoding=utf8
set fileencodings=ucs-bom,utf8,gb18030

" C/C++ 
set cin
set cino=:0g0t0(sus
let g:clang_snippets=1
let g:clang_conceal_snippets=1
"set concealcursor=inv
"set conceallevel=2
let g:clang_snippets_engine='clang_complete'
let g:clang_use_library=1
let g:clang_complete_macros=1
let g:clang_complete_patterns=1
set completeopt=menu,longest
" set tags=./tags

" for mouse under urxvt/xterm2
set ttymouse=xterm2

" for colortheme(zenburn) under tmux
set t_ut=

" Key-map's
nmap <C-F12> :!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+ianS --extra=+q .
nmap <C-Esc> <C-W>]
nmap <C-S-Esc> :quit<CR>

nmap <C-F2> :NERDTreeToggle<CR>
nmap <C-F3> :TlistToggle<CR>
nmap <C-F5> :copen<CR>

" filetypes
autocmd BufRead,BufNewFile *.md set filetype=markdown
