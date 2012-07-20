#!/bin/bash
# Symlink some dotfiles, yo!

REPO="git://github.com/njharman/dotfiles.git"
WORK=~/.dotfiles
SAVE=~/tmp/.dotfile_preserve


function symtastico {
  # make symlinks, ignoring directories and archiving existing files.
  destdir=$1
  shift
  for file in $@; do
    if [ -f "$file" ]; then
       name=`basename "$file"`
       if [ "$name" == ".gitignore" -o "$name" == ".gitmodules" -o "$name" == ".osx" ]; then
         continue
       fi
       dest=$destdir/$name
       echo -n "$dest, "
       if [ -h $dest ]; then
         echo -n "re-"
         rm $dest
       elif [ -e $dest ]; then
         echo -n "exists, archived to $SAVE/, "
         mkdir -p "$SAVE"
         mv $dest "$SAVE/"
       fi
       ln -s $file $dest
       echo "symlinked."
    fi
  done
  }


function symlamedir {
  # Make directory symlinks, bitch about existing ones.
  destdir=$1
  shift
  for path in $@; do
    if [ -d "$path" ]; then
       name=`basename "$path"`
       dest=$destdir/$name
       echo -n "$dest, "
       if [ -h $dest ]; then
         echo -n "re-"
         rm $dest
       elif [ -e $dest ]; then
         echo "exists. Abort!"  # TODO: make red
         continue
       fi
       ln -s $path $dest
       echo "symlinked."
    fi
  done
  }


function init_the_dotfiles {
  ## Clone repo if missing. Otherwise, leave it to user to pull/update.
  if [ ! -d "$WORK" ]; then
    mkdir -p "$WORK"
    git clone "$REPO" $WORK
    cd $WORK
    # old systems don't got the CA
    git config --global http.sslVerify false
    git config --global user.name "Norman J. Harman Jr."
    git config --global user.email njharman@gmail.com
    git submodule init
    git submodule update
  fi
  }

function engage_sym {
  # Do all the stuff that's fun to do.

  ## .dotfiles
  symtastico ~ `ls -ad "$WORK"/\.*`

  ## ~/.vim  (pathogen & bundles, pretty colors)
  mkdir -p ~/.vim/bundle ~/.vim/colors
  symlamedir ~/.vim/bundle `ls -d "$WORK"/.vim/bundle/*`
  symtastico ~/.vim/colors `ls -d "$WORK"/.vim/colors/*`

  ## ~/.ssh
  # Just dir/permissions.  Don't wanna autolink config...
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  chmod -f 600 ~/.authorized_keys
  chown -R $USER ~/.ssh

  ## ~/.subversion
  mkdir -p ~/.subversion
  chmod 700 ~/.subversion
  chmod -Rf o-rw ~/.subversion/auth/*
  chown -R $USER ~/.subversion
  symtastico ~/.subversion `ls -d "$WORK"/.subversion/*`

  ## ~/bin
  mkdir -p ~/bin
  chmod 700 ~/bin
  symtastico ~/bin `ls -d "$WORK"/bin/*`

  ## ~/tmp ~/work
  mkdir -p ~/tmp
  mkdir -p ~/work
  chmod 700 ~/tmp ~/work
  }


function engage_up {
  # Update repo.
  cd $WORK
  git pull
  }


function engage_vim {
  # Update repo.
  cd $WORK
  git submodule foreach git pull origin master
  }


init_the_dotfiles

if [[ "$1" == "help" ]]; then
    prog=`basename $0`
    cat <<USAGE
$prog      - (re)create symbolic links, directories, etc
$prog up   - git pull
$prog vim  - git pull pathogen submodules
$prog all  - all of the above
USAGE
elif [[ "$1" == "up" ]]; then
    engage_up
elif [[ "$1" == "vim" ]]; then
    engage_vim
elif [[ "$1" == "all" ]]; then
    engage_up
    engage_vim
    engage_sym
else
    engage_sym
fi
