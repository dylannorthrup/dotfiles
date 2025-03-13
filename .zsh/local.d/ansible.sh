#!/usr/bin/zsh
# shellcheck shell=bash
# Ansible shortcuts
alias amwin='ansible --list-hosts all | grep -v host | xargs mwin'
alias ap='ansible-playbook'
alias aptest='ansible-playbook -CD'
alias lsah='ansible --list-hosts all | grep -v "hosts"'
alias taglist='ap *.yml --list-tags'
alias vap="ansible-playbook --private-key='${HOME}/.ssh/vault_signed_key.pub'"
# Elegant stanzas for a more civilized life
#function _preAnsibleTfTest() {
#  if [[ ! -d ./.terraform ]]; then
#    echo "### No .terraform directory. Running 'terraform init'."
#    terraform init
#    echo "### Terraform config regenerated. Running ansible command"
#  fi
#}
#alias ap='_preAnsibleTfTest; ansible-playbook --skip-tags require_master_branch'
#alias aptest='_preAnsibleTfTest; ansible-playbook -CD --skip-tags require_master_branch'
#alias lsah='_preAnsibleTfTest; ansible --list-hosts all | grep -v "hosts"'
#alias taglist='_preAnsibleTfTest; ap *.yml --list-tags'
#plsah() {
#  PROJ=$(basename "$(pwd)" | sed -e 's/^tock-//')
#  _preAnsibleTfTest
#  ansible --list-hosts all | grep -v host | sed -e "s/$/.${PROJ}.tock/"
#}
#pamwin() {
#  PROJ=$(basename "$(pwd)" | sed -e 's/^tock-//')
#  _preAnsibleTfTest
#  ansible --list-hosts all | grep -v host | sed -e "s/$/.${PROJ}.tock/" | xargs mwin
#}
