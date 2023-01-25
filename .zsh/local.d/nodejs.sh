#!/usr/bin/zsh
# shellcheck shell=bash
# Node aliases and functions

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=${PATH}:${HOME}/.yarn/bin
