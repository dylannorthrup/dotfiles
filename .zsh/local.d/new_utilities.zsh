#!/usr/bin/zsh
# shellcheck shell=bash
# Replacements for older tools from https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/

_configNewUtils() {
  # List of software I tried and binned
  # bat - Installed 28 Apr 2023; removed 10 Jan 2024
  # difftastic - Installed on 23 Aug 2022; removed 11 Jan 2024

  # Adding my local gobin dir to the path
  PATH=$PATH:${HOME}/go/bin

  ## eza : github.com/eza-community/eza
  # Installed 15 Apr; updated from 'exa' to 'eza' on 5 Mar 2024
  alias ls='eza --git --no-quotes -a -g'
  alias tree='ls --tree'
  export EZA_CONFIG_DIR="${HOME}/.config/eza"

  ## hyperfine : github.com/sharkdp/hyperfine
  # On 28 Apr, also installed `delta`, but removed it since I didn't like it that much
  # Installed hyperfine benchmarking tool on 29 Apr
  alias hf='hyperfine'

  ## gping : github.com/orf/gping
  alias ping="echo '${RED}=== You could be using gping ===${NOFMT}'; echo ''; \\ping"
  alias gping='gping -4'
  alias gps='gping -s'

  ## ripgrep : github.com/BurntSushi/ripgrep
  # Set config path for `rg`
  export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"
  alias crg='clear; rg'
  alias egrep='rg --color always'
  alias grep='rg'
  alias nceg='rg --color=never'
  # Something to use to get to regular 'grep'
  function _grep() {
    /usr/bin/grep "$@"
  }
  alias ncpg='_grep -P --color=never'
  alias pcgrep='_grep -P --color=always'

  # A golang replacement for watch
  alias viddy='viddy --pty'
  alias watch='viddy -d'

  # resto : github.com/abdfnx/resto
  # Reminder to try using `resto`
  function _curl() {
    msg "${RED}You could be using 'resto' for this HTTP call.${NOFMT}"
    curl "$@"
  }
  alias curl='_curl'

  ## fd : github.com/sharkdp/fd
  # Convenience fd function to turn off color
  alias ncfd='fd --color=never'

  ## chezmoi : chezmoi.io
  alias cm='chezmoi'
  alias cmg='chezmoi git'
  alias cma='chezmoi add'
  function cmvd() {
    fname="${1}"
    cmFname="${fname/./dot_}"
    vimdiff "${HOME}/$1" "${HOME}/.local/share/chezmoi/${cmFname}"
  }

  ## atuin : github.com/atuinsh/atuin
  #eval "$(atuin init zsh)"

  # asdf: https://github.com/asdf-vm/asdf
  . "${HOME}/.asdf/asdf.sh"
  alias apm='asdf-plugin-manager'
  function aigl() {
    asdf install "${1}" latest
    asdf global "${1}" latest
    asdf reshim "${1}"
  }

  # ddgr is a python-based CLI for duckduckgo
  function ddg() {
    clear
    ddgr --np "$@"
  }
}

# Skip if we are inside a docker container on a mac
[[ "$(uname -s)" != "Darwin" && -f /.dockerenv ]] && return
_configNewUtils
