# If not running interactively, don't do anything
[ -z "$PS1" ] && return

is_osx() { echo $OSTYPE | grep -q darwin; }
path_append()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend() { path_remove $1; export PATH="$1:$PATH"; }
path_remove()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

shopt -s cdspell        # Automatically fix 'cd folder' spelling mistakes.
shopt -s checkwinsize   # Resize window after each command, updating the values of LINES and COLUMNS.
stty -ixon  # Limit terminal "locking" from ^S et al.
stty ixany  # Allow any character to restart output.

# Faster sorting
export LC_COLLATE=C
export LANG=C
# Faster ls, don't colorize executable, suid, sgid, or capbilities
export LS_COLORS='ex=00:su=00:sg=00:ca=00:'

export HISTSIZE=999999
export HISTFILESIZE=999999
export HISTIGNORE='[bf]g:cd:cd -:cd ~:l[sal]:ls -al:history:exit::'
export HISTCONTROL=erasedups
# Require three consecutive ^D (eof) to exit terminal.
export IGNOREEOF=2
# Ensure things are in path, but only once.
[[ ":$PATH:" != *":/sbin:"* ]] && PATH="/sbin:${PATH}"
[[ ":$PATH:" != *":/usr/sbin:"* ]] && PATH="/usr/sbin:${PATH}"
path_prepend $HOME/bin
export PATH

# Just work dammit
export PYTHONIOENCODING=UTF-8

## Preferred tools
export PAGER=/usr/bin/less
export MANPAGER=/usr/bin/less
export EDITOR=/usr/bin/vim

## A "work" aka dev box.
if [ -e $HOME/work ]; then
  export CDPATH='.:~/work/'
  export WORKON_HOME=$HOME/work/.virtualenvs
  export PROJECT_HOME=$HOME/work
fi

## Aliases and Such
# Top 20 most run commands.
alias myhistory='sed "s|sudo ||g" ~/.bash_history|cut -d " " -f 1|sort|uniq -c|sort -rn|head -20'
alias gh='history|grep'
alias la='/bin/ls -GA'
alias ll='/bin/ls -lGF'
alias lt='/bin/ls -Gltrsa'
alias visudo="/usr/bin/sudo EDITOR=$EDITOR /usr/sbin/visudo"
# Muscle memory.
alias :e=/usr/bin/vim
# Recursively remove compiled python files.
alias nukepyc="/usr/bin/find . -depth \( -name '*.py[co]' -or -name '__pycache__' \) -exec /bin/rm -rf {} ';'"
# Shortify git commands.
alias ga='git add'
alias gt='git st'
alias gd='git diff'
alias gn='git diff --stat'
alias gdd='git diff develop'
alias gdn='git diff --stat develop'
function ge { $EDITOR $(git diff --name-only --relative $@); }
# It's called ack, dammit!
which ack &> /dev/null || alias ack="ack-grep"
# Change dir to Python module source.
function cdp { cd $(python3 -c"import os,sys;print(os.path.dirname(__import__(sys.argv[1]).__file__))" $1); }
function cd2 { cd $(python -c"from __future__ import print_function;import os,sys;print(os.path.dirname(__import__(sys.argv[1]).__file__))" $1); }
# Find file with 'foo' in name.
function f { /usr/bin/find . -iname "*$@*"; }
# Searchign running processes
if is_osx; then
  function psg { /bin/ps axu | `which grep` -v grep | `which grep` "$@" -i --color=auto; }
  function psp { /bin/ps axu | percol; }
else
  function psg { /bin/ps axuf | `which grep` -v grep | `which grep` "$@" -i --color=auto; }
  function psp { /bin/ps axuf | percol; }
fi


## Colors & Prompt

# Git enhance prompt.
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
  }
function prompt_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
  }
function prompt_or_jobs {
  jcnt=`jobs|wc -l|sed "s/ //g"`
  [ 0 -eq $jcnt ] && echo "$1" || echo "[$jcnt]"
  }
function prompt_virtualenv() {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "[${VIRTUAL_ENV##*/}]"
  fi
  }

if [ -e /lib/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm'
fi

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
    export PS1="$_RED\u$_GREEN@\h:$_BLUE\w$_RED\$(prompt_or_jobs '#') $_BLACK"
  else
    export PS1="$_GREEN:$_BLUE\w$_BLACK\$(prompt_virtualenv)\$(prompt_git_branch)\$(prompt_or_jobs '$') "
  fi
else
  PS1='\h:\w\$ '
fi

PROMPT_DIRTRIM=2
unset color_prompt

export PS2='> '
export PS4='+ '

# ls colors.
export CLICOLOR=1
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# grep colors.
export GREP_COLOR='1;32'

# less/man colors.
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

## Local Things
if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
