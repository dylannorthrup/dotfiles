#!/usr/bin/zsh
# shellcheck shell=bash
# Mac/laptop specific aliases/config should go here

# If this isn't a mac, you shouldn't be here (mostly
# because this will be useless for you)
if [[ ${UNAME_KERNEL} != "Darwin" ]]; then
  return
fi

# Aliases to binaries inside installed apps
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# Homebrew OpenSSL 3 stuff
export PATH=/usr/local/opt/openssl@3/bin:${PATH}
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"

# Mac specific python path
local _pythonVersion=$(python3 -V | sed -e 's/Python *//; s/\.[0-9]*$//;')
export PATH="${PATH}":"${HOME}/Library/Python/${_pythonVersion}/bin"

# Hammerspoon aliases and functions
addSpoon() {
  local _pwd=$(pwd)
  spoonDir="${HOME}/.hammerspoon/Spoons/"
  if [[ ! -d "${spoonDir}" ]]; then
    echo "Could not find default spoon directory: '${spoonDir}'."
    return
  fi
  cd "${spoonDir}"
  wget -nv --progress=dot:binary -O "${1}.spoon.zip" "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/${1}.spoon.zip"
  cd "${_pwd}"
}

# C# DotNet path addition
export PATH=${PATH}:/Library/Frameworks/Mono.framework/Versions/Current/bin

plugins=("${plugins}" brew macos)

alias listeningPorts='sudo lsof -iTCP -sTCP:LISTEN -iUDP -n -P'
