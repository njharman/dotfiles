# If not running interactively, don't do anything
[ -z "$PS1" ] && return


export HISTSIZE=999999
export HISTFILESIZE=999999
export HISTIGNORE='[bf]g:cd:cd -:cd ~:l[sal]:ls -al:history:exit::'
export HISTCONTROL=erasedups
# Require three consecutive ^D (eof) to exit terminal.
export IGNOREEOF=2
export PATH=$HOME/bin:/sbin:/usr/sbin:$PATH
export CDPATH='.:~/work/'
shopt -s cdspell        # Automatically fix 'cd folder' spelling mistakes.
shopt -s checkwinsize   # Resize window after each command, updating the values of LINES and COLUMNS.
# Limit terminal "locking" from ^S et al.
stty -ixon
stty ixany


## Preferred tools
export PAGER=/usr/bin/less
export MANPAGER=/usr/bin/less
export EDITOR=/usr/bin/vim
FOO=`which svneditor`
if [ -e "$FOO" ]; then
    export SVN_EDITOR="$FOO"
else
    export SVN_EDITOR="$EDITOR"
fi
FOO=`which meld`
if [ -e "$FOO" ]; then
    export SVN_MERGE="$FOO"
    export SVN_DIFF="$FOO"
fi
unset FOO


## Aliases and Such
# Muscle memory.
alias :e=/usr/bin/vim
# It's called ack, dammit!
which ack &> /dev/null || alias ack="ack-grep"
# Chdir to Python module source.
function cdp { cd $(python -c"import os,sys;print os.path.dirname(__import__(sys.argv[1]).__file__)" $1); }
# Color diffs, requires cdiff.
function dif { svn diff $@ | cdiff; }
function difs { svn diff $@ | cdiff -s; }
# Find file with 'foo' in name.
function f { /usr/bin/find . -iname "*$@*"; }
alias gh='history|/bin/grep'
alias la='/bin/ls -A'
alias ll='/bin/ls -lF'
alias lt='/bin/ls -ltrsa'
# Top 20 most run commands.
alias myhistory='/bin/sed "s|/usr/bin/sudo ||g" ~/.bash_history|/usr/bin/cut -d " " -f 1|/usr/bin/sort|/usr/bin/uniq -c|/usr/bin/sort -rn|/usr/bin/head -20'
# Recursively remove compiled python files.
alias nukepyc="/usr/bin/find . -name '*py[co]' -exec /bin/rm -f {} ';';/usr/bin/find . -name '__pycache__' -exec /bin/rm -rf {} ';'"
# Alternative pgrep.
function psgrep { /bin/ps axuf | /bin/grep -v grep | /bin/grep "$@" -i --color=auto; }
# Hate nano, very much.
alias visudo="/usr/bin/sudo EDITOR=$EDITOR /usr/sbin/visudo"


## Colors & Prompt

# Git enhance prompt.
function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
    }
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
    }
function prompt_or_jobs {
    count=`jobs|wc -l`
    [ 0 -eq $count ] && echo "$1" || echo "($count)"
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
    _RED="\[\033[0;31m\]"
    _LTRED="\[\033[1;31m\]"
    _BLUE="\[\033[0;34m\]"
    _TEAL="\[\e[0;36m\]"
    _GREEN="\[\033[0;32m\]"
    _LTGREEN="\[\033[1;32m\]"
    _WHITE="\[\033[1;37m\]"
    _BLACK="\[\033[00m\]"
    if [ 0 -eq $UID ]; then
        export PS1="$_RED\u$_GREEN@\h:$_BLUE\w$_BLACK\$(parse_git_branch) $_RED\$(prompt_or_jobs '$') $_BLACK"
    else
        export PS1="$_TEAL\u$_GREEN@\h:$_BLUE\w$_BLACK\$(parse_git_branch) \$(prompt_or_jobs '#') "
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
export GREP_OPTIONS='--color=auto'
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
#FIGNORE A  colon-separated  list  of suffixes to ignore when performing filename completion (see READLINE below).  A filename whose suffix matches one of the entries in FIGNORE is excluded from the list of matched filenames.  A sample value is ".o:~" (Quoting is needed when assigning a value to this variable, which contains tildes).


# Pip bash completions.
function _pip_completion() {
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" COMP_CWORD=$COMP_CWORD PIP_AUTO_COMPLETE=1 $1 ) )
    }
complete -o default -F _pip_completion pip

# Nosetests bash completions. Requires pip install nosecomplete
__ltrim_colon_completions() {
    # If word-to-complete contains a colon,
    # and bash-version < 4,
    # or bash-version >= 4 and COMP_WORDBREAKS contains a colon
    if [[ "$1" == *:* && ( ${BASH_VERSINFO[0]} -lt 4 || (${BASH_VERSINFO[0]} -ge 4 && "$COMP_WORDBREAKS" == *:*)) ]]; then
        # Remove colon-word prefix from COMPREPLY items
        local colon_word=${1%${1##*:}}
        local i=${#COMPREPLY[*]}
        while [ $((--i)) -ge 0 ]; do
            COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
        done
    fi
}
_nosetests()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
    __ltrim_colon_completions "$cur"
}
complete -o nospace -F _nosetests nosetests


## Local Things
if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi
