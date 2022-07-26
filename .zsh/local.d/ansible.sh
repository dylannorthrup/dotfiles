# Ansible shortcuts
alias amwin='ansible --list-hosts all | egrep -v host | xargs mwin'
alias ap='ansible-playbook --skip-tags require_master_branch'
alias aptest='ansible-playbook -CD --skip-tags require_master_branch'
alias lsah='ansible --list-hosts all | grep -v "hosts"'
alias taglist='ap *.yml --list-tags'
plsah() {
  PROJ=$(basename $(pwd) | sed -e 's/^tock-//')
  ansible --list-hosts all | egrep -v host | sed -e "s/$/.${PROJ}.tock/"
}
pamwin() {
  PROJ=$(basename $(pwd) | sed -e 's/^tock-//')
  ansible --list-hosts all | egrep -v host | sed -e "s/$/.${PROJ}.tock/" | xargs mwin
}
