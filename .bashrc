# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

export HISTSIZE=10000
export HISTFILESIZE=999999
export HISTIGNORE='[bf]g:cd:cd -:cd ~:ls:ls -al:la:ll:l:history:exit'
export HISTCONTROL=ignoreboth
export IGNOREEOF=2
export PATH=$HOME/bin:/sbin:/usr/sbin:$PATH
export CDPATH='.:~/work/'

export PAGER=less
export MANPAGER=less
export EDITOR=vim
if [ -e $HOME/bin/svneditor ]; then
    export SVN_EDITOR=$HOME/bin/svneditor
else
    export SVN_EDITOR=$EDITOR
fi
if [ -e /usr/bin/meld ]; then
    export SVN_MERGE=/usr/bin/meld
    export SVN_DIFF=/usr/bin/meld
fi

alias ll='ls -alF'
alias la='ls -A'
# Hate nano, very much.
alias visudo="sudo EDITOR=$EDITOR visudo"
# It's called ack, dammit!
which ack &> /dev/null || alias ack="ack-grep"
# Chdir to python module source.
function cdp() {
   cd $(python -c"import os,sys;print os.path.dirname(__import__(sys.argv[1]).__file__)" $1)
   }
# Recursively remove compiled python files.
alias nukepyc="find . -name '*py[co]' -exec rm -f {} ';';find . -name '__pycache__' -exec rm -rf {} ';'"
# Muscle memory.
alias :e=vim
# Requires highlight to be installed
alias hl='highlight -M'


## Colors & Prompt
function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
    }
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
    }

if [ -e /lib/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
fi
if [ "$color_prompt" = yes ]; then
    RED="\[\033[0;31m\]"
    LTRED="\[\033[1;31m\]"
    BLUE="\[\033[0;34m\]"
    TEAL="\[\e[0;36m\]"
    GREEN="\[\033[0;32m\]"
    LTGREEN="\[\033[1;32m\]"
    WHITE="\[\033[1;37m\]"
    BLACK="\[\033[00m\]"
    if [ 0 -eq ${UID} ]; then
        export PS1="$RED\u@\h:$BLUE\w$BLACK\$(parse_git_branch)\$"
    else
        export PS1="$TEAL\u$GREEN@\h:$BLUE\w$BLACK\$(parse_git_branch)\$ "
    fi
else
    PS1='\h:\w\$ '
fi
export PS2='> '
export PS4='+ '

PROMPT_DIRTRIM=2
unset color_prompt

# ls colors
export CLICOLORS=1
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# grep colors
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# less/man colors
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'


## Bash completions
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi
function _pip_completion() {
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" COMP_CWORD=$COMP_CWORD PIP_AUTO_COMPLETE=1 $1 ) )
    }
complete -o default -F _pip_completion pip


## Local things
if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi
