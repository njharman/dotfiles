About
=====
Author: Norman J. Harman Jr. <njharman@gmail.com>

Dotfile, ~/bin, and other stuff to 'normanize' shell.


Usage
=====
This is how I do things, YMMV. ::

    cd ~
    wget https://raw.github.com/njharman/dotfiles/master/engage.sh
    ./engage.sh ubuntu
    ./engage.sh
    rm engage.sh


Things to install
-----------------
./engage.sh ubuntu  # Installs the following...

Ubuntu ::
    apt-get install build-essential aptitude
    apt-get install zsh tmux vim git git-flow meld tree bash-completion
    #apt-get install subversion
    ## sack/sag/ag
    apt-get install automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    git clone https://github.com/ggreer/the_silver_searcher
    cd the_silver_searcher
    ./build.sh
    mv ag ~/bin/

OSX ::
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install wget tmux git git-flow tree bash-completion
    #brew install meld x11?
    brew install the_silver_searcher
    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    rm get-pip.py
    bash ~/.dotfiles/osx

Python ::
    sudo apt-get -y install python-dev
    sudo apt-get -y install python-pip
    sudo -H pip install -U vex virtualenv pip
    sudo -H pip install -U tox nose nosecomplete pep8 pep8-naming flake8 pyflakes coverage cprofilev isort
    #sudo -H pip install -U pdbpp wdb # pdb++, web debugger
    # Three python repls
    sudo -H pip install -U ipython memory_profiler line_profiler
    #sudo -H pip install -U bpython   # better docstrings
    #sudo -H pip install -U ptpython  # vim input, customizable
    #sudo -H pip install -U pipdeptree # dependencies in graph
    #https://github.com/mitsuhiko/pipsi

Other tools ::
    sudo -H pip install -U percol  # visual grep
    #sudo -H pip install -U ohmu    # diskspace usage
    git clone https://github.com/licenses/lice.git

    Edit .ssh/config based on ssh/config.
    Install bash_completion.d/


Contents
========

engage.sh
---------
Read the source. Briefly it...

    - Creates directories
    - Creates symlinks to *.dotfiles/foo*.
    - Creates .ipython profile
    - Creates .subversion
    - Creates .vim et al
    - Moves existing files to ``~/tmp/.dotfile_preserve``.
    - Updates from git repo https://github.com/njharman/dotfiles


Aliases
-------
These are set in ``.bashrc``.

ll, la, & lt
    Standard long and all directory listings.

cdp
    cd to source of Python module.

dif & difs
    Colorized svn diff and side by side diff.

fname
    Case insensitive find file with 'foo' in name.

gh
    Grep bash command history. Too lazy to type ``history|grep``.

myhistory
    Twenty most typed command lines.  Apparently I hit return (no command) often. ::

   7004 vim
   6418 cd
   3888 svn
   2282 ls
   1500
   1285 git
   1252 ack
   1200 rm
   1162 ssh
   1154 mv
    904 ansible
    695 scp
    583 python
    542 cp
    517 cat
    484 ./test
    481 go
    451 apt-get
    351 find
    279 pip

nukepyc
    Recursively remove ``.pyc`` and ``.pyo`` files.

psg
    Like ``pgrep -fl`` with more "stuff".


Tools
-----

meld
    Gnome's visual diff and merge tool. http://meldmerge.org/

percol
    Interactive grep tool. https://github.com/mooz/percol

tmux
    Terminal Multiplexor. More bettter than screen. I find it easier to script
    (see `rockme` and `jo`). https://tmux.github.io/

tree
    List contents of directories in a tree-like format. Man, life doesn't get
    much better than that.


~/bin/
------

rockme [<session>]
    Create (or connect to existing) *tmux* session.

jo <target> [<session>]
    Open *tmux* window with several panes ssh'd to target.

256colors.py & colortest.pl
    Verify terminal is 'shiny'.

ack
    Beyond grep__.

__ http://beyondgrep.com/

ag
    Faster than ack. Download, build and install locally.
    https://github.com/ggreer/the_silver_searcher.git

cdiff
    Colorize svn diffs. Used by bash aliases *dif* & *difs*.

sack / sag / g
    Wrapper__ for `ack` / `ag`.

__ https://github.com/sampson-chen/sack

svneditor
    It's rad.

    ``export SVN_EDITOR=$HOME/bin/svneditor``


Configs
-------
.bash_logout
    Yeah.

.bash_local
    Not part of repository, is sourced by ``.bashrc`` For any local specific bash configuration.

.bash_profile
    **"Processed for login shells."** Whatever, put everything in ``.bashrc``.

.bashrc
    HISTORY, PATH, PAGER, EDITOR, etc.
    CDPATH, search path for the *cd* command, Is neat. cdspell.
    meld__ for SVN_MERGE & SVN_DIFF. ``~/bin/svneditor`` (or vim) for SVN_EDITOR.
    Many Aliases.
    Git enhanced, colorized prompt (RED for root). Other colorizations.
    Bash completions.
    Sources ``.bash_local``.

__ http://meldmerge.org/

.config/flake8
    pep8 vim tool config.

.config/pep8
    pep8 command line tool config.

.gemrc
    No slow ass rdocs.

.inputrc
    Readline configuration. VI mode is the flipping bomb.  Took me months to get use to it but it is so worth it.

.ipython
    From http://pynash.org/2013/03/06/timing-and-profiling.html

  - **%time** & **%timeit**: run time, one time / avg (-n 100).
  - **%prun**: run time by function.
  - **%lprun**: run time by line.
  - **%mprun** & **%memit**: memory usage, one time / avg (-n 100).

.pylintrc
    Yeah.

.sackrc
    Yeah.

.screenrc
    Fix screen's retarded defaults.

.subversion/
    Needful configuration.

.tmux.conf
    Use *tmux* instead of screen.

.vimrc
    Fair amount of comments.  Some highlights:

   - Supertab
   - Find files.
   - ReST titles.
   - Auto removing trailing whitespace on save.
   - Returning to previous position on file load, every tool should do this.
   - Wish I had learned about scrolloff and wildmenu 10 years earlier
   - *jj* to exit insert mode is super bad esp on command line (see .inputrc).

.vim/
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    Manage plugins with vundel::

        :PluginList             - lists configured plugins.
        :PluginInstall foo      - installs plugins.
        :PluginUpdate           - updates plugins.
        :PluginSearch foo       - append ! to referesh local cache.

    Plugins

    - https://github.com/chrisbra/csv.vim
    - https://github.com/kien/ctrlp.vim         *<C-p>* Fuzzy file opener
    - https://github.com/sjl/gundo.vim          *<leader>u* Undo tree
    - https://github.com/davidhalter/jedi-vim   python completion, docstring, renaming, more.
    - https://github.com/fs111/pydoc.vim        *pw* *pW* *ps*
    - https://github.com/ervandew/supertab      awesome tab completion.
    - https://github.com/tomtom/tcomment_vim    *gc* (un)comment, *g<* explicit uncomment, *g>* explicit comment
    - https://github.com/bling/vim-airline
    - https://github.com/nvie/vim-flake8        *<F8>* for code style nirvana.
    - https://github.com/tpope/vim-fugitive
    - https://github.com/airblade/vim-gitgutter
    - https://github.com/voithos/vim-python-matchit
    - https://github.com/christoomey/vim-tmux-navigator unified tmux/vim nav.
    - https://github.com/bronson/vim-trailing-whitespace   *:FixWhitespace* (visual selection or whole file)


Templates
---------
Things not automatically copied / installed.

bash_completion.d
    Copy to /etc/bash_completion.d/
    ``vagrant`` from https://github.com/rjw1/vagrant-bash-completion

osx
    Not a configuration file.  Execute it under osX to set bunch of crap.

ssh/
    ssh configuration template.
