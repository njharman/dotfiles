" :highlight Group ctermbg=white ctermfg=black term=bold
" :match Group /pattern/
" :match ErrorMsg /\%>73v.\+/ # \%> match col, 'v' virtual columns only
" :match None
" :2match :3match
" :setlocal spell spelllang=en_us suggest "z=", addword "zg", next/prev "]s"/"[s"
" searches # * g# g* g, gd
" <leader>pw python docs
" ctrl-r ctrl-w word complete in command line

set nocompatible

filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
syntax on

set t_Co=256
set background=light

let xterm16_brightness = 'high'
let xterm16_colormap = 'softlight'
let xterm16_white = '#ffffff'
let g:solarized_termcolors=256
let g:lucius_style='light'
colo lucius
"colo solarized
"colo xterm16

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
set undofile            " Persist undo history.
set undodir=~/.backup,~/tmp,.
set backupdir=~/.backup,~/tmp,.,/tmp
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
set shortmess=ato       " Shorten messages and no splash screen.
set viewoptions=unix,slash
set list                " Show invisible characters.
set listchars=tab:>·    " But only show tabs.
let g:clipbrdDefaultReg = '+'
set clipboard=unnamed
set pastetoggle=<F9> " When in insert mode, press <F11> to go to paste mode.
" Freakin awesome, start scrolling 5 lines from top/bottom/left/right.
set scrolloff=5
set sidescrolloff=5
" Freakin awesome file completion.
set wildmenu
set wildmode=longest:full,full
set wildignore=*.pyc,*.pyo,*.o,*.obj,*.swp
set wildignore+=.hg,.git,.svn,*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp,*.ico
" When opening, jump to the last known cursor position.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
" Remember stuff after quiting: marks, registers, searches, buffer list.
set viminfo='20,<50,s10,h,%
" Remove any trailing whitespace that is in the file.
au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
" Make Pyflakes workth with pep8
let g:pyflakes_use_quickfix = 0
" Hate the hi-lite
let g:pydoc_highlight=0
" Python-mode
"let g:pymode_run=0
"let g:pymode_folding=0
"let g:pymode_lint_ignore="E501,E122,E123,E124,E126,E127,E128"
"let g:pymode_lint_onfly=1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'

set mouse=a
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

"" Gnarly status line.
set laststatus=2
set statusline=%F%m%r%h%w%<\ \ %{&ff}%y%=0x\%02.2B\ /\ \%03.3b\ \ %04lr:%02vc\ \ [%p%%\ of\ %L]

"" Key Bindings
" :map normal, insert, visual, command
" :nmap normal
" :imap insert
" :vmap visual
" :cmap command

"F1 is not helpful
map <F1> <ESC>
"F5 is not compile
au filetype python map <buffer> <F5> :w<CR>:!pylint %<CR>
au filetype python imap <buffer> <F5> <Esc>:w<CR>:!pylint %<CR>
" Switche to alternate file *and* correct column.
nmap <C-6> <C-6>`"

";=: jj=ESC
nmap ; :
imap jj <ESC>
cmap jj <up>
cmap kk <down>

" Swap these keys cause ` is cooler but ' is easier to type.
nmap ' `
" Reflow paragraph with Q in normal and visual mode.
nmap Q gqap
vmap Q gq
" Make Y consistent with C and D.
nmap Y y$

" Sudo write.
cmap w!! w !sudo tee % >/dev/null

" Page down w/ space.
nmap <space> <pagedown>

" Jump to matching pairs easily, with Tab.
nnoremap <tab> %
vnoremap <tab> %
" Add angles to matching pairs. Can't figure out why matchit not loading.
:set mps+=<:>

let mapleader = ","

" Thesaurus completion
fun! ReadThesaurus()
    " Assign current word under cursor to a script variable
    let s:thes_word = expand('<cword>')
    " Open a new window, keep the alternate so this doesn't clobber it.
    keepalt split thes_
    " Show cursor word in status line
    exe "setlocal statusline=thesaurus" . s:thes_word
    " Set buffer options for scratch buffer
    setlocal noswapfile nobuflisted nowrap nospell buftype=nofile bufhidden=hide
    " Delete existing content
    1,$d
    " Run the thesaurus script
    exe ":0r !/home/nharman/bin/thesaurus " . s:thes_word
    " Goto first line
    1
    " Set file type to 'thesaurus'
    set filetype=thesaurus
    " Map q to quit without confirm
    nmap <buffer> <CR> "tyiw:q<CR>viw"tpa
    nmap <buffer> q :q<CR>a
endfun
imap <leader>t <ESC>:call ReadThesaurus()<CR><CR>

" Indent with spacebar.
nmap <leader><space> >>
vmap <leader><space> >>

" Buffer navigation.
map <right> <ESC>:bn<CR>
map <left> <ESC>:bp<CR>

" Highlight merge conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Shortcut to jump to next merge conflict marker.
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

" Jump to other window, handy with pep8.
nmap <leader>w <C-W><C-W>
" Gundo.
nmap <leader>U :GundoToggle<CR>

" Comment lines vim-commentary; gcc, gcu.
au FileType python :setlocal commentstring=#\ %s

" ReST titles
nmap <leader>* yypVr*
nmap <leader># yypVr#
nmap <leader>= yypVr=
nmap <leader>- yypVr-
nmap <leader>~ yypVr~
nmap <leader>^ yypVr^

" Sloppy fingers
command WQ wq
command Wq wq
command W w
command Q q
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
cab spellon setlocal spell spelllang=en_us<CR>


"" Tab completion
map <S-Tab> <C-x><C-p>
" SuperTab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-p>"       " Secondary completion type
let g:SuperTabContextTextOmniPrecedence = ['&completefunc']
"let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabNoCompleteAfter = [':', ',', '\s', '^']
let g:SuperTabLongestEnhanced = 0
let g:SuperTabLongestHighlight = 1
let g:SuperTabClosePreviewOnPopupClose = 1
au FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
  \   call SuperTabSetDefaultCompletionType("context") |
  \ endif
set completeopt=menuone,longest,preview


"" Finding files to edit
" Complete filenames/lines with a quicker shortcut.
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>
" :o <file> open file in path.
cab o find
" gf edit file even if it doesn't exist.
"map gf :edit <cfile><CR>
" Search up from current directory, then up from parent directory when gf'ing.
:set path+=.,**2
":set path+=**,.,,./**
" If line has 'include' replace dots and try gf again.
:set includeexpr=substitute(v:fname,'\\.','/','g')
" Search in (some) python library paths
"au filetype python :setlocal path+=/usr/local/lib/python2.7/dist-packages/,/usr/lib/python2.7/|setlocal suffixesadd=.py
au filetype python :setlocal suffixesadd=.py


"" Formating
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
au FileType python setlocal formatoptions=cqlr textwidth=80
au FileType text setlocal formatoptions=tn12 nocindent textwidth=78 spell spelllang=en_us

"" Filetype handling
au FileType help :nmap <buffer> q :q<CR>
nnoremap _dt :set ft=htmldjango<CR>
nnoremap _pd :set ft=python.django<CR>
au FileType html,markdown :setlocal omnifunc=htmlcomplete#CompleteTags|setlocal softtabstop=2|setlocal shiftwidth=2
au FileType javascript :setlocal omnifunc=javascriptcomplete#CompleteJS|setlocal softtabstop=2|setlocal shiftwidth=2
au FileType python :setlocal omnifunc=pythoncomplete#Complete
au FileType xml :setlocal omnifunc=xmlcomplete#CompleteTags|setlocal softtabstop=2|setlocal shiftwidth=2
au FileType css :setlocal omnifunc=csscomplete#CompleteCSS|setlocal softtabstop=2|setlocal shiftwidth=2
au BufNewFile,BufRead *.html        :setlocal filetype=htmldjango
au BufNewFile,BufRead *.scss        :setlocal filetype=scss.css
au BufNewFile,BufRead *.sass        :setlocal filetype=sass.css
au BufNewFile,BufRead *.csproj      :setlocal filetype=xml
au BufNewFile,BufRead *.csprops     :setlocal filetype=xml
au BufNewFile,BufRead *SConscript   :setlocal filetype=python
au BufNewFile,BufRead *SConstruct   :setlocal filetype=python
au BufNewFile,BufRead *.json        :setlocal softtabstop=2|setlocal shiftwidth=2
au BufNewFile,BufRead *.yml         :setlocal softtabstop=2|setlocal shiftwidth=2
au BufNewFile,BufRead *.erb         :setlocal softtabstop=2|setlocal shiftwidth=2
au BufNewFile,BufRead *.rb          :setlocal softtabstop=2|setlocal shiftwidth=2

"" Ghetto Slime https://github.com/jpalardy/vim-slime
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
