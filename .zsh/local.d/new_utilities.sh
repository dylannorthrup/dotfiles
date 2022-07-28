# Replacements for older tools from https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
# Installed 15 Apr
alias ls='exa --git'
alias tree='ls --tree'

# Installed 28 Apr
local bat_options='--theme zenburn --tabs 2'
cat() {
  if [[ ${1} == "-p" ]]; then
    bat ${bat_options} "$@"
  else
    msg "${RED}Use \"cat -p\" for plain output.${NOFMT}"
    bat ${bat_options} "$@"
  fi
}

# On 28 Apr, also installed `delta`, but removed it since I didn't like it that much
# Installed hyperfine benchmarking tool on 29 Apr
alias hf='hyperfine'

## gping : github.com/orf/gping
alias ping="echo '${RED}=== You could be using gping ===${NOFMT}'; echo ''; \ping"
alias gping='gping -s'

## ripgrep
# Set config path for `rg`
export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"
alias crg='clear; rg'
alias egrep='rg --color always'
alias grep='rg'
alias nceg='rg --color=never'
# Something to use to get to regular 'grep'
_grep() {
  /usr/bin/grep "$@"
}
alias ncpg='_grep -P --color=never'
alias pgrep='_grep -P --color=always'

# A golang replacement for watch
alias watch='viddy -d -color'

# Installed 28 Jul (after seeing in gh extension)
# Reminder to try using `resto`
_curl() {
    msg "${RED}You could be using 'resto' for this HTTP call.${NOFMT}"
  curl "$@"
}
alias curl='_curl'
