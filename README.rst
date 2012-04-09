Dotfile config and ~/bin files for njharman@gmail.com

Usage
=====
This is how I do things, YMMV. ::

    cd ~
    git clone blah .dotfiles
    .dofiles/engage.sh

Contents
========
engage.sh
    Read it. Briefly, create some directories, move any existing files, create symlinks to .dotfiles/<stuff>.

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

bin/
    Scripts me likes.

.gemrc
    No slow ass rdocs.

.inputrc
    Readline config. VI mode is the flippin bomb.  Took me months to get use to it but it is so worth it.

.osx
    Not a conf file.  Execute it on osX box to set bunch of crap.

.pylintrc
    Yeah.

.screenrc
    Fix screen's retarded defaults.

.ssh/
    Not copied.  It is template of some common ssh config I use.

.subversion/
    No plaintext passwords.

.vim
    My colors and pathogen managed plugins.
    - ack: programmer's grep.
    - fugitive: git wrapper
    - git: more git
    - gundo: undo
    - help_nav: More better vim help nav.
    - matchit: More better matching.
    - pep8: Map to <F8> for code style nirvana.
    - pydoc: Shows stuff in annoying window.
    - pyflakes: Dynamically show your mistakes.
    - py.test: Hmmm, not sure.
    - ropevim: Refactoring, not sure.
    - supertab: Think this is awesome.
    - surround: More better.
    - vim-ipython: This didn't work for me.

.vimrc
    Fair amount of comments.  Some highlights:

     - Supertab
     - ReST titles are nifty.
     - *jj* to exit insert mode is super bad esp on commandline (see .inputrc).
     - Auto removing trailing whitespace on save, duh.
     - Poor man's slime with screen.
     - Wish I had learned about scrolloff and wildmenu 10 years earlier
     - Returning to previous position, every tool should do this.
