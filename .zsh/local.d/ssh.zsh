## Do ssh agent stuff

# Uncomment this if you want to do local debugging
#DEBUG=$(true)

declare -a _SSH_IDS

function _get_ssh_ids() {
  # Make sure we have a .ssh folder
  if [[ ! -d "$HOME/.ssh" ]]; then
    return
  fi

  for i in ${HOME}/.ssh/*.pub; do
    j=$(echo "${i}" | sed -e 's/.pub$//')
    if [[ -f "${j}" ]]; then
      pdebug "Appending '${j}' as an identity. _SSH_IDs is length ${#_SSH_IDS} before appending."
      _SSH_IDS+=(${j})
      pdebug "_SSH_IDs is length ${#_SSH_IDS} AFTER appending."
    fi
  done
}

function _start_agent() {
  # Check if ssh-agent is already running
  if [[ -f "${SSH_ENV}" ]]; then
    . "${SSH_ENV}" > /dev/null

    # Test if $SSH_AUTH_SOCK is visible
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  echo "Regenerating '$SSH_ENV' and sourcing it in."
  # start ssh-agent and setup environment
  ssh-agent | sed '/^echo/d' >! "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
}

function _add_identities() {
  local id file line sig lines
  local -a loaded_sigs loaded_ids not_loaded

  # Make sure we have a .ssh folder
  if [[ ! -d "$HOME/.ssh" ]]; then
		echo 2>&1 "No '${HOME}/.ssh' directory present"
    return 1
  fi

  pdebug "Making sure we have identities."
  # Make sure we have some _SSH_IDS we want to add
  if [[ -z ${_SSH_IDS} ]]; then
		echo 2>&1 "No ssh identity files found"
    return 1
  fi

  # get list of loaded identities' signatures and filenames
  if lines=$(ssh-add -l); then
    wc_lines=$(echo "$lines" | wc -l | sed -e 's/^  *//')
    pdebug "Already have ${wc_lines} identities loaded."
    pdebug "${lines[@]}"
    for line in ${(f)lines}; do
      loaded_sigs+=${${(z)line}[2]}
      loaded_ids+=${${(z)line}[3]}
    done
  fi

  pdebug "Before adding, here's what _SSH_IDS looks like: ${_SSH_IDS}"

  # add identities if not already loaded
  for id in ${_SSH_IDS}; do
    pdebug "Checking if ${id} is loaded"
    # if id is an absolute path, make file equal to id
    [[ "$id" = /* ]] && file="$id" || file="$HOME/.ssh/$id"
    pdebug "Set file to ${file}"
    # check for filename match, otherwise try for signature match
    if [[ ${loaded_ids[(I)$file]} -le 0 ]]; then
      sig="$(ssh-keygen -lf "$file" | awk '{print $2}')"
      [[ ${loaded_sigs[(I)$sig]} -le 0 ]] && not_loaded+=("$file")
    fi
  done

  if [[ "${#not_loaded[@]}" -eq 0 ]]; then
    pdebug "All ssh ids loaded."
    return 0
  else
    echo "Loading these ssh ids: ${not_loaded}"
  fi

  pdebug "Running this command: ssh-add \"${args[@]}\" ${^not_loaded}"
  ssh-add "${_SSH_IDS[@]}" ${^not_loaded}
}

# Detect if we're in non-interactive mode
if [ ! -z "$PS1" ]; then
  # Interactive!
  # Check if we have an ssh agent running
  SSH_ENV="$HOME/.ssh/environment"

  _start_agent
  # See if we have ssh-agent environment set up
  if [ ! -f $SSH_ENV ]; then
    _start_agent
  fi

  # Make sure the SSH_ENV is there and, if so, source it in
  if [ -f $SSH_ENV ]; then
    . $SSH_ENV
    _get_ssh_ids
    _add_identities
    # If we had an error, regen and try again
    if [ $? -ne 0 ]; then
      echo "Regenerating '$SSH_ENV' and sourcing re-adding"
      _get_ssh_ids
      _add_identities
    fi
  else
    echo "Was unable to create the file '$SSH_ENV'. Please investigate why"
  fi
fi

DEBUG=${GLOBAL_DEBUG:-$(false)}

unset _SSH_IDS
unfunction _start_agent _add_identities _get_ssh_ids
