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
  [[ ${_SILENCE_MSG-} -eq 1 ]] || msg_n "${1-}\n"
}
# If we want to turn off msg output, set this var
#_SILENCE_MSG=1

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
