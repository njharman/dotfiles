About
=====
Author: Norman J. Harman Jr. <njharman@gmail.com>

Dotfile, ``~/.local/bin``, and other stuff to 'normanize' shell.

Targets two systems: **Omarchy** (Arch + Hyprland) and **Ubuntu LTS**.


Usage
=====
::

    cd ~
    wget https://raw.github.com/njharman/dotfiles/trunk/engage.sh
    bash engage.sh install    # packages for the detected OS
    bash engage.sh            # symlinks, directories
    rm engage.sh

``engage.sh --dry-run`` prints what would change without touching anything.

Sudoers ::

  njharman   ALL=NOPASSWD: ALL


Design
======

Omarchy provides a large default shell environment: starship prompt, zoxide for
``cd``, eza for ``ls``, bat as the man pager, fzf key bindings, bash completion,
and mise. Rather than replace any of it, these dotfiles **layer on top**.

``engage.sh`` never symlinks over ``~/.bashrc``. On Omarchy that file is the
bootstrap which sources ``$OMARCHY_PATH/default/bash/rc``; replacing it would
discard every default. Instead a single line is appended::

    [[ -f ~/.bashrc_base ]] && source ~/.bashrc_base

On Ubuntu the same line is appended to the distro's ``~/.bashrc``.

``.bashrc_base`` holds everything shared, then sources ``~/.bashrc_os``.
``engage.sh`` detects the OS at install time and links only the matching layer
-- ``.bashrc_omarchy`` or ``.bashrc_ubuntu`` -- to that name, so the other never
appears in ``~``. ``ls -l ~/.bashrc_os`` shows which one is active.

Readline is a special case. Omarchy runs ``bind -f`` on its own inputrc *after*
readline has already read ``~/.inputrc``, silently overriding it -- including
dropping out of vi mode. ``.bashrc_base`` re-applies ``~/.inputrc`` at the end
of startup. Because ``bind -f`` is additive rather than a reset, Omarchy's
completion behaviour that we don't name is inherited.


Contents
========

engage.sh
---------
    - Detects OS (omarchy / ubuntu).
    - Creates directories.
    - Symlinks dotfiles, ``bin/``, and ``config/`` trees.
    - Appends the ``.bashrc_base`` hook to ``~/.bashrc``.
    - Archives anything it displaces to ``~/tmp/.dotfile_preserve/<timestamp>/``.
    - ``install`` subcommand installs packages for the detected OS.


Shell
-----

.inputrc
    Readline. VI editing mode, prefix history search, completion tuning.
    Grouped into labelled sections; see Design above for the Omarchy interaction.

.bashrc_base
    Shared interactive config, sourced last from the OS's own ``~/.bashrc``.
    History (size, dedup, immediate cross-shell sharing), ``stty`` fixes,
    ``EDITOR``/``SUDO_EDITOR``, uv centralized virtualenvs, aliases, functions,
    tool completions, and the ``~/.inputrc`` re-apply.

.bashrc_omarchy
    Near-empty on purpose; documents what Omarchy already supplies.

.bashrc_ubuntu
    Re-adds by hand what Omarchy gets for free: ``PAGER``/``MANPAGER``,
    ``LESS_TERMCAP_*``, ``CDPATH``, fzf key bindings, ``/etc/bash_completion``.
    Note Ubuntu names ``fd`` as ``fdfind`` and ``bat`` as ``batcat``, and has no
    ``eza`` in the LTS archive -- the ls aliases fall back to coreutils.

.bash_local
    Not part of the repository. Sourced last by ``.bashrc_base`` for
    machine-specific configuration.


Aliases and functions
---------------------
Set in ``.bashrc_base``. ``ls`` and ``lt`` (tree) are left to Omarchy.

ll, la, lm
    Long, long-with-hidden, and by-modified-time listings. Flags match
    Omarchy's ``ls`` so the family looks consistent.

cdp
    cd to source of Python module.

f
    Case insensitive find file with 'foo' in name.

myhistory
    Twenty most typed command lines.

nukepyc
    Recursively remove ``.pyc``/``.pyo`` files and ``__pycache__``.

psg, psp
    Grep running processes; fuzzy-pick one.


Configs
-------

.gitconfig
    The single global git config. Git reads both ``~/.config/git/config`` and
    ``~/.gitconfig``; ``engage.sh`` retires the former so there is only one.
    Global ignore patterns live in ``config/git/ignore``.

.git-template/
    Git init template. ``hooks/pre-commit`` requires the ``pre-commit`` package.

config/
    Tracked ``~/.config`` trees. ``config/git`` is linked everywhere;
    ``config/hypr``, ``config/omarchy``, and ``config/starship.toml`` only on
    Omarchy.

    **Caveat:** ``omarchy refresh hyprland`` and friends follow these symlinks
    and write *into the repo*. That is desirable -- a reset shows up as a git
    diff instead of silently vanishing -- but it means a refresh is a repo
    change, not a local one. Check ``git status`` after running one.

.psqlrc
    Timing on, visible nulls.

.sackrc
    Config for sack (see ``bin/sag``).

.screenrc
    Fix screen's defaults. Still used on some machines.

.tmux.conf
    Terminal multiplexor.

.vimrc, .vim/
    Plugins managed with Vundle::

        :PluginList / :PluginInstall / :PluginUpdate / :PluginSearch


~/.local/bin
------------

sag / g
    Wrapper__ for ripgrep with shortcuts that open results at the right line in
    the editor. ``sag foo`` searches, ``g 3`` opens the third hit.

    Note ``.bashrc_base`` runs ``unalias g``. Omarchy aliases ``g`` to ``git``,
    which would shadow ``~/.local/bin/g`` (the sack shortcut opener). Sack wins;
    ``git`` is short enough to type.

__ https://github.com/sampson-chen/sack

code
    cd to a Python project under ``~/Dropbox/code`` and drop into ``uv run bash``.
    Requires uv.

mysum
    Sum numeric columns from stdin. (Named to avoid shadowing coreutils ``sum``.)

memuse
    Measure peak memory usage of a command.

invoice
    Parse ``utt report`` output into invoice.rst.

256colors.py, colortest.pl
    Verify terminal is 'shiny'.

jo, rockme
    tmux session helpers. Deprecated, pending a move to herdr.
