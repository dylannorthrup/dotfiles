compctl -W $GOPATH/src -/ grun
compctl -W $GOPATH/src -/ vigo

function cdr() { cd $HOME/repos/$1; }
compctl -W $HOME/repos/ -/ cdr
function cds() { cd $HOME/repos/$1; }
compctl -W $HOME/repos/ -/ cds
function cdu() { cd ${UTIL_REPO_PATH}/$1; }
compctl -W ${UTIL_REPO_PATH}/ -/ cdu

function cdtt() {cd ${TOCKTIX_PATH}/$1; }
compctl -W ${TOCKTIX_PATH}/ -/ cdtt

bindkey "^[OA" up-history
bindkey "^[OB" down-history
