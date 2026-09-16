About
=====
Author: Norman J. Harman Jr. <njharman@gmail.com>

Dotfile, ``~/.local/bin``, and other stuff to 'normanize' shell and vim.

Targets two systems: **Omarchy** (Arch + Hyprland) and **Ubuntu LTS**.
Desktop and window-manager config lives elsewhere; this repo is commandline and
vim, and is expected to work on a server you ssh into once.


Usage
=====
::

    cd ~
    wget https://raw.github.com/njharman/dotfiles/trunk/engage.sh
    bash engage.sh basic      # or: full
    rm engage.sh

Three cumulative tiers:

basic
    Shell, readline, git, ``sag``/``g``, and a working vim (config, colors and
    plugins). Simple "sysadmin" baseline.

vim
    Update vim plugins.

full
    ``basic`` + ``vim`` + development extras.

Options::

    --dry-run        print what would change, touch nothing
    --no-packages    skip the package install (the slow part of a re-run)


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

``.bashrc_base`` holds everything shared across distros, then sources
``~/.bashrc_os``. OS is detected at install time and only the matching layer
-- ``.bashrc_omarchy`` or ``.bashrc_ubuntu`` -- is linked to ``~/.bashrc_os``.

Readline is a special case. Omarchy runs ``bind -f`` on its own inputrc *after*
readline has already read ``~/.inputrc``, silently overriding it -- including
dropping out of vi mode. ``.bashrc_base`` re-applies ``~/.inputrc`` at the end
of startup. Because ``bind -f`` is additive rather than a reset, Omarchy's
completion behaviour that we don't name is inherited.

Vim is the other special case. ``.vimrc`` calls ``vundle#begin()``
unconditionally, so a machine with the config but no Vundle throws errors on
every start. That is why ``basic`` installs the plugins rather than leaving them
to the ``vim`` tier.


Contents
========

engage.sh
---------
    - Detects OS (omarchy / ubuntu).
    - Installs packages, creates directories.
    - Symlinks dotfiles, ``bin/``, and ``config/git``.
    - Appends the ``.bashrc_base`` hook to ``~/.bashrc``.
    - Archives anything it displaces to ``~/tmp/.dotfile_preserve/<timestamp>/``.


Shell
-----

.inputrc
    Readline. VI editing mode, prefix history search, completion tuning.
    Grouped into labelled sections; see Design above for the Omarchy interaction.

.bashrc_base
    Shared interactive config, sourced last from the OS's own ``~/.bashrc``.
    History (size, dedup, immediate cross-shell sharing), ``stty`` fixes,
    ``EDITOR``/``SUDO_EDITOR``, ``CDPATH`` (``.``, ``~/Dropbox/code``,
    ``~/Work``), aliases, functions, tool completions, and the ``~/.inputrc``
    re-apply.

.bashrc_omarchy
    Near-empty on purpose; documents what Omarchy already supplies.

.bashrc_ubuntu
    Re-adds by hand what Omarchy gets for free: ``PAGER``/``MANPAGER``,
    ``LESS_TERMCAP_*``, fzf key bindings, ``/etc/bash_completion``.
    Note Ubuntu names ``fd`` as ``fdfind`` and ``bat`` as ``batcat``, and has no
    ``eza`` in the LTS archive -- the ls aliases fall back to coreutils.

.bash_local
    Not part of the repository. Sourced last by ``.bashrc_base`` for
    machine-specific configuration.


Aliases and functions
---------------------
Set in ``.bashrc_base``. ``ls`` and ``lt`` (tree) are left to Omarchy.

f
    Case insensitive find file with 'foo' in name.

cdp
    cd to source of Python module.

ll, la, lm
    Long, long-with-hidden, and by-modified-time listings. Flags match
    Omarchy's ``ls`` so the family looks consistent.

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
    ``full`` only.

.psqlrc
    Postgresql Timing on, visible nulls.

.sagrc
    Config for sag (see ``bin/sag``).

.screenrc
    Fix screen's defaults. Still used on some machines.

.vimrc, .vim/
    Plugins managed with Vundle::

        :PluginList / :PluginInstall / :PluginUpdate / :PluginSearch


~/.local/bin
------------

sag / g
    Wrapper for ripgrep with shortcuts that open results at the right line in
    the editor. ``sag foo`` searches, ``g 3`` opens the third hit. ``g`` is
    generated by ``sag`` on first run (not checked in).

    Note ``.bashrc_base`` runs ``unalias g``. Omarchy aliases ``g`` to ``git``,
    which would shadow ``~/.local/bin/g`` (the sag shortcut opener). Sag wins;
    ``git`` is short enough to type.

memuse
    Measure peak memory usage of a command.

code
    ``code <proj>[/sub] [-n]``: cd to a Python project under ``~/Dropbox/code``
    and drop into ``uv run bash`` (venv active, prompt shows ``[proj]``). The venv
    lives in ``~/.venvs/<proj>`` (``UV_PROJECT_ENVIRONMENT``), outside Dropbox;
    ``<proj>/.venv`` is a symlink to it so pyright/Claude/editors find it. ``-n``
    only prepares (link + ``uv sync``). Pick Python per project with
    ``uv python install 3.x`` + ``uv python pin 3.x``. Requires uv.

mysum
    Sum numeric columns from stdin. (Named to avoid shadowing coreutils ``sum``.)

256colors.py
    Verify terminal is 'shiny'.
