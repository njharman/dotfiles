# .bash_profile is run for login shells.
# .bashrc is run for new (non-login) shells, /bin/bash/, programs shelling out, etc.
# osX Terminal.app runs .bash_profile for every new terminal window.
if [ -f ~/.bashrc ]; then
   . ~/.bashrc
fi
