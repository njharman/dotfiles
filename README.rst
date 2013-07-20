About
=====
Author: Norman J. Harman Jr. <njharman@gmail.com>

Dotfile, ~/bin, and other stuff to 'normanize' shell.


Usage
=====
This is how I do things, YMMV. ::

    cd ~
    wget https://raw.github.com/njharman/dotfiles/master/engage.sh
    ./engage.sh && rm engage.sh

Things to install
-----------------
ag; apt-get install automake liblzma

apt-get vim, meld, build-essential

pip install nosecomplete

Copy bash_completion.d/ to /etc/

Contents
========
engage.sh
    Read the source. Briefly,
      - Creates directories
      - Creates symlinks to *.dotfiles/foo*.
      - Creates .ipython profile
      - Creates .subversion
      - Creates .vim et al
      - Moves existing files to ``~/tmp/.dotfile_preserve``.
      - Updates from git repo https://github.com/njharman/dotfiles


Binaries
--------
All in ``~/bin/``.

rockme [<session>]
    Create (or connect to existing) *tmux* session.

go <target>
    Open *tmux* window with 3 panes ssh'd to target.

256colors2.pl & colortest.pl
    Verify terminal is 'shiny'.

ack
    Beyond grep__.

__ http://beyondgrep.com/

ag
    Faster than ack. Download, build and install locally.
    https://github.com/ggreer/the_silver_searcher.git ::

        apt-get install automake liblzma
        ./build.sh

cdiff
    Colorize svn diffs. Used by bash aliases *dif* & *difs*.

sicp
    Uses *screen* for poor man's slime__.

__ http://en.wikipedia.org/wiki/SLIME

svneditor
    It's rad.

    ``export SVN_EDITOR=$HOME/bin/svneditor``

thesaurus
    Lookup word in online thesaurus, used by vim <leader>t


Aliases
-------
These are set in ``.bashrc`` along with some that fix Ubuntu annoyances.

ll, la, & lt
    Standard long and all directory listings.

cdp
    cd to source of Python module.

dif & difs
    Colorized svn diff and side by side diff.

fname
    Case insensitive find file with 'foo' in name.

nukepyc
    Recursively remove ``.pyc`` and ``.pyo`` files.

psgrep
    Kind of like ``pgrep -fl`` with more "stuff".


Configs
-------
.bash_logout
    Yeah.

.bash_profile
    **"Processed for login shells."** Whatever, put everything in ``.bashrc``.

.bash_local
    Not part of repository, is sourced by ``.bashrc`` For any local specific bash configuration.

.bashrc
    HISTORY, PATH, PAGER, EDITOR, etc.
    CDPATH, search path for the *cd* command, Is neat. cdspell.
    meld__ for SVN_MERGE & SVN_DIFF. ``~/bin/svneditor`` (or vim) for SVN_EDITOR.
    Many Aliases.
    Git enhanced, colorized prompt (RED for root). Other colorizations.
    Bash completions.
    Finally sourcing ``.bash_local``.

__ http://meldmerge.org/

bash_completion.d
    Copy to /etc/bash_completion.d/
    ``vagrant`` from https://github.com/rjw1/vagrant-bash-completion

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
   - Thesaurus word look up using online thesaurus.

.vim/
    Colors and pathogen managed plugins. Initialize submodules on fresh clone::

      git submodule init
      git submodule update

    Add new submodule::

      git submodule add <link> .vim/bundle/<name>

    Remove submodule::

      Delete from .gitmodules
      Delete from .git/config
      git rm --cached path_to_submodule (no trailing slash)

    Get upstream updates::

      git submodule foreach git pull origin master

    Plugins

    - ctrlp: Fuzzy finder. ``:h ctrlp-commands``, ``:h ctrlp-extensions``
    - dbext: Database shell. ``:h dbext-tutorial``
    - gundo: Undo.
    - help_nav: Better help navigation, *<enter>* to "follow" link.
    - matchit: Better % matching.
    - pep8: Map to *<F8>* for code style nirvana.
    - pydoc: `Pydoc re.compile`.
    - pyflakes: Dynamically reveal your incompetence.
    - python_calltips: *<tab>* to show function signature, etc.
    - slime-vim:
    - supertab: This is awesome.
    - surround: *ds"* delete, *cs])* change, *ysiw)* surround motion/text object, *dst* "html tag"
    - vim-abolish:
      coerce case; *crs* (snake_case), *crm* (MixedCase), *cru* (UPPER_CASE).
      Subvert/address{,es}/reference{,s}/
    - vim-commentary: (un)comment lines (gcc, gcu).
    - vim-pathogen: Vim package manager.
    - vim-repeat:
    - vim-speeddating: increment dates properly (*<C-a>*, *<C-x>*, *d<C-a>* utc, *d<C-x>* local).


Templates
---------
.ssh/
    ssh configuration template.

.osx
    Not a configuration file.  Execute it under osX to set bunch of crap.
