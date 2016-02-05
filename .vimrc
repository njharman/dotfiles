" :highlight Group ctermbg=white ctermfg=black term=bold
" :match Group /pattern/
" :match ErrorMsg /\%>73v.\+/ # \%> match col, 'v' virtual columns only
" :match None
" :2match :3match
" :setlocal spell spelllang=en_us suggest "z=", addword "zg", next/prev "]s"/"[s"
" searches # * g# g* g, gd

" Secuure file editing
"set nobackup
"set nowritebackup
"set noundofile
"set noswapfile
"set viminfo=""
"set noshelltemp
"set history=0
"set nomodeline
"set secure



" Edit / reload .vimrc
nmap <silent> <leader>ve :e $MYVIMRC<CR>
nmap <silent> <leader>vr :so $MYVIMRC<CR>

set nocompatible
filetype off

"" Vundle
"  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" :h vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"call vundle#begin('~/some/path/here')

"" Examples
"" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
"" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
"" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
"" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'fs111/pydoc.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'nvie/vim-flake8'
Plugin 'sjl/gundo.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'voithos/vim-python-matchit'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'chrisbra/csv.vim'

" I never remember to use these
"Plugin 'tpope/vim-surround'
"Plugin 'tpope/vim-repeat'

" not sold on usefulness yet
"Plugin 'vim-scripts/YankRing.vim'
"generate airline like status lines
" Plugin 'edkolev/promptline.vim'
" Plugin 'edkolev/tmuxline.vim'
"integrates with airline
"Plugin 'jmcantrell/vim-virtualenv'

call vundle#end()
filetype plugin indent on

let mapleader = " "

"" Statusline / Airline
set laststatus=2
set statusline=%F%m%r%h%w%<\ \ %{&ff}%y%=0x\%02.2B\ /\ \%03.3b\ \ %04lr:%02vc\ \ [%p%%\ of\ %L]
" "syntastic
" set statusline+=%#warningmsg#
" "set statusline+=%{SyntasticStatuslineFlag let python_highlight_all=1
let g:airline_theme='dark'
let g:airline_theme='sol'
let g:airline_left_sep=''
let g:airline_right_sep=''
" let g:airline_left_sep = '»'
" let g:airline_right_sep = '«'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#default#layout = [
  \ [ 'warning', 'a', 'b', 'c' ],
  \ [ 'x', 'y', 'z' ]
  \ ]
let g:airline_section_a = airline#section#create(['paste', 'iminsert', 'crypt'])

"" Gundo.
nmap <silent> <leader>u :GundoToggle<CR>

"" CtrlP
"<c-z> to mark/unmark multiple files and <c-o> to open them.
"<c-j>, <c-k> or the arrow keys to navigate the result list.
"<c-n>, <c-p> to select the next/previous string in the prompt's history.
"<c-y> to create a new file and its parent directories.
"<c-t> or <c-v>, <c-x> to open the selected entry in a new tab or in a new split.
"<c-f> and <c-b> to cycle between modes.
"<c-d> to switch to filename only search instead of full path.
"<c-r> to switch to regexp mode.
"<F5> to purge the cache for the current directory to get new files, remove deleted files and apply new ignore options.
let g:ctrlp_cmd = 'CtrlP' "CtrlPMixed
" default search by filename
let g:ctrlp_by_filename = 1
" default regex search, switch with <C-r>
let g:ctrlp_regexp = 1
" 1 - follow but ignore looped internal symlinks to avoid duplicates.
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_working_path_mode = 'a'

"" Flake8
"Should be the F8 key, OBVIOUSLY!
au FileType python map <buffer> <F8> :call Flake8()<CR>
au FileType python imap <buffer> <F8> <ESC>:call Flake8()<CR>
let g:flake8_quickfix_height=12
let g:flake8_show_in_gutter=1
"let g:flake8_show_in_file=1

"" Pydoc
":pyd foo
" switch these edit source
" <leader>pw <leader>pW
nmap <leader>ps :PydocSearch
" open with most of the window
let g:pydoc_window_lines=0.7
" open vertical instead
let g:pydoc_open_cmd = 'vsplit'

"" Tab completion

"" Jedi
":Pyimport os    open os.py
"<leader>g typical goto function
"<leader>d follow identifier as far as possible, includes "imports and statements)
"<leader>r Rename
"<leader>n shows all the usages of a name
"K Show Documentation/Pydoc
"
let g:jedi#show_call_signatures = "2"
"let g:jedi#use_splits_not_buffers = "left"
"let g:jedi#use_tabs_not_buffers = 1
"" don't popup on .
"let g:jedi#popup_on_dot = 0
"" no docstring popup
"autocmd FileType python setlocal completeopt-=preview

"" Syntastic
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_quiet_messages = { "type": "style" }


"" SuperTab
" tab to start completion
map <S-Tab> <C-x><C-p>
set completeopt=menuone,longest,preview
"let g:SuperTabContextDefaultCompletionType = "<c-p>"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabNoCompleteAfter = [':', ',', '\s', '^']
let g:SuperTabLongestEnhanced = 0
let g:SuperTabClosePreviewOnPopupClose = 1


" Freakin awesome file completion.
set wildmenu
set wildmode=longest:full,full
set wildignore=*.pyc,*.pyo,*.o,*.obj,*.swp
set wildignore+=.hg,.git,.svn,*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp,*.ico
set wildignore+=*.tgz,*.gz,*.zip,*.bz2,*.exe,*.bin

" :o <file> open file in path.
cab o find
" gf edit file even if it doesn't exist.
"map gf :edit <cfile><CR>
" Search file's directory, then up from file's directory, then vim's cwd.
set path+=.,./**,,
" If line has 'include' replace dots with slashes and try gf again.
"set isfname+=32         " Filenames have spaces. Kind of broken.
set includeexpr=substitute(v:fname,'\\.','/','g')
au filetype python setlocal suffixesadd=.py


syntax on
set t_Co=256
set background=light
let g:lucius_style='light'
let g:pydoc_highlight=0 " Hate hi-lite
let xterm16_brightness = 'high'
let xterm16_colormap = 'softlight'
let xterm16_white = '#ffffff'
colo lucius
"colo norm
"colo xterm16

set modeline
set modelines=10
set nobomb              " no Byte Order Mark
set ttimeout
set ttimeoutlen=100
set encoding=utf-8
set termencoding=utf-8
set title               " Change terminal's title.
set showcmd             " Show command as you type it.
set showmode            " Show current mode.
"set noshowmode          " if mode is in airline.
set nohlsearch          " Don't uglify just cause I searched.
set ignorecase          " ignore case in search.
set smartcase           " unless search term includes caps.
set noshowmatch         " Don't show matching brackets.
set matchtime=0         " Blink matching chars for 0 seconds.
set nrformats-=octal    " Octals, wat?
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
set spellsuggest=10
set fileformat=unix
set shiftround          " Use multiple of shiftwidth when indenting with '<' and '>'.
set nostartofline       " Leave my cursor position alone!.
set backspace=indent,eol,start
set nowrap              " Don't wrap lines.
set linebreak           " Wrap lines at convenient points.
set more                " Use more prompt.
set noswapfile          " Live dangerously.
set nobackup            " Live dangerously.
set nowritebackup
set hidden              " Hide buffers instead of closing them.
set shortmess=ato       " Shorten messages and no splash screen.
set viewoptions=unix,slash
set list                " Show invisible characters.
set listchars=tab:>·,extends:>,precedes:< " But only show tabs, long line markers.
let g:clipbrdDefaultReg = '+'
set clipboard=unnamed   " access system clipboard on osX
set pastetoggle=<F9> " When in insert mode, press <F11> to go to paste mode.
" Freakin awesome, start scrolling 5 lines from top/bottom/left/right.
set scrolloff=5
set sidescrolloff=5

set nosmartindent
set nocindent
set autoindent

set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2


" GUI
set selectmode=mouse    " Don't enter visual mode cause I touch mouse!
set mouse=hr            " Let me copy/past dammit.
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


" Remember stuff after quiting: marks, registers, searches, buffer list.
set viminfo='20,<50,s10,h,%
" When opening, jump to the last known cursor position.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif


"" Splits
" :sv <filename> vert split
" :vs <filename> horz split
set splitbelow
set splitright
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


"F1 showing help is not helpful
au filetype python map <buffer> <F1> <ESC>
au filetype python imap <buffer> <F1> <ESC>
"F5 is not compile
"au filetype python map <buffer> <F5> :w<CR>:!flake8 %<CR>
"au filetype python imap <buffer> <F5> <ESC>:w<CR>:!flake8 %<CR>
au filetype python map <buffer> <F5> <ESC>
au filetype python imap <buffer> <F5> <ESC>

nmap ; :
imap jj <ESC>
cmap jj <up>
cmap kk <down>

" Switch to alternate file *and* correct column.
nnoremap <C-6> <C-6>`"

" Swap these keys cause ` is cooler but ' is easier to type.
nmap ' `

" Make Y consistent with C and D.
nmap Y y$

" Reflow paragraph with Q in normal and visual mode.
nmap Q gqap
vmap Q gq
" Vmap for maintain Visual Mode after shifting > and <
"vmap < <gv
"vmap > >gv


" Sudo write.
cmap w!! w !sudo tee % >/dev/null

" Complete filenames/lines with a quicker shortcut.
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Jump to matching pairs easily, with Tab.
nmap <tab> %
vmap <tab> %

" Indent with spacebar.
nmap <leader><space> >>
vmap <leader><space> >>

" isort visual selection
vmap  <leader>i :!isort -<CR>
" autopep8 visual selection
vmap  <leader>8 :!autopep8 -<CR>

" ReST titles
nmap <silent> <leader>* yypVr*
nmap <silent> <leader># yypVr#
nmap <silent> <leader>= yypVr=
nmap <silent> <leader>- yypVr-
nmap <silent> <leader>~ yypVr~
nmap <silent> <leader>^ yypVr^

" Jump to other window
nmap <leader>w <C-W><C-W>

" Highlight merge conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Shortcut to jump to next merge conflict marker.
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

" Error-list nav
nnoremap <leader>[ :cprev<CR>
nnoremap <leader>] :cnext<CR>
" Having leader=<space> and insert mode leader defined is annoying as all hell.
"inoremap <leader>[ :cprev<CR>
"inoremap <leader>] :cnext<CR>

" Buffer navigation.
":ls list
":b# jump to
map <right> <ESC>:bn<CR>
map <left> <ESC>:bp<CR>

" Help Nav
au FileType help :noremap <buffer> q :q<CR>
au FileType help :nnoremap <buffer> <CR> <C-]>
au FileType help :nnoremap <buffer> <BS> <C-T>
au FileType help :nnoremap <buffer> o /'\l\{2,\}'<CR>
au FileType help :nnoremap <buffer> O ?'\l\{2,\}'<CR>
au FileType help :nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
au FileType help :nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>


cab spellon setlocal spell spelllang=en_us<CR>
" Sloppy fingers
cnorea W! w!
cnorea Q! q!
cnorea WQ wq
cnorea Wq wq
cnorea W w
cnorea Q q
cnorea E e
inorea teh the
inorea adn and
inorea Todo TODO:
inorea todo TODO:
inorea todo: TODO:
" Things I never remember to use.
inorea months- January February March April May June July August September October November December
inorea mths- Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
inorea 80- 12345678901234567890123456789012345678901234567890123456789012345678901234567890
inorea hr- --------------------------------------------------------------------------------
inorea me- Norman J. Harman Jr.
inorea time- <C-R>=strftime("%H:%M:%S")<CR>
inorea date- <C-R>=strftime("%a, %d %b %Y")<CR>
inorea now- <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>


"" Filetype handling

" Formatoptions
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

" Hi-light long lines.
au BufWinEnter * let w:m1=matchadd('Search','\%>120v.\+', -1)
au BufWinEnter * let w:m2=matchadd('ErrorMsg','\%<121v.\%>101v', -1)

"" Remove any trailing whitespace that is in the file.
"au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
"" Which is awesome but creates commit noise unless everyone on team ensures no
"" trailing whitespace.
"" Alternative is to fix whitespace only on lines modifed using visual select
"" and :FixWhitespace

au BufEnter * :syntax sync fromstart
au FileType python        :setlocal formatoptions=qln1r textwidth=78 ts=4 sw=4 sts=4
au FileType text          :setlocal formatoptions=tcqn12 nocindent textwidth=78 ts=2 sw=2 sts=2 spell spelllang=en_us
au FileType python        :setlocal omnifunc=pythoncomplete#Complete
au FileType javascript    :setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType html,markdown :setlocal omnifunc=htmlcomplete#CompleteTags
au FileType css           :setlocal omnifunc=csscomplete#CompleteCSS
au FileType xml           :setlocal omnifunc=xmlcomplete#CompleteTags
au Filetype gitcommit     :setlocal spell textwidth=72
au BufNewFile,BufRead *.rst         :setlocal filetype=text
au BufNewFile,BufRead *.html        :setlocal filetype=html
au BufNewFile,BufRead *.scss        :setlocal filetype=scss.css
au BufNewFile,BufRead *.sass        :setlocal filetype=sass.css
au BufNewFile,BufRead *SConscript   :setlocal filetype=python
au BufNewFile,BufRead *SConstruct   :setlocal filetype=python
"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

"abbreviate dopdb import ipdb; ipdb.set_trace()
