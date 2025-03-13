#!/usr/bin/zsh
# shellcheck shell=bash
# Handy shell snippets

if [[ "${_zshConvenienceSourced:-FALSE}" == "TRUE" ]]; then
  return
fi
export _zshConvenienceSourced="TRUE"

# Remove ANSI codes from STDIN
function decolor() {
  sed -r "s/[[:cntrl:]]\[([0-9]{1,3};)*[0-9]{1,3}m//g"
}

# Add commas to numbers per US convention
function commafy_num() {
  echo "$*" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

function displaytime() {
  local T=${1}
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( D > 0 )) && printf '%d days ' $D
  (( H > 0 )) && printf '%d hours ' $H
  (( M > 0 )) && printf '%d minutes ' $M
  (( D > 0 || H > 0 || M > 0 )) && printf 'and '
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
    output=$(zsh -l -c "$*" 2>&1)
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

# A way to "forget" history items I'd prefer didn't get persisted (like those with passwords)
# Source: https://unix.stackexchange.com/questions/236094/how-to-remove-the-last-command-or-current-command-for-bonus-from-zsh-history
# Put a space at the start of a command to make sure it doesn't get added to the history.
setopt histignorespace

alias forget=' my_remove_last_history_entry' # Added a space in 'my_remove_last_history_entry' so that zsh forgets the 'forget' command :).

# ZSH's history is different from bash, so here's my fucntion to remove the last item from history.
my_remove_last_history_entry() {
  # This sub-function checks if the argument passed is a number.
  # Thanks to @yabt on stackoverflow for this :).
  is_int() ( return $(test "$@" -eq "$@" > /dev/null 2>&1); )

  # Set history file's location
  history_file="${HOME}/.zsh_history"
  history_temp_file="${history_file}.tmp"
  line_cout=$(wc -l $history_file)

  # Check if the user passed a number,
  # so we can delete x lines from history.
  lines_to_remove=1
  if [ $# -eq 0 ]; then
    # No arguments supplied, so set to one.
    lines_to_remove=1
  else
    # An argument passed. Check if it's a number.
    if $(is_int "${1}"); then
      lines_to_remove="$1"
    else
      echo "Unknown argument passed. Exiting..."
      return
    fi
  fi

  # Make the number negative, since head -n needs to be negative.
  lines_to_remove="-${lines_to_remove}"

  fc -W # write current shell's history to the history file.

  # Get the files contents minus the last entry(head -n -1 does that)
  #cat $history_file | head -n -1 &> $history_temp_file
  cat $history_file | head -n "${lines_to_remove}" &> $history_temp_file
  mv "$history_temp_file" "$history_file"

  fc -R # read history file.
}

webm2gif() {
  if [[ -z "${1}" || -z "${2}" ]]; then
    2>&1 echo "ERROR: Did not get two arguments. An input and output file are required."
    2>&1 echo "Usage: webm2gif <input.webm> <output.gif>"
    return
  fi
  if [[ ! -f "${1}" ]]; then
    2>&1 echo "ERROR: Could not find input file: '${1}'. Exiting"
    return
  fi
  ffmpeg -i "${1}" -pix_fmt rgb24 "${2}"
}

hd() {
  hexdump -C "$@" | less -X
}

hdc() {
  hexdump -f "${HOME}/.config/hexdump/C24.fmt" "$@" | less -X
}

hdb() {
  hexdump -f "${HOME}/.config/hexdump/b.fmt" "$@" | less -X
}

hdw() {
  hexdump -f "${HOME}/.config/hexdump/wide.fmt" "$@" | less -X
}
