# gcloud completions

# Generating the kubectl completion is an expensive operation. So, I do it once a day.
# But, I also want to make sure that only one shell is doing this at a time (in case
# I'm spawning multiple shells at a time when the completion should be regenerated).
KC_COMPLETION_FILE="$HOME/.zsh/completions.d/kubectl.sh"
zmodload zsh/system
generate_kc_completion_if_needed() {
  set -x
  echo "${*} Regenerating. Patience, please"
  (
    local lockvar
    local lockvar_tmp
    if [[ ! -f ${KC_COMPLETION_FILE} ]]; then
      touch ${KC_COMPLETION_FILE}
    fi
    if [[ ! -f ${KC_COMPLETION_FILE}_tmp ]]; then
      touch ${KC_COMPLETION_FILE}_tmp
    fi
    # with a timeout of 0, this throws an error message. So we redirect stderr to
    # /dev/null. And we prepend the redirection because zsystem interprets it as
    # an argument if we try to do it at the end of the command, prior to the ||.
    # The exit is the sub-shell exiting
    2>/dev/null zsystem flock -f lockvar -t 0 ${KC_COMPLETION_FILE} || exit 1
    2>/dev/null zsystem flock -f lockvar -t 0 ${KC_COMPLETION_FILE}_tmp || exit 1
    kubectl completion zsh > ${KC_COMPLETION_FILE}_tmp
    cp ${KC_COMPLETION_FILE}_tmp ${KC_COMPLETION_FILE}
    zsystem flock -u $lockvar
    rm ${KC_COMPLETION_FILE}_tmp
  )
  if [[ $? -ne 0 ]]; then
    echo "Completion file was locked by another process. We'll wait for that to complete"
    echo "and source in the results."
  fi
  set +x
}
