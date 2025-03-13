#!/usr/bin/zsh
# shellcheck shell=bash
#
# Ruby functions/aliases

runRbLoop() {
  _loopDelay=3
  while true; do
    fd '(.*.rb|run.sh)' . | entr -c -p ./run.sh
    echo "Restarting in ${_loopDelay} seconds"
    countdown ${_loopDelay}
  done
}
