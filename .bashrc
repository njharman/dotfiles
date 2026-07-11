# If not running interactively, don't do anything
[ -z "$PS1" ] && return

is_osx() { echo $OSTYPE | grep -q darwin; }
path_append()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend() { path_remove $1; export PATH="$1:$PATH"; }
path_remove()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

#shopt -s cdspell        # Automatically fix 'cd folder' spelling mistakes.
shopt -s checkwinsize   # Resize window after each command, updating the values of LINES and COLUMNS.
shopt -s histappend     # Append to history file instead of overwriting; needed so multiple tmux panes don't clobber each other's history.
shopt -s globstar       # Enable ** to match files/dirs recursively in glob patterns.
stty -ixon  # Limit terminal "locking" from ^S et al.
stty ixany  # Allow any character to restart output.

export HISTSIZE=999999
export HISTFILESIZE=999999
export HISTIGNORE='[bf]g:cd:cd .:cd -:cd ~:l[sal]:ls -al:history:exit::'
export HISTCONTROL=ignorespace:erasedups
# Require three consecutive ^D (eof) to exit terminal.
export IGNOREEOF=2
# Immediately append each command to the history file and share it with other
# panes/shells, instead of only writing history when the shell exits.
# NOT exported: exporting it leaks stale hook names (e.g. VTE's
# __vte_prompt_command) into tmux panes' environment, which don't re-run
# /etc/profile.d (non-login shells) to redefine those functions, causing
# "command not found" on every prompt.
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
# Ensure on syspath, but only once.
[[ ":$PATH:" != *":/sbin:"* ]] && PATH="/sbin:${PATH}"
[[ ":$PATH:" != *":/usr/sbin:"* ]] && PATH="/usr/sbin:${PATH}"
path_prepend "$HOME/.local/bin"
export PATH

## Preferred tools
export PAGER=/usr/bin/less
export MANPAGER=/usr/bin/less
export EDITOR=/usr/bin/vim

## Just work dammit
export PYTHONIOENCODING=UTF-8
export PIP_REQUIRE_VIRTUALENV=true

# Put virtualenvs in a centralized location, not within each project directory.
export UV_PREVIEW=1
export UV_PREVIEW_FEATURES="centralized-project-envs"

# set up CDPATH to where personal code projects are stored
if [ -e $HOME/dropbox/code ]; then
  export CDPATH='.:~/dropbox/code'
fi
# ditto for work projects, legacy virtualenvwrapper things
if [ -e $HOME/work ]; then
  # export WORKON_HOME=$HOME/work/.virtualenvs
  # export PROJECT_HOME=$HOME/work
  export CDPATH="${CDPATH:+$CDPATH:}~/work/"
fi

## Aliases and such
# Top 20 most run commands
alias myhistory='sed "s|sudo ||g" ~/.bash_history|cut -d " " -f 1|sort|uniq -c|sort -rn|head -20'
alias greph='history|grep'
alias la='/usr/bin/eza -AF'
alias ll='/usr/bin/eza -lgF'
# list by modified time, reverse order
alias lt='/usr/bin/eza -lgF --reverse -s modified'
# NOTE: $EDITOR expands now (alias definition time), so this line must stay
# below the `export EDITOR=...` line above it, or it silently uses an empty EDITOR.
alias visudo="/usr/bin/sudo EDITOR=$EDITOR /usr/sbin/visudo"
# Vim muscle memory
alias :e=/usr/bin/vim
# Shortify git commands.
alias ga='git add'
alias gd='git diff'
alias gt='git st'
alias gdd='git diff --stat develop'
alias gdt='git diff --stat trunk'
# Recursively remove compiled python files.
alias nukepyc="/usr/bin/find . -depth \( -name '*.py[co]' -or -name '__pycache__' \) -exec /bin/rm -rf {} ';'"
# Change dir to Python module's source.
function cdp { cd $(python3 -c"import os,sys;print(os.path.dirname(__import__(sys.argv[1]).__file__))" $1); }
# Find file with 'foo' in name using Rust fd (fdfind on ubuntu).
function f { /usr/bin/fdfind -uiL "$@" .; }
# Searching running processes
if is_osx; then
  function psg { /bin/ps axu | `which grep` -v grep | `which grep` "$@" -i --color=auto; }
  # Fuzzy-pick a process line with fzf (replaces percol, which is unmaintained).
  function psp { /bin/ps axu | fzf --header-lines=1; }
else
  function psg { /bin/ps axuf | `which grep` -v grep | `which grep` "$@" -i --color=auto; }
  function psp { /bin/ps axuf | fzf --header-lines=1; }
fi


## Colors & Prompt
# Git enhance prompt
function parse_git_dirty {
  # Modern git no longer prints "nothing to commit (working directory clean)",
  # so check porcelain status directly instead of matching that stale message.
  [[ -n $(git status --porcelain 2> /dev/null) ]] && echo "*"
  }
function prompt_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
  }
function prompt_or_jobs {
  jcnt=`jobs|wc -l|sed "s/ //g"`
  [ 0 -eq $jcnt ] && echo "$1" || echo "[$jcnt]"
  }
function prompt_virtualenv() {
  if [ -n "$VIRTUAL_ENV_PROMPT" ]; then
    echo "[${VIRTUAL_ENV_PROMPT}]"
  elif [ -n "$VIRTUAL_ENV" ]; then
    echo "[${VIRTUAL_ENV##*/}]"  # ##*/ strips the path, leaving only the last component.
  fi
  }

# Don't add env to prompt (my prompt already does this)
export VIRTUAL_ENV_DISABLE_PROMPT=1
# Shorten prompt paths.
PROMPT_DIRTRIM=2

# The prompts
if [ -x /usr/bin/tput ] && tput setaf 1 >& /dev/null; then
  color_prompt=yes
else
  color_prompt=
fi
if [ "$color_prompt" = yes ]; then
  _RED="\[\033[0;31m\]"
  _LTRED="\[\033[1;31m\]"
  _BLUE="\[\033[0;34m\]"
  _TEAL="\[\e[0;36m\]"
  _GREEN="\[\033[0;32m\]"
  _LTGREEN="\[\033[1;32m\]"
  _WHITE="\[\033[1;37m\]"
  _BLACK="\[\033[00m\]"
  if [ 0 -eq $UID ]; then
    PS1="$_RED\u$_GREEN@\h:$_BLUE\w$_RED\$(prompt_or_jobs '#') $_BLACK"
  else
    PS1="$_GREEN\u@\h:$_BLUE\w$_BLACK\$(prompt_virtualenv)\$(prompt_git_branch)\$(prompt_or_jobs '$') "
    # no user/host
    PS1="$_BLUE\w$_GREEN\$(prompt_virtualenv)$_BLACK\$(prompt_git_branch)\$(prompt_or_jobs '$') "
  fi
else
  PS1='\u@\h:\w\$ '
fi
PS2='> '
PS4='+ '
unset color_prompt _RED _LTRED _BLUE _TEAL _GREEN _LTGREEN _WHITE _BLACK

# ls colors
export CLICOLOR=1
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  # Must come after dircolors: LS_COLORS keeps the last value seen per key, so
  # this disables coloring of executable/suid/sgid/capability files without
  # being clobbered by dircolors' own su/sg/ca defaults.
  export LS_COLORS="${LS_COLORS}:su=00:sg=00:ca=00:"
  alias ls='ls --color=auto'
fi

# grep colors (GREP_COLORS, plural - GREP_COLOR is deprecated and ignored by modern grep)
export GREP_COLORS='mt=1;32'

# less/man colors
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'


## Tab Completions
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  source /etc/bash_completion
fi
if is_osx; then
    . `brew --prefix`/etc/bash_completion
fi
# Cache these instead of eval'ing the subprocess on every shell startup
# (regenerate by deleting the cache file, e.g. after upgrading pip/uv).
_completion_cache_dir="$HOME/.cache/bash-completion"
mkdir -p "$_completion_cache_dir"
if command -v pip >/dev/null 2>&1; then
  [ -s "$_completion_cache_dir/pip" ] || pip completion --bash > "$_completion_cache_dir/pip"
  source "$_completion_cache_dir/pip"
fi
if command -v uv >/dev/null 2>&1; then
  [ -s "$_completion_cache_dir/uv" ] || uv generate-shell-completion bash > "$_completion_cache_dir/uv"
  source "$_completion_cache_dir/uv"
fi
unset _completion_cache_dir

# Fuzzy history search (Ctrl-R) and completion, if fzf is installed.
if command -v fzf >/dev/null 2>&1; then
  if fzf --bash >/dev/null 2>&1; then
    eval "$(fzf --bash)"
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
  fi
fi


## Local things
if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
