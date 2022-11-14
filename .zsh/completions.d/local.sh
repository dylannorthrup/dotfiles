compctl -W $GOPATH/src -/ grun
compctl -W $GOPATH/src -/ vigo

function cdr() { cd $HOME/repos/$1; }
compctl -W $HOME/repos/ -/ cdr
function cds() { cd $HOME/repos/$1; }
compctl -W $HOME/repos/ -/ cds
function cdu() { cd ${UTIL_REPO_PATH}/$1; }
compctl -W ${UTIL_REPO_PATH}/ -/ cdu
function cdpu() { cd ${UTIL_REPO_PATH}/$1; }
compctl -W ${UTIL_REPO_PATH}/ -/ cdpu

function cdtt() {cd ${TOCKTIX_PATH}/$1; }
compctl -W ${TOCKTIX_PATH}/ -/ cdtt

bindkey "^[OA" up-history
bindkey "^[OB" down-history


_adr() {
  # Autocomplete only when entering the last term
  if [ ${COMP_CWORD} -eq $((${#COMP_WORDS[@]} - 1)) ]
  then
    COMPREPLY=( $(_adr_autocomplete ${COMP_WORDS[*]} ) )
  fi
}

complete -F _adr -o default adr

autoload -Uz compinit && compinit
