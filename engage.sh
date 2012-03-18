#!/bin/bash
# Symlink some dotfiles, yo!

REPO="git://github.com/njharman/dotfiles.git"
WORK=~/.dotfiles
ORIG=~/tmp/.dotfile_preserve

function symtastico {
  # make symlinks, ignoring directories and archiving existing files.
  destdir=$1
  shift
  for file in $@; do
    if [ -f "$file" ]; then
       name=`basename "$file"`
       dest=$destdir/$name
       echo -n "$name, "
       if [ -h $dest ]; then
         echo -n "re-"
         rm $dest
       elif [ -e $dest ]; then
         echo -n "moving existing file to $ORIG/, "
         mkdir -p "$ORIG"
         mv $dest "$ORIG/"
       fi
       ln -s $file $dest
       echo "symlinked."
    fi
  done
  }


## Clone repo if it doesn't exist.  Otherwise, leave it to user to pull/update.
if [ ! -d "$WORK" ]; then
  mkdir "$WORK"
  git clone "$REPO" $WORK
fi

## .dotfiles
symtastico ~ `ls -ad "$WORK"/\.*`

## ~/.vim  (only some stuff)
mkdir -p ~/.vim/ftplugin ~/.vim/colors
symtastico ~/.vim/ftplugin/ `ls -d "$WORK"/.vim/ftplugin/*`
symtastico ~/.vim/colors/ `ls -d "$WORK"/.vim/colors/*`

## ~/.ssh
# Just dir/permissions.  Don't wanna autolink config...
mkdir -p ~/.ssh
chmod 700 ~/.ssh
chmod -f 600 ~/.authorized_keys
chown -R $USER:$USER ~/.ssh

## ~/bin
mkdir -p ~/bin
chmod 700 ~/bin
symtastico ~/bin `ls -d "$WORK"/bin/*`

## ~/tmp ~/work
mkdir -p ~/tmp
mkdir -p ~/work
