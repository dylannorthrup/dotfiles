# ~/.profile: executed by the command interpreter for login shells.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export SHELL=/usr/bin/zsh
[ -z "$ZSH_VERSION" ] && exec /usr/bin/zsh -l

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
