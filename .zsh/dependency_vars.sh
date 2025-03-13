# These are variables or settings that the files under ~/.zsh/local.d depend on.
# I do them here, once, so I don't have to do them elsewhere many times. I can
# also guarantee that this runs before they do.
export UNAME_KERNEL=$(uname -s)

GLOBAL_DEBUG=$(false)

# Helper functions I use elsewhere
# Like `echo -n`, but outputs to STDERR
function msg_n() {
  [[ ${_SILENCE_MSG-} -eq 1 ]] || echo >&2 -n -e "${1-}"
}

# Like `echo`, but outputs to STDERR
function msg() {
  [[ ${_SILENCE_MSG:-0} -eq 1 ]] || msg_n "${1-}\n"
}
# If we want to turn off msg output, set this var
#_SILENCE_MSG=1

# Prints a line, then moves the cursor back to where it was before the line was printed.
function msgStatus() {
  tput sc
  tput el
  msg_n "$@"
  tput rc
}

# msg, but with a time prepended to it
function tmsg() {
  [[ ${_SILENCE_TMSG:-1} -eq 1 ]] || msg_n "$(date): ${1-}\n"
}

# Allow for colorful output
function setup_colors() {
  if [[ -t 2 ]] && [[ ! -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    export PROD_COLORS="$(tput setaf 0; tput setab 9; tput smul)" \
    CLEAR_LINE=$(tput cr; tput el) \
    RED=$(tput setaf 9) \
    GREEN=$(tput setaf 46) \
    ORANGE=$(tput setaf 208) \
    BLUE=$(tput setaf 33) \
    PURPLE=$(tput setaf 177) \
    WHITE=$(tput setaf 15) \
    LTRED=$(tput setaf 211) \
    CYAN=$(tput bold;tput setaf 6) \
    YELLOW=$(tput bold;tput setaf 3) \
    NOFMT=$(tput sgr0)
  # Same thing, but with a hard-coded option
  elif [[ "${COLOR_SETTING-}" == "ALWAYS" ]]; then
    export PROD_COLORS="$(tput setaf 0; tput setab 9; tput smul)" \
    CLEAR_LINE=$(tput cr; tput el) \
    RED=$(tput setaf 9) \
    GREEN=$(tput setaf 46) \
    ORANGE=$(tput setaf 208) \
    BLUE=$(tput setaf 33) \
    PURPLE=$(tput setaf 177) \
    WHITE=$(tput setaf 15) \
    LTRED=$(tput setaf 211) \
    CYAN=$(tput bold;tput setaf 6) \
    YELLOW=$(tput bold;tput setaf 3) \
    NOFMT=$(tput sgr0)
  else
    NOFMT='' PROD_COLORS='' CLEAR_LINE='' RED='' GREEN='' ORANGE='' BLUE='' WHITE='' PURPLE='' LTRED='' CYAN='' YELLOW=''
  fi
}

NO_COLOR=0
setup_colors

# Something to show us what colors have been defined
showColors() {
  local _col
  for c in PROD_COLORS CLEAR_LINE RED GREEN ORANGE BLUE PURPLE WHITE LTRED CYAN YELLOW; do
    eval _col=\$${c}
    echo "${_col}${c}${NOFMT}"
  done
}

# Since we have env variables that are escape codes, `env` will have wonky output.
# We replace `env` with a function that calls the underlying env and de-wonkifies
# the output.
function penv() {
  /usr/bin/env | sort | while read v; do
    _vVal=$(echo ${v#*=})
    # echo substr: ${_vVal:0:2} ::
    if [[ ${_vVal:0:2} == '[' ]]; then
      echo -e "${v%=*}='${v#*=}${v%=*}${NOFMT}' << (color escape code example)"
    else
      echo -e "${v%=*}=${v#*=}"
    fi
  done
}

DEBUG=${GLOBAL_DEBUG:-$(false)}

pdebug() {
  if [[ ${DEBUG:-} ]]; then
    msg "${YELLOW}DEBUG${NOFMT}: $*"
  fi
}

### Print out a pretty spinner
spinner() {
  # Print the following characters sequentially: | / - \
  case "${SPINNER_STATE-}" in
    '-')
      SPINNER_STATE='\'
      ;;
    '\')
      SPINNER_STATE='|'
      ;;
    '|')
      SPINNER_STATE='/'
      ;;
    '/')
      SPINNER_STATE='-'
      ;;
    *)
      SPINNER_STATE='-'
      ;;
  esac
  msg_n "\b${SPINNER_STATE-}"
}

# Something to recursively source in a directory
source_dot_d_files() {
  dot_d_dir="${1}"
  if [[ -z "${dot_d_dir}" ]]; then
    echo "No file provided to source_dot_d_files() function"
    return
  fi
  if [[ ! -d "${dot_d_dir}" ]]; then
    echo "Could not find directory '${dot_d_dir}' to source files from"
    return
  fi
  local conf_files=("${dot_d_dir}"/*.{sh,zsh}(N))
  local f=''
  local _loopCount=0
  for f in ${(o)conf_files}; do
    # ignore files that begin with a tilde
    case ${f:t} in '~'*) continue;; esac
    shortName="${f##${HOME}/}"
    msgStatus "    sourcing '${shortName}'"
    source "$f"
    msgStatus "    sourcing '${shortName}' complete"
    _loopCount=$(( _loopCount + 1 ))
  done
}
