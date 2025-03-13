#!/usr/bin/zsh
# shellcheck shell=bash
# Useful bits for programming in go

if [[ "${_zshGolangSourced:-FALSE}" == "TRUE" ]]; then
  return
fi
export _zshGolangSourced="TRUE"

lib_dir="${HOME}/.zsh/local.d"

source "${lib_dir}/convenience.zsh"

export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export PATH="${PATH}:${GOBIN}"
# For asdf-managed golang installs
export ASDF_GOLANG_MOD_VERSION_ENABLED=true

runGoLoop() {
  _loopDelay=3
  while true; do
    fd '(go.*|.*.go|run.sh)' . | entr -c -p ./run.sh
    echo "Restarting in ${_loopDelay} seconds"
    countdown ${_loopDelay}
  done
}
