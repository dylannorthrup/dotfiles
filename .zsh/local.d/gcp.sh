# gcloud aliases and ENV vars
. /usr/lib/google-cloud-sdk/path.zsh.inc
. /usr/lib/google-cloud-sdk/completion.zsh.inc
export DEFAULT_GCP_PROJECT='wouldnt-you-like-to-know'
export PATH=${PATH}:${HOME}/bin:${HOME}/google-cloud-sdk/bin
alias gcomp='gcloud compute'
alias ginst='gcomp instances'
alias gdisk='gcomp disks'

alias gssh='ssh -i ~/.ssh/google_compute_engine'
alias gcssh='gcloud compute ssh'

export KUBECONFIG=${HOME}/.kube/config
# Generating the kubectl completion is an expensive operation. So, I do it once a day.
# But, I also want to make sure that only one shell is doing this at a time (in case
# I'm spawning multiple shells at a time when the completion should be regenerated).
KC_COMPLETION_FILE="$HOME/.zsh/kubectl.completion"
zmodload zsh/system
generate_kc_completion_if_needed() {
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
}
if [[ ! -f ${KC_COMPLETION_FILE} ]]; then
  generate_kc_completion_if_needed "The kubectl completion file is missing."
elif [[ $(( $(date +%s) - $(date -r ${KC_COMPLETION_FILE} +%s) )) -gt 86400 ]]; then
  generate_kc_completion_if_needed "The kubectl completion file is old."
fi

# Put in a test here for if the file is locked and loop until a) it unlocks or
# b) we timeout after 20 seconds.
if [[ -f "${KC_COMPLETION_FILE}" ]]; then
  2>/dev/null zsystem flock -f lockvar -t 20 ${KC_COMPLETION_FILE} && \
    source ${KC_COMPLETION_FILE} && \
    zsystem flock -u $lockvar
  export KC_EXPANDED="True"
else
  echo "Could not source in the kubectl completion file '${KC_COMPLETION_FILE}'"
  echo "You'll likely want to figure out why and correct the issue."
  export KC_EXPANDED="False"
fi

alias kc='kubectl'
kcshell() {
  args=$(echo "$@" | sed -e 's/describe pod //')
  kubectl exec --stdin --tty ${=args} -- /bin/bash
}
complete -F __start_kubectl kc
complete -F __start_kubectl kcshell
complete -F __start_kubectl show-cluster-pods
complete -F __start_kubectl show-cluster-nodes
