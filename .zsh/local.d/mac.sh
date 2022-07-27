# Mac/laptop specific aliases/config should go here

# If this isn't a mac, you shouldn't be here (mostly
# because this will be useless for you)
if [[ ${UNAME_KERNEL} != "Darwin" ]]; then
  return
fi

# Aliases to binaries inside installed apps
alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# Homebrew OpenSSL 3 stuff
export PATH=/usr/local/opt/openssl@3/bin:${PATH}
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"

# C# DotNet path addition
export PATH=${PATH}:/Library/Frameworks/Mono.framework/Versions/Current/bin

plugins=(${plugins} brew macos)
