# Terraform shortcuts

PATH="${PATH}:~/.tfenv/bin"

alias tf='terraform'
alias tfd='terraform fmt -diff'
alias tfay='terraform apply -auto-approve'
alias tfp='terraform plan -lock=false'
alias tfpd='terraform plan -lock=false -no-color | egrep --color=never "^[^a-z]*[\~\+\-]+|# module|# google" | colorize white "^  *# google.*" whtonred "- .*=" cyan "\+ .*=" yellow "~ .*=" yellow "~ .* \{" whtonred "- .* \{\}"'
alias dtfay='TF_LOG=DEBUG terraform apply -auto-approve'
alias tps='terraform plan -lock=false | grep -v "Refreshing" | pgrep "#"'
alias _tps='tf plan -lock=false | grep -v "Refreshing" | egrep "module.*google_|Plan|No changes.*"'

tfayt() {
  terraform apply -auto-approve -target="$1"
}
