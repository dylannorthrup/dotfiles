#!/usr/bin/zsh
# shellcheck shell=bash
# Installed difftastic on 23 Aug 2022; removed on 1 Feb 2024
alias diff='/usr/bin/diff -W $(( $(tput cols) - 2 ))'

cdiff() {
  diff "$@" | colorize blue "^>.*" red "^<.*"
}
