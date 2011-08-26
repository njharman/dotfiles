" vim > vi
set nocompatible

let xterm16_brightness = 'high'
let xterm16_colormap = 'softlight'
let xterm16_white = '#ffffff'
colo xterm16
set background=light

filetype on
filetype plugin indent on
syntax enable

set title               " Change terminal's title
set showcmd             " Show command as you type it
set showmode            " Show current mode
set nohlsearch          " Don't uglify just cause I searched
set noshowmatch         " Don't show matching brackets
set matchtime=0         " Blink matching chars for 0 seconds
set history=1000
set undolevels=1000
set novisualbell
set noerrorbells
set ttyfast             " 1980 is long past
set lazyredraw          " Don't redraw in macros
set autoread            " Watch for file changes
set shell=bash
"set ffs=unix,dos,mac    " Support these files
"set isk+=_,$,@,%,#,-    " None word dividers
set termencoding=utf-8
set encoding=utf-8

set autoindent
set copyindent          " Copy the previous indentation on autoindenting
set nosmartindent
set nocindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround          " Use multiple of shiftwidth when indenting with '<' and '>'
set nostartofline       " Leave my cursor position alone!
set backspace=2         " Equiv to :set backspace=indent,eol,start
set nowrap              " Don't wrap lines
set linebreak           " Wrap lines at convenient points
set formatoptions+=1    " When wrapping paragraphs, don't end lines 1 letter words
set ruler
set more                " Use more prompt
set nobackup            " Live dangerously
set hidden              " Hide buffers instead of closing them
set shortmess=atI       " Shorten messages and no splash screen
set list                " Show invisible characters
set listchars=tab:>·,trail:·    " But only show tabs and trailing whitespace
let g:clipbrdDefaultReg = '+'
runtime plugin/matchit.vim " More better % matching

set mousehide           " Hide the mouse pointer while typing
set guioptions=a        " get rid of stupid scrollbar/menu/tabs/etc
" Who needs .gvimrc?
if has('gui_running')
  set encoding=utf-8
  "set guifont=Monospace\ Bold\ 9
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
  " Turn off toolbar and menu
  set guioptions-=T
  set guioptions-=m
end

" Gnarly status line is gnarly
set statusline=%F%m%r%h%w\ \ %{&ff}%y%=0x\%02.2B\ /\ \%03.3b\ \ %04l/%02v\ \ [%p%%]
set laststatus=2

" Searches are case sensitive if/only if they contain capital
"set ignorecase
"set smartcase

" Freakin awesome, start scrolling 5 lines from top/bottom/left/right
set scrolloff=5
set sidescrolloff=5
" Freakin awesome file completion
set wildmenu
set wildmode=list:longest,full
set wildignore=*.pyc,*.pyo

" When editing a file, always jump to the last known cursor position.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Remember stuff after quiting: marks, registers, searches, buffer list
set viminfo='20,<50,s10,h,%

" Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste
func! Paste_on_off()
   if g:paste_mode == 0
      set paste
      let g:paste_mode = 1
   else
      set nopaste
      let g:paste_mode = 0
   endif
   return
endfunc
map <silent> <F12> :call Paste_on_off()<CR>
set pastetoggle=<F12>    " When in insert mode, press <F2> to go to paste mode

"f1 not help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
"f5 not compile
autocmd filetype python map <buffer> <F5> :w<CR>:!pyflakes %<CR>
autocmd filetype python imap <buffer> <F5> <Esc>:w<CR>:!pyflakes %<CR>
autocmd filetype python map <buffer> <S-F5> :w<CR>:!pylint %<CR>
autocmd filetype python imap <buffer> <S-F5> <Esc>:w<CR>:!pylint %<CR>

";=: jj=ESC
nnoremap ; :
inoremap jj <ESC>

" emacs movement keybindings in insert mode
map <C-a> ^
map <C-e> $

" Swap these keps cause ` is cooler but ' is easier to type
nnoremap ' `
nnoremap ` '

" Make Y consistent with C and D
nnoremap Y y$

" Sloppy fingers
:command WQ wq
:command Wq wq
:command W w
:command Q q

" Complete whole filenames/lines with a quicker shortcut key in insert mode
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>
" :o <file> open file if in path
cab o find
" sudo write!
cmap w!! w !sudo tee % >/dev/null

" Keep search matches in the middle of the window.
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv
" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

"nnoremap / /\v
"vnoremap / /\v      "change regex handling

" Indent with spacebar
nnoremap <space> >>
" Allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

let mapleader = ","

" comments
map <leader>3 :s/^/#/<cr>
map <leader>u :s/#//<cr>

" Pull word under cursor into LHS of a substitute
nmap <leader>s :%s/<C-r>=expand("<cword>")<CR>/

" ReST titles
nmap <leader>- yyp:s/./-/g<cr>
nmap <leader>= yyp:s/./=/g<cr>
nmap <leader>~ yyp:s/./\~/g<cr>
nmap <leader>^ yyp:s/./^/g<cr>
nmap <leader>* yyp:s/./*/g<cr>
nmap <leader># yyp:s/./#/g<cr>

" Quick alignment of text
nmap <leader>al :left<CR>
nmap <leader>ar :right<CR>
nmap <leader>ac :center<CR>

" Highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Shortcut to jump to next conflict marker
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

iab teh the
iab adn and
iab Todo TODO:
iab todo TODO:
iab MoN January February March April May June July August September October November December
iab NuM 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
iab njh Norman J. Harman Jr.

nnoremap _dt :set ft=htmldjango<CR>
nnoremap _pd :set ft=python.django<CR>
au BufNewFile,BufRead urls.py      setlocal filetype=python.django
au BufNewFile,BufRead admin.py     setlocal filetype=python.django
au BufNewFile,BufRead models.py    setlocal filetype=python.django
au BufNewFile,BufRead forms.py     setlocal filetype=python.django
au BufNewFile,BufRead views.py     setlocal filetype=python.django
au BufNewFile,BufRead handlers.py  setlocal filetype=python.django
au BufNewFile,BufRead settings.py  setlocal filetype=python.django
au BufNewFile,BufRead local_settings.py  setlocal filetype=python.django
au BufNewFile,BufRead *.html       setlocal filetype=htmldjango
au BufEnter *.js        set softtabstop=2|set shiftwidth=2
au BufEnter *.html      set softtabstop=2|set shiftwidth=2
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS
au BufNewFile,BufRead *.scss             set ft=scss.css
au BufNewFile,BufRead *.sass             set ft=sass.css

" t - autowrap to textwidth
" q - allow formatting of comments with :gq
" c - autowrap comments to textwidth
" r - autoinsert comment leader with <Enter>
" l - don't format already long lines
au FileType * set formatoptions=qcon1w
au FileType text setlocal formatoptions=tqcan12w nocindent textwidth=78

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" This function determines, wether we are on the start of the line text (then tab indents)
" or if we want to try autocompletion
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
