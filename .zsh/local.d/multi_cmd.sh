#!/usr/bin/zsh
# shellcheck shell=bash
# Example of a 1, few, many alias setup in zsh
# Assumes a setup with hosts named 'server-ENVIRONMENT-NUMBER'
__base_cmd() {
  # What this was, before shellcheck schooled me
  # NODE=$(echo "${funcstack[3]}" | sed -e 's/^...//')
  fstack="${funcstack[3]:?}"
  NODE="${fstack/#???/}"
  if [[ "${NODE}X" == "X" ]]; then # This is to be run against all servers
    example_cmd -h server-"${CMDENV}"-0:8989,server-"${CMDENV}"-1:8989,server-"${CMDENV}"-2:8989 "$*"
  else
    example_cmd -h server-"${CMDENV}"-"${NODE}":8989 "$*"
  fi
}

_base_cmd_prod() {
  CMDENV='prod'
  __base_cmd "$@"
}
bcp0() { _base_cmd_prod "$@"; }
bcp1() { _base_cmd_prod "$@"; }
bcp2() { _base_cmd_prod "$@"; }
bcp() { _base_cmd_prod "$@"; }

_base_cmd_test() {
  CMDENV='test'
  __base_cmd "$@"
}
bct0() { _base_cmd_test "$@"; }
bct1() { _base_cmd_test "$@"; }
bct2() { _base_cmd_test "$@"; }
bct() { _base_cmd_test "$@"; }
