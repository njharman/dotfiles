#!/bin/bash
# Symlink dotfiles, yo!
set -u

REPO="https://github.com/njharman/dotfiles.git"
WORK=~/.dotfiles
SAVE=~/tmp/.dotfile_preserve/$(date +%Y%m%d-%H%M%S)
BASHRC_HOOK='[[ -f ~/.bashrc_base ]] && source ~/.bashrc_base'

DRYRUN=

# Repo root files the generic ~ loop must not touch: either they aren't dotfiles
# for ~ at all, or they're linked by hand further down under a different name.
SKIP_IN_HOME=".gitignore .gitmodules .bashrc_omarchy .bashrc_ubuntu"

# The per-OS bash layers. Only the one matching this machine gets linked, as
# ~/.bashrc_os; the rest have no business in ~.
OS_BASHRCS="omarchy ubuntu"


function say { echo "$@"; }
function run { if [ -n "$DRYRUN" ]; then echo "  would: $*"; else "$@"; fi; }


function detect_os {
  # omarchy | ubuntu | unknown
  if command -v omarchy >/dev/null 2>&1; then
    echo omarchy
  elif [ -r /etc/os-release ] && grep -qiE '^ID(_LIKE)?=.*(ubuntu|debian)' /etc/os-release; then
    echo ubuntu
  else
    echo unknown
  fi
  }


function archive {
  # Move an existing file out of the way, preserving it under a timestamped dir.
  # Path relative to ~ is kept, so same-named files from different directories
  # (say two autostart.lua) don't clobber each other in the archive.
  local dest=$1 rel
  rel=${dest#"$HOME"/}
  run mkdir -p "$SAVE/$(dirname "$rel")"
  run mv "$dest" "$SAVE/$rel"
  say "    archived existing to $SAVE/$rel"
  }


function link_file {
  # link_file <source> <dest>. Replaces our own symlinks, archives real files.
  local src=$1 dest=$2
  [ -f "$src" ] || { say "  no such file $src"; return; }
  run mkdir -p "$(dirname "$dest")"
  if [ -h "$dest" ]; then
    run rm "$dest"
  elif [ -e "$dest" ]; then
    archive "$dest"
  fi
  run ln -s "$src" "$dest"
  say "  $dest"
  }


function link_dir_contents {
  # link_dir_contents <srcdir> <destdir>. Flat: files only, no recursion.
  local srcdir=$1 destdir=$2 f
  for f in "$srcdir"/*; do
    [ -f "$f" ] || continue
    link_file "$f" "$destdir/$(basename "$f")"
  done
  }


function link_tree {
  # link_tree <srcdir> <destdir>. Recreates the directory structure under
  # destdir and symlinks every file in it. Used for ~/.config trees.
  local srcdir=$1 destdir=$2 f rel
  while IFS= read -r f; do
    rel=${f#"$srcdir"/}
    link_file "$f" "$destdir/$rel"
  done < <(find "$srcdir" -type f)
  }


function link_os_bashrc {
  # Link only this machine's OS layer, as ~/.bashrc_os, so .bashrc_base has a
  # single fixed name to source. Linking all three and choosing at runtime just
  # litters ~ with files that will never be read on this box.
  local os=$1 other
  # Clear any per-OS links a previous version of this script left behind.
  for other in $OS_BASHRCS; do
    if [ -h ~/.bashrc_"$other" ]; then
      say "  removing stale ~/.bashrc_$other"
      run rm ~/.bashrc_"$other"
    fi
  done

  if [ -f "$WORK/.bashrc_$os" ]; then
    link_file "$WORK/.bashrc_$os" ~/.bashrc_os
  else
    say "  no OS layer for '$os', skipping ~/.bashrc_os"
    [ -h ~/.bashrc_os ] && run rm ~/.bashrc_os
  fi
  }


function hook_bashrc {
  # Append our source line to whatever ~/.bashrc the OS provides. We do NOT
  # symlink over ~/.bashrc: on Omarchy it is the bootstrap that sources
  # $OMARCHY_PATH/default/bash/rc, and replacing it would throw away every
  # default we are trying to layer on top of. Idempotent.
  if [ -f ~/.bashrc ] && grep -qF 'bashrc_base' ~/.bashrc; then
    say "  ~/.bashrc already sources .bashrc_base"
    return
  fi
  say "  appending .bashrc_base hook to ~/.bashrc"
  if [ -z "$DRYRUN" ]; then
    printf '\n# Personal dotfiles (github.com/njharman/dotfiles)\n%s\n' "$BASHRC_HOOK" >> ~/.bashrc
  else
    say "  would: append '$BASHRC_HOOK' to ~/.bashrc"
  fi
  }


function retire_xdg_gitconfig {
  # Omarchy ships ~/.config/git/config. Git reads it AND ~/.gitconfig, with
  # ~/.gitconfig winning -- two global configs silently disagreeing. Keep one.
  local xdg=~/.config/git/config
  if [ -f "$xdg" ] && [ ! -h "$xdg" ]; then
    say "  retiring $xdg (superseded by ~/.gitconfig)"
    archive "$xdg"
  fi
  }


function omarchy_install {
  say "Packages"
  # Already present in a stock Omarchy install: rg fd eza bat fzf zoxide
  # starship mise vim. Not installed here on purpose: tmux (moving to herdr),
  # tree (Omarchy's `lt` is eza's tree view), uv (installed by hand for now).
  run omarchy pkg add pre-commit ruff
  }


function ubuntu_install {
  say "Packages"
  run sudo apt -y install build-essential
  run sudo apt -y install git vim tree wget bash-completion ripgrep fd-find bat fzf
  run sudo apt -y install python3-pip pre-commit
  # eza is not in the 24.04 LTS archive; see the note in .bashrc_ubuntu.
  }


function init_the_dotfiles {
  ## If missing, setup .dotfiles and clone repo. Otherwise leave it to user to pull/update.
  if [ ! -d "$WORK" ]; then
    mkdir -p "$WORK"
    git config --global user.name "Norman J. Harman Jr."
    git config --global user.email njharman@gmail.com
    git clone "$REPO" "$WORK"
    cd "$WORK" || exit 1
    # Tells git-branch and git-checkout to setup new branches so that git-pull
    # will appropriately merge from that remote branch.
    git config branch.autosetupmerge true
    git config core.autocrlf false
    git config core.filemode true
  fi
  }


function engage_sym {
  local os
  os=$(detect_os)
  say "Detected OS: $os"

  ## ~/.local/bin
  say "~/.local/bin"
  run mkdir -p ~/.local/bin
  run chmod 700 ~/.local/bin
  link_dir_contents "$WORK/bin" ~/.local/bin

  ## Directories
  run mkdir -p ~/tmp ~/Work ~/.backup  # .backup is vim undo and backups
  run chmod 700 ~/tmp ~/Work ~/.backup

  ## Dotfiles in ~
  say "~"
  local f name
  for f in "$WORK"/.*; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    case " $SKIP_IN_HOME " in *" $name "*) continue;; esac
    case "$name" in *~|*.swp) continue;; esac
    link_file "$f" ~/"$name"
  done
  link_file "$WORK/.git-template/hooks/pre-commit" ~/.git-template/hooks/pre-commit

  ## The one OS layer this machine actually uses, as ~/.bashrc_os.
  link_os_bashrc "$os"

  ## ~/.bashrc gets a source line, never a symlink.
  say "~/.bashrc"
  hook_bashrc

  ## ~/.config
  say "~/.config"
  retire_xdg_gitconfig
  link_tree "$WORK/config/git" ~/.config/git
  if [ "$os" = omarchy ]; then
    # NOTE: `omarchy refresh hyprland` (and friends) follow these symlinks and
    # write into the repo. That is what we want -- a reset shows up as a git
    # diff instead of silently vanishing -- but it means a refresh is a repo
    # change, not a local one. Check `git status` after running one.
    link_tree "$WORK/config/hypr" ~/.config/hypr
    link_tree "$WORK/config/omarchy" ~/.config/omarchy
    link_file "$WORK/config/starship.toml" ~/.config/starship.toml
  fi

  ## ~/.ssh  (config itself is not tracked; this is just permission hygiene)
  run mkdir -p ~/.ssh/cm_socket/
  run chmod -f 700 ~/.ssh ~/.ssh/cm_socket/
  run chmod -f 600 ~/.ssh/authorized_keys ~/.ssh/config
  run chmod -f 600 ~/.ssh/*pub ~/.ssh/*pem ~/.ssh/*rsa
  run chown -fR "$USER" ~/.ssh

  ## ~/.keys
  run chmod -f 600 ~/.keys/*
  run chown -fR "$USER" ~/.keys

  ## ~/.vim  (vundle & bundles, pretty colors)
  run mkdir -p ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  run chmod 700 ~/.vim ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  link_dir_contents "$WORK/.vim/colors" ~/.vim/colors
  }


function engage_install {
  case "$(detect_os)" in
    omarchy) omarchy_install;;
    ubuntu)  ubuntu_install;;
    *)       say "Unknown OS, skipping package install.";;
  esac
  }


function engage_up {
  cd "$WORK" || exit 1
  git pull
  }


function engage_vim {
  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    say "Vundle for Vim"
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    say "Failed to find / install Vundle"
    exit 1
  fi
  cd ~/.vim/bundle/Vundle.vim || exit 1
  git pull
  cd - >/dev/null || exit 1
  vim +PluginUpdate +qall
  }


function usage {
  local prog
  prog=$(basename "$0")
  cat <<USAGE
$prog              - (re)create symbolic links, directories, etc.
$prog install      - install packages for the detected OS
$prog up           - git pull
$prog vim          - update vim plugins
$prog all          - up, vim, symlinks

Options:
  --dry-run        - print what would change, touch nothing
USAGE
  }


if [[ "${1:-}" == "--dry-run" ]]; then
  DRYRUN=1
  shift
  say "DRY RUN - nothing will be changed."
fi

case "${1:-}" in
  help|--help|-h)
    usage
    ;;
  install)
    init_the_dotfiles
    engage_install
    ;;
  up)
    init_the_dotfiles
    engage_up
    ;;
  vim)
    init_the_dotfiles
    engage_vim
    ;;
  all)
    init_the_dotfiles
    engage_up
    engage_vim
    engage_sym
    ;;
  "")
    init_the_dotfiles
    engage_sym
    ;;
  *)
    say "Unknown command: $1"
    usage
    exit 1
    ;;
esac
