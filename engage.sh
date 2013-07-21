#!/bin/bash
# Symlink dotfiles, yo!

REPO="git://github.com/njharman/dotfiles.git"
WORK=~/.dotfiles
SAVE=~/tmp/.dotfile_preserve


function symtastico {
  # Make symlinks, ignoring directories and archiving existing files.
  destdir=$1
  shift
  for file in $@; do
    if [ -f "$file" ]; then
       name=`basename "$file"`
       case $name in
           ".gitignore") continue;;
           ".gitmodules") continue;;
           ".osx") continue;;
           *swp) continue;;
           *~) continue;;
       esac
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


function symdir {
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
    # Old systems don't got the CA
    git config --global http.sslVerify false
    git config --global user.name "Norman J. Harman Jr."
    git config --global user.email njharman@gmail.com
    # Tells git-branch and git-checkout to setup new branches so that git-pull(1) will appropriately merge from that remote branch.  Recommended.  Without this, you will have to add --track to your branch command or manually merge remote tracking branches with "fetch" and then "merge".
    git config branch.autosetupmerge true
    # Convert newlines to the system's standard when checking out files, and to LF newlines when committing in.    │etc/hsflowd.conf
    git config core.autocrlf false
    git config core.filemode true
    # Update submodules
    git submodule init
    git submodule update
  fi
  }


function engage_sym {
  # Do all the stuff that's fun to do.

  ## .dotfiles
  symtastico ~ `ls -ad "$WORK"/\.*`

  ## ~/.config
  mkdir -p ~/.config
  symtastico ~/.config "$WORK/.config/*"

  ## ~/.ipython
  # ipython profile create
  mkdir -p ~/.ipython/extensions
  chmod 700 ~/.ipython ~/.ipython/extensions
  symtastico ~/.ipython/profile_default "$WORK/.ipython/profile_default/ipython_config.py"
  symtastico ~/.ipython/extensions "$WORK/.ipython/extensions/*"

  ## ~/.ssh
  # Just dir/permissions.  Don't wanna autolink config...
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  chmod -f 600 ~/.ssh/authorized_keys
  chown -R $USER ~/.ssh

  ## ~/.subversion
  mkdir -p ~/.subversion
  chmod 700 ~/.subversion
  chmod -Rf o-rw ~/.subversion/auth/*
  chown -R $USER ~/.subversion
  symtastico ~/.subversion `ls -d "$WORK"/.subversion/*`

  ## ~/.vim  (pathogen & bundles, pretty colors)
  mkdir -p ~/.vim/bundle ~/.vim/colors
  chmod 700 ~/.vim ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  symdir ~/.vim/bundle `ls -d "$WORK"/.vim/bundle/*`
  symtastico ~/.vim/colors `ls -d "$WORK"/.vim/colors/*`

  ## ~/bin
  mkdir -p ~/bin
  chmod 700 ~/bin
  symtastico ~/bin `ls -d "$WORK"/bin/*`

  ## ~/tmp ~/work
  mkdir -p ~/tmp
  mkdir -p ~/work
  mkdir -p ~/.backup  # vim undo and backups
  chmod 700 ~/tmp ~/work ~/.backup
  }


function engage_up {
  # Update repo.
  cd $WORK
  git pull
  }


function engage_vim {
  # Update vim plugins.
  cd $WORK
  git submodule init
  git submodule update
  git submodule foreach git pull origin master
  }


init_the_dotfiles

if [[ "$1" == "help" ]]; then
    prog=`basename $0`
    cat <<USAGE
$prog      - (re)create symbolic links, directories, etc.
$prog up   - git pull
$prog vim  - git pull pathogen submodules
$prog all  - all of the above plus more
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
