# Handy shell snippets

# Do a diff of what's on the box and what our `dotfiles` directory says
function dotdiff() {
  cd ${HOME}
  for i in $(grep -v '^#' dotfiles/dotdiff.files); do
    echo "== $i" | colorize cyan '.*'
    # Use '# dotdiffignore$' to flag sections we know are different
    # And explicitly exclude ephemeral files that won't be in git
    /usr/bin/diff -I '# dotdiffignore$' \
      -x "kubectl.completion"           \
      -x "tock"                         \
      -x ".*.swp"                       \
      -qr $i dotfiles/$i
  done
}

function commafy_num() {
  echo "$*" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

function displaytime() {
  local T=$(printf -v int %.0f "$1")
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%d days ' $D
  (( $H > 0 )) && printf '%d hours ' $H
  (( $M > 0 )) && printf '%d minutes ' $M
  (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
  printf '%d seconds\n' $S
}

