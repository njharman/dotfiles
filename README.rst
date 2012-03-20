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

.inputrc
    Readline config. VI mode is the flippin bomb.  Took me months to get use to it but it is so worth it.

.osx
    Not a conf file.  Execute it on osX box to set bunch of crap.

.screenrc
    Fix screen's retarded defaults.

.vim
    Just my colors and `python_pep8 <http://www.vim.org/scripts/script.php?script_id=2914>` cause I modified keybinding to the obviously superior *'f8'* and manually wrapping lines is stupid.

.vimrc
    Fair amount of comments.  Some highlights:

     - Rest titles are nifty.
     - *jj* to exit insert mode is super bad esp on commandline (see .inputrc).
     - InsertTabWrapper mapped to tab is how tab-completion is suppose to work.
     - Auto removing trailing whitespace on save, duh.
     - Poor man's slime with screen.
     - Wish I had learned about scrolloff and wildmenu 10 years earlier
     - Returning to previous position, every tool should do this.
