" vim > vi
set nocompatible
" Do lang specific stuffs
filetype plugin indent on
syntax enable

let xterm16_brightness = 'high'
let xterm16_colormap = 'softlight'
let xterm16_white = '#ffffff'
colo xterm16
set background=light

set encoding=utf-8
set termencoding=utf-8
set modelines=0
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
set shell=/bin/bash

set autoindent
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
set ruler
set more                " Use more prompt
set nobackup            " Live dangerously
set hidden              " Hide buffers instead of closing them
set shortmess=atI       " Shorten messages and no splash screen
set list                " Show invisible characters
set listchars=tab:>·    " But only show tabs
let g:clipbrdDefaultReg = '+'
runtime plugin/matchit.vim      " More better % matching
set mousehide           " Hide the mouse pointer while typing
set guioptions=a        " get rid of stupid scrollbar/menu/tabs/etc
if has('gui_running')
  set encoding=utf-8
  "set guifont=Monospace\ Bold\ 9
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
  " Turn off toolbar and menu
  set guioptions-=T
  set guioptions-=m
end

" Status line is gnarly
set statusline=%F%m%r%h%w\ \ %{&ff}%y%=0x\%02.2B\ /\ \%03.3b\ \ %04l/%02v\ \ [%p%%]
set laststatus=2

" Freakin awesome, start scrolling 5 lines from top/bottom/left/right
set scrolloff=5
set sidescrolloff=5
" Freakin awesome file completion
set wildmenu
set wildmode=list:longest,full
set wildignore=*.pyc,*.pyo,*.o,*.obj,*.swp,*.DS_Store?
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images

" When editing a file, always jump to the last known cursor position.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Remember some stuff after quiting: marks, registers, searches, buffer list
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
map <silent> <F11> :call Paste_on_off()<CR>
set pastetoggle=<F11> " When in insert mode, press <F11> to go to paste mode

"f1 not help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
"f5 not compile
autocmd filetype python map <buffer> <F5> :w<CR>:!pyflakes %<CR>
autocmd filetype python imap <buffer> <F5> <Esc>:w<CR>:!pyflakes %<CR>
autocmd filetype python map <buffer> <S-F5> :w<CR>:!pylint %<CR>
autocmd filetype python imap <buffer> <S-F5> <Esc>:w<CR>:!pylint %<CR>
" Extra functionality for some existing commands:
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"

" Emacs movement keybindings in insert mode
map <C-a> ^
map <C-e> $

" Reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

";=: jj=ESC
nnoremap ; :
inoremap jj <ESC>

" Swap these keps cause ` is cooler but ' is easier to type
nnoremap ' `
nnoremap ` '

" Make Y consistent with C and D
nnoremap Y y$

" Complete whole filenames/lines with a quicker shortcut key in insert mode
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Indent with spacebar
nnoremap <space> >>
vnoremap <space> >>

let mapleader = ","

map <leader># :s/^/#/<cr>
map <leader>3 :s/^/#/<cr>
map <leader>u :s/#//<cr>
map <leader>w <C-W><C-W>

" Pull word under cursor into LHS of a substitute
nmap <leader>s :%s/<C-r>=expand("<cword>")<CR>/

" ReST titles
nmap <leader>- yyp:s/./-/g<cr>
nmap <leader>= yyp:s/./=/g<cr>
nmap <leader>~ yyp:s/./\~/g<cr>
nmap <leader>^ yyp:s/./^/g<cr>
nmap <leader>* yyp:s/./*/g<cr>
nmap <leader># yyp:s/./#/g<cr>

" allow multiple indentation/deindentation in visual mode
"vnoremap < <gv
"vnoremap > >gv

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" :o <file> open file if in path
cab o find

" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" shortcut to jump to next conflict marker
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>


" sloppy fingers
:command WQ wq
:command Wq wq
:command W w
:command Q q

iab teh the
iab adn and
iab Todo TODO:
iab todo TODO:
iab _mon January February March April May June July August September October November December
iab _num 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
iab _njhjr Norman J. Harman Jr.
iab _t  <C-R>=strftime("%H:%M:%S")<CR>
iab _d  <C-R>=strftime("%a, %d %b %Y")<CR>
iab _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>


nnoremap _dt :set ft=htmldjango<CR>
nnoremap _pd :set ft=python.django<CR>
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS
au BufNewFile,BufRead urls.py      setlocal filetype=python.django
au BufNewFile,BufRead admin.py     setlocal filetype=python.django
au BufNewFile,BufRead models.py    setlocal filetype=python.django
au BufNewFile,BufRead forms.py     setlocal filetype=python.django
au BufNewFile,BufRead views.py     setlocal filetype=python.django
au BufNewFile,BufRead handlers.py  setlocal filetype=python.django
au BufNewFile,BufRead settings.py  setlocal filetype=python.django
au BufNewFile,BufRead local_settings.py  setlocal filetype=python.django
au BufNewFile,BufRead *.html       setlocal filetype=htmldjango
au BufEnter *.js        setlocal softtabstop=2|setlocal shiftwidth=2
au BufEnter *.html      setlocal softtabstop=2|setlocal shiftwidth=2
au BufNewFile,BufRead *.scss       setlocal ft=scss.css
au BufNewFile,BufRead *.sass       setlocal ft=sass.css

" t - autowrap to textwidth
" q - allow formatting of comments with :gq
" c - autowrap comments to textwidth
" r - autoinsert comment leader with <Enter>
" l - don't format already long lines
" 1 - When wrapping paragraphs, don't end lines 1 letter words
au FileType * set formatoptions=qcon1w
au FileType text setlocal formatoptions=tqcan12w nocindent textwidth=78


" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" For SICP
"https://github.com/jpalardy/vim-slime/blob/master/plugin/slime.vim
" start screen (in other terminal) screen -S sicp rlwrap scheme -large
function Send_to_Screen(text)
  if !exists("b:slime")
    call Screen_Vars()
  end
  let escaped_text = substitute(shellescape(a:text), "\\\\\n", "\n", "g")
  call system("screen -S " . b:slime["sessionname"] . " -X stuff " . escaped_text)
endfunction
function Screen_Vars()
  if !exists("b:slime")
    let b:slime = {"sessionname": ""}
  end
  let b:slime["sessionname"] = input("session name: ", b:slime["sessionname"], "custom,Screen_Session_Names")
endfunction
vmap <C-c><C-c> "ry:call Send_to_Screen(@r)<CR>
nmap <C-c><C-c> vip<C-c><C-c>
nmap <C-c><C-a> :call Send_to_Screen("(restart 1)\n")<CR>
"nmap  :call Send_to_Screen(" ")<CR>
nmap <F10> :0,$y r<CR>:call Send_to_Screen(@r)<CR>

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
