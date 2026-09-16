#!/bin/bash
# Symlink dotfiles, yo!
#
# Three cumulative tiers:
#   basic   sysadmin-ready on any box: shell, readline, git, sag/g, working vim
#   vim     basic must already be done; updates the vim plugins
#   full    basic + vim + the dev/desktop extras
set -u

REPO="https://github.com/njharman/dotfiles.git"
WORK=~/.dotfiles
SAVE=~/tmp/.dotfile_preserve/$(date +%Y%m%d-%H%M%S)
BASHRC_HOOK='[[ -f ~/.bashrc_base ]] && source ~/.bashrc_base'
VUNDLE=~/.vim/bundle/Vundle.vim

DRYRUN=
NOPACKAGES=

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
  # don't clobber each other in the archive.
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
  # Leave it alone when dest already IS src. A dest reached through a symlinked
  # parent directory resolves to the repo's own file, and archiving that moves
  # the file out of the repo and leaves a dangling link where it used to be.
  if [ -e "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
    say "  $dest (already linked)"
    return
  fi
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
  # destdir and symlinks every file in it.
  local srcdir=$1 destdir=$2 f rel
  while IFS= read -r f; do
    rel=${f#"$srcdir"/}
    link_file "$f" "$destdir/$rel"
  done < <(find "$srcdir" -type f)
  }


function link_os_bashrc {
  # Link only this machine's OS layer, as ~/.bashrc_os, so .bashrc_base has a
  # single fixed name to source. Linking both and choosing at runtime just
  # litters ~ with a file that will never be read on this box.
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


function install_basic {
  [ -n "$NOPACKAGES" ] && { say "Packages (skipped)"; return; }
  say "Packages"
  case "$(detect_os)" in
    omarchy)
      # git vim rg fd bat fzf eza are all in a stock Omarchy install.
      say "  nothing to do, Omarchy ships everything basic needs"
      ;;
    ubuntu)
      run sudo apt -y install git vim wget bash-completion ripgrep fd-find bat fzf
      # Ubuntu names fd as fdfind and bat as batcat, and has no eza in the LTS
      # archive -- see the notes in .bashrc_ubuntu.
      ;;
    *) say "  unknown OS, skipping package install";;
  esac
  }


function install_full {
  [ -n "$NOPACKAGES" ] && { say "Packages (skipped)"; return; }
  say "Packages"
  case "$(detect_os)" in
    omarchy) run omarchy pkg add pre-commit ruff;;
    ubuntu)  run sudo apt -y install build-essential python3-pip pre-commit;;
    *)       say "  unknown OS, skipping package install";;
  esac
  }


function basic_done {
  # Cheap proxy for "engage.sh basic has been run here".
  [ -h ~/.bashrc_os ] && [ -h ~/.vimrc ] && [ -d "$VUNDLE" ]
  }


function engage_basic {
  local os
  os=$(detect_os)
  say "Detected OS: $os"

  install_basic

  ## Directories
  run mkdir -p ~/.local/bin ~/tmp ~/Work ~/.backup  # .backup is vim undo and backups
  run chmod 700 ~/.local/bin ~/tmp ~/Work ~/.backup

  ## ~/.local/bin -- just the search pair and memuse; the rest is `full`.
  say "~/.local/bin"
  link_file "$WORK/bin/sag" ~/.local/bin/sag
  link_file "$WORK/bin/memuse" ~/.local/bin/memuse

  ## Shell and readline
  say "~"
  link_file "$WORK/.inputrc" ~/.inputrc
  link_file "$WORK/.sagrc" ~/.sagrc
  link_file "$WORK/.bashrc_base" ~/.bashrc_base
  link_os_bashrc "$os"
  link_file "$WORK/.screenrc" ~/.screenrc
  link_file "$WORK/.psqlrc" ~/.psqlrc

  ## ~/.bashrc gets a source line, never a symlink.
  say "~/.bashrc"
  hook_bashrc

  ## git
  say "git"
  link_file "$WORK/.gitconfig" ~/.gitconfig
  retire_xdg_gitconfig
  link_tree "$WORK/config/git" ~/.config/git

  ## ~/.ssh and ~/.keys (contents are not tracked; this is permission hygiene)
  say "permissions"
  run mkdir -p ~/.ssh/cm_socket/
  run chmod -f 700 ~/.ssh ~/.ssh/cm_socket/
  run chmod -f 600 ~/.ssh/authorized_keys ~/.ssh/config
  run chmod -f 600 ~/.ssh/*pub ~/.ssh/*pem ~/.ssh/*rsa
  run chown -fR "$USER" ~/.ssh
  run chmod -f 600 ~/.keys/*
  run chown -fR "$USER" ~/.keys

  ## vim: config and colors now, plugins next.
  say "~/.vim"
  run mkdir -p ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  run chmod 700 ~/.vim ~/.vim/bundle ~/.vim/colors ~/.vim/spell
  link_file "$WORK/.vimrc" ~/.vimrc
  link_dir_contents "$WORK/.vim/colors" ~/.vim/colors
  vundle_bootstrap
  }


function vundle_bootstrap {
  # .vimrc calls vundle#begin() unconditionally, so a box with .vimrc but no
  # Vundle throws E117/E492 on every start. basic installs it for that reason.
  if [ ! -d "$VUNDLE" ]; then
    say "Vundle for Vim"
    run git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE"
  fi
  if [ -z "$DRYRUN" ] && [ ! -d "$VUNDLE" ]; then
    say "Failed to find / install Vundle"
    exit 1
  fi
  say "vim plugins"
  run vim +PluginInstall +qall
  }


function engage_vim {
  # Plugin update only -- everything it needs comes from basic.
  say "vim plugins"
  run git -C "$VUNDLE" pull
  run vim +PluginUpdate +qall
  }


function engage_full {
  engage_basic
  engage_vim

  install_full

  ## The rest of ~/.local/bin
  say "~/.local/bin"
  link_file "$WORK/bin/code" ~/.local/bin/code
  link_file "$WORK/bin/mysum" ~/.local/bin/mysum
  link_file "$WORK/bin/256colors.py" ~/.local/bin/256colors.py

  ## Git init template. hooks/pre-commit needs the pre-commit package.
  say "~/.git-template"
  link_file "$WORK/.git-template/hooks/pre-commit" ~/.git-template/hooks/pre-commit
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


function usage {
  local prog
  prog=$(basename "$0")
  cat <<USAGE
$prog basic         - shell, readline, git, sag/g, working vim. Everywhere.
$prog vim           - update vim plugins. Needs 'basic' to have been run.
$prog full          - basic, vim, then the dev extras.
$prog help          - this

Options:
  --dry-run        - print what would change, touch nothing
  --no-packages    - skip the OS package install
USAGE
  }


while [[ "${1:-}" == --* ]]; do
  case "$1" in
    --dry-run)     DRYRUN=1; say "DRY RUN - nothing will be changed.";;
    --no-packages) NOPACKAGES=1;;
    --help)        usage; exit 0;;
    *)             say "Unknown option: $1"; usage; exit 1;;
  esac
  shift
done

case "${1:-}" in
  help|-h)
    usage
    ;;
  basic)
    init_the_dotfiles
    engage_basic
    ;;
  vim)
    # Checked before init_the_dotfiles: this tier only touches ~/.vim, so
    # there is no reason to clone the repo just to refuse.
    if ! basic_done; then
      say "Run '$(basename "$0") basic' first: vim only updates plugins."
      exit 1
    fi
    engage_vim
    ;;
  full)
    init_the_dotfiles
    engage_full
    ;;
  "")
    usage
    exit 1
    ;;
  *)
    say "Unknown command: $1"
    usage
    exit 1
    ;;
esac
