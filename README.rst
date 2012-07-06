About
=====
Dotfile, ~/bin, and other files 'normanize' a unix shell.  njharman@gmail.com

Usage
=====
This is how I do things, YMMV. ::

    cd ~
    wget https://raw.github.com/njharman/dotfiles/master/engage.sh
    ./engage.sh && rm engage.sh

Contents
========
engage.sh
    Read it. Briefly, create some directories, move any existing files, create symlinks to .dotfiles/<stuff>.

Binaries
--------
bin/rockme [<session>]
    Create (or connect to existing) tmux session.

bin/go <target>
    Open tmux window with 3 panes sshed to target.

bin/256colors2.pl
    Verify terminal is 'shiny'.

bin/svneditor
    It's rad.

bin/sicp
    Uses screen for poor man's slime.

Templates
---------
.ssh/
    Template of ssh config I use.

.osx
    Not a conf file.  Execute it on osX box to set bunch of crap.

Configs
-------
.ackrc
    *ack* is awesome, you should be using it. http://betterthangrep.com/

.bash_logout
    Yeah.

.bash_profile
    *"Processed for login shells."* Whatever, put everything in .bashrc

.bash_local
    Not part of repo, is sourced by .bashrc For any local specific bash config.

.bashrc
    CDPATH, search path for the *cd* command, is neat.

.gemrc
    No slow ass rdocs.

.inputrc
    Readline config. VI mode is the flippin bomb.  Took me months to get use to it but it is so worth it.

.pylintrc
    Yeah.

.screenrc
    Fix screen's retarded defaults.

.subversion/
    No plaintext passwords.

.tmux.conf
    Use this now instead of screen.

.vimrc
    Fair amount of comments.  Some highlights:

     - Supertab
     - ReST titles are nifty.
     - Auto removing trailing whitespace on save, duh.
     - Returning to previous position, every tool should do this.
     - Wish I had learned about scrolloff and wildmenu 10 years earlier
     - *jj* to exit insert mode is super bad esp on commandline (see .inputrc).
     - Poor man's slime with screen.

.vim/
    Colors and pathogen managed plugins. Init submodules on fresh clone::

      git submodule init
      git submodule update

    Add new submodule::

      git submodule add <link> .vim/bundle/<name>

    Get upstream updates::

      git submodule foreach git pull origin master

    - ack: Programmer's grep.
    - ctrlp: Fuzzy finder. `:h ctrlp-commands`, `:h ctrlp-extensions`
    - dbext: Database shell. `:h dbext-tutorial`
    - gundo: Undo.
    - help_nav: More better vim help nav.
    - matchit: More better matching.
    - pep8: Map to <F8> for code style nirvana.
    - pydoc: `Pydoc re.compile`.
    - pyflakes: Dynamically show your mistakes.
    - python_calltips: Tab to show function signature, etc.
    - supertab: Think this is awesome.
    - surround: More better.
    - vim-pathogen: Vim package manager.
