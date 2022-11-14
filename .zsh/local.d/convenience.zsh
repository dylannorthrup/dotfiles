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
      -qr $i dotfiles/$i |\
    grep -E -v '(tock|dynamic_repo_paths)'
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

# Lets you apply grep, sort, etc to the body of a program's output
# but not modify the first line. Eg. `ps -fade | grep foo` will
# give you the grep'd lines, but also the header with the column names
# NOTE: this doesn't always work and having a better way would be good!
function body() {
  IFS= read -r header
  printf '%s\n' "$header"
  "$@"
}

# Some aliases for less typing
alias bsort="body sort"
alias bgrep="body grep"
alias bhead="body head"
alias btail="body tail"
# A more verbose way to sleep
function _countdown() {
  NUM=$*
  while [ $NUM -gt 0 ]; do
    # Clear from the cursor to the end of the line
    tput el
    echo -n "${NUM} "
    # Move the cursor back the number of digits in NUM.
    for i in $(seq 0 "${#NUM}"); do echo -ne '\b'; done
    # Had to add the '|| true' bit in the subshell because it was causing a false positive for 'set -e'
    NUM=$(expr $NUM - 1 || true)
    sleep 1
  done
  tput cr
  if [[ ${SUPPRESS_COUNTDOWN_DONE:-0} == 0 ]]; then
    echo -n "0 . . . done!"
  else
    echo -n "0"
  fi
}

alias countdown="_countdown"
alias cdn="SUPPRESS_COUNTDOWN_DONE=1 _countdown"

clock() {
  DELAY="$*"
  if [ -z $DELAY ]; then
    DELAY="5"
  fi
  while true; do date | tr '\r\n' ' '; sleep ${DELAY}; echo -ne "\r"; done
}

function not-watch() {
  export COLOR_SETTING='ALWAYS'
  while true; do
    echo "Running command"
    output=$(eval "$*" 2>&1)
    clear
    uptime | colorize blue '.*'
    echo -e "COMMAND: '$*'"
    echo -e "=="
    echo -e "${output}"
    echo -e "=="
    countdown ${NW_DELAY:-5}
  done
}

alias nw='not-watch'
alias nw20='NW_DELAY=20 not-watch'

# A less distracting way to countdown
dot_countdown() {
  NUM=$*
  while [ $NUM -gt 0 ]; do
    # Print spaces to clear previous line
    printf %${NUM}s
    # Move cursor to beginning of line
    echo -ne "\r"
    # Had to add the '|| true' bit in the subshell because it was causing a false positive for 'set -e'
    NUM=$(expr $NUM - 1 || true)
    # Print new number of dots
    printf %${NUM}s |tr " " "."
    # Move cursor to beginning of line
    echo -ne "\r"
    sleep 1
  done
}
