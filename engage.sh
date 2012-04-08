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



## Clone repo if it doesn't exist.  Otherwise, leave it to user to pull/update.
if [ ! -d "$WORK" ]; then
  mkdir "$WORK"
  git clone "$REPO" $WORK
fi

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
chmod 700 ~/tmp
mkdir -p ~/work
