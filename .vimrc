" :highlight Group ctermbg=white ctermfg=black term=bold
" :match Group /pattern/
" :match None
" :2match
" :3match
" :match ErrorMsg /\%>73v.\+/ # \%> match col, 'v' virtual columns only
" :setlocal spell spelllang=en_us " ]s [s zg=addword
" searches # * g# g* g, gd
" <leader>pw python docs

set nocompatible                " vim > vi
filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

syntax on
filetype on
filetype plugin indent on

let xterm16_brightness = 'high'
let xterm16_colormap = 'softlight'
let xterm16_white = '#ffffff'
colo xterm16
set background=light

set encoding=utf-8
set termencoding=utf-8
set modelines=0
set title               " Change terminal's title.
set showcmd             " Show command as you type it.
set showmode            " Show current mode.
set nohlsearch          " Don't uglify just cause I searched.
set noshowmatch         " Don't show matching brackets.
set matchtime=0         " Blink matching chars for 0 seconds.
set history=1000
set undolevels=1000
set novisualbell
set noerrorbells
set ttyfast             " 1980 is long past.
set lazyredraw          " Don't redraw in macros.
set autoread            " Watch for file changes.
set shell=/bin/bash
"set isfname+=32         " Filenames have spaces. Kind of broken.

set spellsuggest=10
set autoindent
set nosmartindent
set nocindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround          " Use multiple of shiftwidth when indenting with '<' and '>'.
set nostartofline       " Leave my cursor position alone!.
set backspace=2         " Equiv to :set backspace=indent,eol,start.
set nowrap              " Don't wrap lines.
set linebreak           " Wrap lines at convenient points.
set more                " Use more prompt.
set nobackup            " Live dangerously.
set hidden              " Hide buffers instead of closing them.
set shortmess=atI       " Shorten messages and no splash screen.
set list                " Show invisible characters.
set listchars=tab:>·    " But only show tabs.
let g:clipbrdDefaultReg = '+'
" Paste Toggle
set pastetoggle=<F9> " When in insert mode, press <F11> to go to paste mode.
" Freakin awesome, start scrolling 5 lines from top/bottom/left/right.
set scrolloff=5
set sidescrolloff=5
" Freakin awesome file completion.
set wildmenu
set wildmode=list:longest,full
set wildignore=*.pyc,*.pyo,*.o,*.obj,*.swp,*.DS_Store?
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
" When opening, jump to the last known cursor position.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
" Remember stuff after quiting: marks, registers, searches, buffer list.
set viminfo='20,<50,s10,h,%
" Remove any trailing whitespace that is in the file.
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
" Make Pyflakes workth with pep8
let g:pyflakes_use_quickfix = 0

set mousehide           " Hide the mouse pointer while typing.
set guioptions=a        " Hide scrollbar/menu/tabs/etc.
if has('gui_running')
  set encoding=utf-8
  "set guifont=Monospace\ Bold\ 9
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
  " Turn off toolbar and menu.
  set guioptions-=T
  set guioptions-=m
end

" Status line is gnarly.
set statusline=%F%m%r%h%w%<\ \ %{&ff}%y%=0x\%02.2B\ /\ \%03.3b\ \ %04lr:%02vc\ \ [%p%%\ of\ %L]
set laststatus=2


" Key Bindings
" :map normal, insert, visual, command
" :imap insert
" :vmap visual
" :cmap command
" :nmap normal

"F1 not help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
"F5 not compile
autocmd filetype python map <buffer> <F5> :w<CR>:!pyflakes %<CR>
autocmd filetype python imap <buffer> <F5> <Esc>:w<CR>:!pyflakes %<CR>
autocmd filetype python map <buffer> <S-F5> :w<CR>:!pylint %<CR>
autocmd filetype python imap <buffer> <S-F5> <Esc>:w<CR>:!pylint %<CR>
" <C-6> switches to alternate file and correct column.
nnoremap <C-6> <C-6>`"

";=: jj=ESC
nnoremap ; :
inoremap jj <ESC>

" Emacs movement keybindings in insert mode.
map <C-a> ^
map <C-e> $
" Swap these keps cause ` is cooler but ' is easier to type.
nnoremap ' `
nnoremap ` '
" Reflow paragraph with Q in normal and visual mode.
nnoremap Q gqap
vnoremap Q gq
" Make Y consistent with C and D.
nnoremap Y y$

" Buffer navigation.
map <C-right> <ESC>:bn<CR>
map <C-left> <ESC>:bp<CR>


" Fast find / obnoxious higlight word under cursor.
"function Funkmaster()
"    if &hlsearch
"        set nohlsearch
"    else
"        set hlsearch
"    endif
"endfunction
"nnoremap <space> :call Funkmaster()<CR>

" Indent with spacebar.
nnoremap <space> >>
vnoremap <space> >>

" Complete filenames/lines with a quicker shortcut.
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Sudo write
cmap w!! w !sudo tee % >/dev/null

" :o <file> open file if in path, open gf in new buffer.
cab o find
map gf :edit <cfile><CR>

let mapleader = ","

" Highlight merge conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Shortcut to jump to next merge conflict marker.
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

" Jump to other window, handy with pep8
nmap <leader>w <C-W><C-W>

nmap <leader>g :GundoToggle<CR>
nmap <leader>d :RopeGotoDefinition<CR>
nmap <leader>r :RopeRename<CR>
nmap <leader>a :Ack!

nmap <leader># :s/^/#/<CR>
vmap <leader># :s/^/#/<CR>
nmap <leader>3 :s/^/#/<CR>
vmap <leader>3 :s/^/#/<CR>
nmap <leader>u :s/#//<CR>
vmap <leader>u :s/#//<CR>

" ReST titles
nmap <leader># yypVr#o
nmap <leader>= yypVr=o
nmap <leader>- yypVr-o
nmap <leader>~ yypVr~o
nmap <leader>^ yypVr^o
nmap <leader>* yypVr*o

" Sloppy fingers
command WQ wq
command Wq wq
command W w
command Q q

cab spellon setlocal spell spelllang=en_us
iab teh the
iab adn and
iab Todo TODO:
iab todo TODO:
iab todo: TODO:
iab months- January February March April May June July August September October November December
iab 80- 1234567890123456789012345678901234567890123456789012345678901234567890123456789
iab me- Norman J. Harman Jr.
iab time- <C-R>=strftime("%H:%M:%S")<CR>
iab date- <C-R>=strftime("%a, %d %b %Y")<CR>
iab now- <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>

"" Tab completion
" SuperTab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-p>"
let g:SuperTabNoCompleteAfter = [':', ',', '\s']
"let g:SuperTabLongestEnhanced = 1
autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
  \   call SuperTabSetDefaultCompletionType("context") |
  \ endif

set completeopt=menuone,longest,preview
" Python calltips
"set iskeyword+=.
" Jump to matching pairs easily, with Tab
nnoremap <tab> %
vnoremap <tab> %


" Formating
au FileType python setlocal formatoptions=cqlro textwidth=80
au FileType text setlocal formatoptions=tan1 nocindent textwidth=78
" t - Autowrap to textwidth
" c - Autowrap comments to textwidth
" q - Allow formatting of comments with :gq
" l - Don't wrap already long lines on insert
" a - Reformat when text inserted or deleted, only comments with c flag
" n - Recognize numbered lists when wrapping
" 1 - When wrapping paragraphs, don't end lines with one letter words
" 2 - Support 1st line indent
" r - Autoinsert comment leader with <Enter>
" o - Autointert comment leader with 'o' 'O'


" Bunch of crap.
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
au BufNewFile,BufRead *settings.py setlocal filetype=python.django
au BufNewFile,BufRead *.html       setlocal filetype=htmldjango
au BufNewFile,BufRead *.scss       setlocal ft=scss.css
au BufNewFile,BufRead *.sass       setlocal ft=sass.css
au BufEnter *.erb       setlocal softtabstop=2|setlocal shiftwidth=2
au BufEnter *.rb        setlocal softtabstop=2|setlocal shiftwidth=2
au BufEnter *.js        setlocal softtabstop=2|setlocal shiftwidth=2
au BufEnter *.json      setlocal softtabstop=2|setlocal shiftwidth=2
au BufEnter *.html      setlocal softtabstop=2|setlocal shiftwidth=2

" Ghetto Slime https://github.com/jpalardy/vim-slime
" Start screen (in other terminal)
"   scheme: screen -S sicp rlwrap scheme -large
"    shell: screen -S bash
function Screen_Vars()
  if !exists("g:slime")
    let g:slime = {"sessionname": ""}
  end
  let g:slime["sessionname"] = input("session name: ", g:slime["sessionname"], "custom,Screen_Session_Names")
endfunction
function Send_to_Screen(text)
  if !exists("g:slime")
    call Screen_Vars()
  end
  let escaped_text = substitute(shellescape(a:text), "\\\\\n", "\n", "g")
  call system("screen -S " . g:slime["sessionname"] . " -X stuff " . escaped_text)
endfunction
" Scheme reset
nmap <C-c><C-a> :call Send_to_Screen("(restart 1)\n")<CR>
" Send visual selection
vmap <C-c><C-c> "ry:call Send_to_Screen(@r)<CR>
" Send current block
nmap <C-c><C-c> vip<C-c><C-c>
" Send entire file
nmap <F10> :0,$y r<CR>:call Send_to_Screen(@r)<CR>
" Proly should use and set vim vars...
nmap <F11> <ESC>:w<CR>:call Send_to_Screen("./runall.py\n")<CR>
" \eGj esc to command mode, go to end of history, go up one history item.
imap <F12> <ESC>:w<CR>:call Send_to_Screen("\eGj\n")<CR>
nmap <F12> :w<CR>:call Send_to_Screen("\eGj\n")<CR>
