# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTSIZE=999999
export HISTFILESIZE=999999
export HISTIGNORE='[bf]g:cd:cd -:cd ~:l[sal]:ls -al:history:exit::'
export HISTCONTROL=erasedups
# Require three consecutive ^D (eof) to exit terminal.
export IGNOREEOF=2
export PATH=$HOME/bin:/sbin:/usr/sbin:$PATH
shopt -s cdspell        # Automatically fix 'cd folder' spelling mistakes.
shopt -s checkwinsize   # Resize window after each command, updating the values of LINES and COLUMNS.
# Limit terminal "locking" from ^S et al.
stty -ixon
stty ixany


## Preferred tools
export PAGER=/usr/bin/less
export MANPAGER=/usr/bin/less
export EDITOR=/usr/bin/vim
FOO=`which svneditor 2> /dev/null`
if [ -e "$FOO" ]; then
  export SVN_EDITOR="$FOO"
else
  export SVN_EDITOR="$EDITOR"
fi
FOO=`which meld 2> /dev/null`
if [ -e "$FOO" ]; then
  export SVN_MERGE="$FOO"
  export SVN_DIFF="$FOO"
fi
unset FOO

## A "work" aka dev box.
if [ -e $HOME/work ]; then
  export CDPATH='.:~/work/'
  export WORKON_HOME=$HOME/work/.virtualenvs
  export PROJECT_HOME=$HOME/work
fi


## Aliases and Such
# Hate nano very, very much.
alias visudo="/usr/bin/sudo EDITOR=$EDITOR /usr/sbin/visudo"
# Muscle memory.
alias :e=/usr/bin/vim
#alias ipython="ptipython --vi"
#alias ipython=bpython
# Recursively remove compiled python files.
alias nukepyc="/usr/bin/find -d . \( -name '*.py[co]' -or -name '__pycache__' \) -exec /bin/rm -rf {} ';'"
# Chdir to Python module source.
function cdp { cd $(python -c"from __future__ import print_function;import os,sys;print(os.path.dirname(__import__(sys.argv[1]).__file__))" $1); }
function cd3 { cd $(python3 -c"import os,sys;print(os.path.dirname(__import__(sys.argv[1]).__file__))" $1); }
# It's called ack, dammit!
which ack &> /dev/null || alias ack="ack-grep"
# Color diffs, requires cdiff.
function dif { svn diff $@ | cdiff; }
function difs { svn diff $@ | cdiff -s; }
# Find file with 'foo' in name.
function f { /usr/bin/find . -iname "*$@*"; }
# Alternative to "pgrep -fl".
if [[ "$OSTYPE" = "darwin14" ]]; then
  function psg { /bin/ps axu | `which grep` -v grep | `which grep` "$@" -i --color=auto; }
  function pp { /bin/ps axu | percol; }
else
  function psg { /bin/ps axuf | `which grep` -v grep | `which grep` "$@" -i --color=auto; }
  function pp { /bin/ps axuf | percol; }
fi
alias gh='history|grep'
alias la='/bin/ls -A'
alias ll='/bin/ls -lF'
alias lt='/bin/ls -ltrsa'
# Top 20 most run commands.
alias myhistory='/bin/sed "s|/usr/bin/sudo ||g" ~/.bash_history|/usr/bin/cut -d " " -f 1|/usr/bin/sort|/usr/bin/uniq -c|/usr/bin/sort -rn|/usr/bin/head -20'
alias gt='git st'
alias gd='git diff'
alias ga='git add'


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
  export TERM='xterm-color'
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
    export PS1="$_TEAL\u$_GREEN@\h:$_BLUE\w$_BLACK\$(prompt_virtualenv)\$(prompt_git_branch)\$(prompt_or_jobs '$') "
  fi
else
  PS1='\h:\w\$ '
fi

PROMPT_DIRTRIM=2
unset color_prompt

export PS2='> '
export PS4='+ '

# ls colors.
export CLICOLORS=1
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
# osX
if [[ `which brew` && -f `brew --prefix`/etc/bash_completion ]]; then
    . `brew --prefix`/etc/bash_completion
fi

## Local Things
if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
