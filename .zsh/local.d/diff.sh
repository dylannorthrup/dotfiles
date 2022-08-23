# Installed difftastic on 23 Aug 2022
_ndiff() {
  msg "${RED}Using difftastic. To use plain diff, run 'odiff'"
  difft "$@"
}
alias diff="_ndiff"
alias odiff="/usr/bin/diff -W $(( $(tput cols) - 2 ))"

cdiff() {
  odiff "$@" | colorize blue "^>.*" red "^<.*"
}
