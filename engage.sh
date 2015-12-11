#!/bin/bash
# Symlink dotfiles, yo!

REPO="https://github.com/njharman/dotfiles.git"
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
  ## If missing, setup .dotfiles and clone repo. Otherwise leave it to user to pull/update.
  if [ ! -d "$WORK" ]; then
    mkdir -p "$WORK"
    git config --global user.name "Norman J. Harman Jr."
    git config --global user.email njharman@gmail.com
    # Cause git pull is broke or some shit: http://stackoverflow.com/questions/15316601/is-git-pull-the-least-problematic-way-of-updating-a-git-repository
    git config --global alias.up '!git remote update -p; git merge --ff-only @{u}'
    # Old systems don't got the CA
    #git config --global http.sslVerify false
    git clone "$REPO" $WORK
    cd $WORK
    # Tells git-branch and git-checkout to setup new branches so that
    # git-pull(1) will appropriately merge from that remote branch.
    # Recommended.  Without this, you will have to add --track to your branch
    # command or manually merge remote tracking branches with "fetch" and then
    # "merge".
    git config branch.autosetupmerge true
    # Convert newlines to the system's standard when checking out files, and to LF newlines when committing in.
    git config core.autocrlf false
    git config core.filemode true
    # Update submodules
    #git submodule init
    #git submodule update
  fi
  }


function ubuntu_install {
  # Install the one time things for Ubuntu.
  echo Basics
  sudo apt-get -y install build-essential aptitude
  sudo apt-get -y install zsh tmux git vim meld tree

  echo Silver Searcher
  sudo apt-get -y --force-yes install automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
  cd ~/tmp/
  rm -rf the_silver_searcher
  git clone https://github.com/ggreer/the_silver_searcher
  cd the_silver_searcher
  ./build.sh
  mv ag ~/bin/
  cd ~

  echo  Python needfulls
  sudo apt-get -y install python-pip
  sudo -H pip install -U vex virtualenv pip
  sudo -H pip install -U tox nose nosecomplete pep8 pep8-naming flake8 pyflakes coverage cprofilev isort
  sudo apt-get -y install python-dev
  sudo -H pip install -U ipython memory_profiler line_profiler

  echo command line tools
  sudo -H pip install -U percol

  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo Vundle for Vim
    mkdir -f ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
  }


function engage_sym {
  # Make directories, link dotfiles.

  ## ~/bin
  mkdir -p ~/bin
  chmod 700 ~/bin
  symtastico ~/bin `ls -d "$WORK"/bin/*`

  ## ~/tmp ~/work
  mkdir -p ~/tmp
  mkdir -p ~/work
  mkdir -p ~/.backup  # vim undo and backups
  chmod 700 ~/tmp ~/work ~/.backup

  ## .dotfiles
  symtastico ~ `ls -ad "$WORK"/\.*`

  ## ~/.config
  mkdir -p ~/.config
  symtastico ~/.config "$WORK/.config/*"

  ## ~/.ssh
  # Just dirs & permissions. Don't want actual config in github.
  mkdir -p ~/.ssh/cm_socket/
  chmod -f 700 ~/.ssh ~/.ssh/cm_socket/
  chmod -f 600 ~/.ssh/authorized_keys
  chown -fR $USER ~/.ssh

  ## ~/.keys
  chmod -f 600 ~/.keys/*
  chown -fR $USER ~/.keys

  ## ~/.vim  (vundle & bundles, pretty colors)
  mkdir -p ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  chmod 700 ~/.vim ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  symtastico ~/.vim/colors `ls -d "$WORK"/.vim/colors/*`

  ## ~/.ipython
  # ipython profile create
  mkdir -p ~/.ipython/extensions ~/.ipython/profile_default
  chmod 700 ~/.ipython ~/.ipython/extensions ~/.ipython/profile_default
  symtastico ~/.ipython/profile_default "$WORK/.ipython/profile_default/ipython_config.py"
  symtastico ~/.ipython/extensions "$WORK/.ipython/extensions/*"

#  ## ~/.subversion
#  mkdir -p ~/.subversion
#  chmod 700 ~/.subversion
#  chmod -Rf o-rw ~/.subversion/auth/*
#  chown -fR $USER ~/.subversion
#  symtastico ~/.subversion `ls -d "$WORK"/.subversion/*`

  }


function engage_up {
  # Update repo.
  cd $WORK
  git pull
  }


function engage_vim {
  # Update vim plugins.
  cd ~/.vim/bundle/Vundle.vim
  git merge
  cd -
  vim +PluginUpdate +qall
#  cd $WORK
#  git submodule init
#  git submodule update
#  git submodule foreach git pull origin master
  }


init_the_dotfiles

if [[ "$1" == "help" ]]; then
  prog=`basename $0`
  cat <<USAGE
$prog      - (re)create symbolic links, directories, etc.
$prog up   - git pull
$prog vim  - vim
$prog all  - all of the above plus more
USAGE
elif [[ "$1" == "ubuntu" ]]; then
  ubuntu_install
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
