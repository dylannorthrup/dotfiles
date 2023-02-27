#!/usr/bin/zsh
# shellcheck shell=bash
# Ansible shortcuts
function _preAnsibleTfTest() {
  if [[ ! -d ./.terraform ]]; then
    echo "### No .terraform directory. Running 'terraform init'."
    terraform init
    echo "### Terraform config regenerated. Running ansible command"
  fi
}
alias amwin='ansible --list-hosts all | grep -v host | xargs mwin'
alias ap='_preAnsibleTfTest; ansible-playbook --skip-tags require_master_branch'
alias aptest='_preAnsibleTfTest; ansible-playbook -CD --skip-tags require_master_branch'
alias lsah='_preAnsibleTfTest; ansible --list-hosts all | grep -v "hosts"'
alias taglist='_preAnsibleTfTest; ap *.yml --list-tags'
plsah() {
  PROJ=$(basename "$(pwd)" | sed -e 's/^tock-//')
  _preAnsibleTfTest
  ansible --list-hosts all | grep -v host | sed -e "s/$/.${PROJ}.tock/"
}
pamwin() {
  PROJ=$(basename "$(pwd)" | sed -e 's/^tock-//')
  _preAnsibleTfTest
  ansible --list-hosts all | grep -v host | sed -e "s/$/.${PROJ}.tock/" | xargs mwin
}
