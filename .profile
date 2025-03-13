# ~/.profile: executed by the command interpreter for login shells.

>&2 echo ".profile: begin sourcing."

# Prevent circular imports
if [[ -n "${dotProfileImported}" ]]; then
    >&2 echo ".profile: Already imported. Returning."
  return
fi
export dotProfileImported="true"

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [[ $- =~ i && -z "$ZSH_VERSION" ]]; then
  if [[ -x /usr/bin/zsh ]]; then
    export SHELL=/usr/bin/zsh
    echo "Exec'ing /usr/bin/zsh -l"
    exec /usr/bin/zsh -l
  elif [[ -x /bin/zsh ]]; then
    export SHELL=/bin/zsh
    echo "Exec'ing /bin/zsh -l"
    exec /bin/zsh -l
  fi
fi

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
    PATH="$HOME/bin:$PATH"
fi
