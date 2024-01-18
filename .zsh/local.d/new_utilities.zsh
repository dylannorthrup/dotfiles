#!/usr/bin/zsh
# shellcheck shell=bash
# Replacements for older tools from https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/

# List of software I tried and binned
# bat - Installed 28 Apr 2023; removed 10 Jan 2024
# difftastic - Installed on 23 Aug 2022; removed 11 Jan 2024

# Adding my local gobin dir to the path
PATH=$PATH:${HOME}/go/bin
# Installed 15 Apr
alias ls='exa --git'
alias tree='ls --tree'

## hyperfine : github.com/sharkdp/hyperfine
# On 28 Apr, also installed `delta`, but removed it since I didn't like it that much
# Installed hyperfine benchmarking tool on 29 Apr
alias hf='hyperfine'

## gping : github.com/orf/gping
alias ping="echo '${RED}=== You could be using gping ===${NOFMT}'; echo ''; \ping"
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
