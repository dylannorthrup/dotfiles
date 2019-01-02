# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source bash_profile definitions
if [ -z "$BASH_PROFILE_SOURCED" ]; then
  if [ -f "$HOME/.bash_profile" ]; then
    . "$HOME/.bash_profile"
  fi
fi

# Detect if we're in non-interactive mode
if [ ! -z "$PS1" ]; then 
  # Interactive!
  # Check if we have an ssh agent running
  SSH_ENV="$HOME/.ssh/environment"
  # See if we have ssh-agent environment set up
  if [ ! -f $SSH_ENV ]; then
    echo "Regenerating '$SSH_ENV'"
    /usr/bin/ssh-agent > $SSH_ENV
  fi
  # Make sure the SSH_ENV is there and, if so, source it in 
  if [ -f $SSH_ENV ]; then
    . $SSH_ENV
    /usr/bin/ssh-add
  else
    echo "Was unable to create the file '$SSH_ENV'. Please investigate why"
  fi
fi

# Cloudfoundry-specific stuff
# Source in cflogin file
if [ -f "$HOME/.cflogin" ]; then
  . "$HOME/.cflogin"
fi

PROMPT_COMMAND='~/bin/show_git_branch.sh'

PATH=/usr/local/bin:/usr/local/opt/ruby/bin:$PATH:/opt/bin:/opt/local/bin:/opt/chef/embedded/bin:~/bin:~/repos/chef-atom/bin

# User specific aliases and functions
alias curl='curl -sS 2>&1'
alias curlv='curl -sS -o /dev/null -v 2>&1'
alias curlvt='curl -sS -o /dev/null -v -w "HTTP Code: %{response_code}; Connect time: %{time_connect}; Total time:%{time_total}\n" 2>&1'
alias curlhead='curl -sSL -D - -o /dev/null'
alias diff='diff -W $(( $(tput cols) - 2 ))'
alias domesync="rsync -avz -e 'ssh -p 2222' --rsync-path=/sbin/rsync --progress"
alias dxn='ssh docxstudios@spectator.dreamhost.com'
alias fl8='flake8-3 --ignore=E111,E114,E129'
alias gc='egrep --color'
alias gittyup='git tyup'
alias grep='egrep'
alias gr='gc -r'
alias gv='gc -v'
alias kcs='knife cookbook show'
alias ke='knife environment'
alias knofe='knife'
alias more='less -X'
alias p2='ssh phalanx2'
alias pegasus='ssh pegasus'
#alias pip='pip3.6'
alias prespace='sed -e "s/^/ /g"'
#alias python='python3'
alias random='echo $(( ( RANDOM % 60 )  + 1 ))'
alias repos='ls ~/repos'
alias s3cmd="$HOME/bin/gs3"
alias ssr='ssh -l root'
alias swift='xcrun swift'
alias sz='say -v Zarvox'
alias ta='tmux new -t 0'
alias view='vim -R'
alias watch='watch -d --color'

# Linux specific aliases
if [ $(uname) == 'Linux' ]; then
  alias ls='ls -F --color'
else
  alias ls='ls -F'
fi

# Environment variables
export CVSROOT='web:/u1/CVS'
export CVS_RSH='ssh'
export EDITOR='vim'
export SUDO_PS1='\e[01;31m[\w] [\t] \h#\[\033[0m\] '
export PS1='[\w] [\t] \h> '
#export PYTHONSTARTUP=$HOME/.pythonrc.py

export FZF_TMUX=1
export FZF_CTRL_R_OPTS='--sort --exact'
if [ -d /usr/local/Cellar/fzf/0.17.5/shell/ ]; then
  . /usr/local/Cellar/fzf/0.17.5/shell/key-bindings.bash
  . /usr/local/Cellar/fzf/0.17.5/shell/completion.bash
else
  echo "NO FZF SHELL COMPLETION DIRECTORY! FZF WON'T WORK LIKE YOU THINK IT SHOULD"
fi

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# Make it so we append history to the history file each time we
# type a command so it doesn't get lost because of disconnections
# for long-running sessions
shopt -s histappend
# After each command, append to the history file and re-read it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export HISTFILESIZE=100000

## tmux stuff
function ta {
  tmux has-session -t 0
  if [ $? != 0 ]; then
    tmux new-session -s 0 -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
  fi
  tmux attach -t 0
}

## Golang Stuff
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"

vigo () {
  vim "${GOPATH}/src/$*/$*.go"
}

newgo () {
  if [ ! -d "${GOPATH}/src/$*" ]; then
    mkdir -p "${GOPATH}/src/$*"
  fi
  vigo $*
  go install "${GOPATH}/src/$*/$*.go"
}

grun () {
  if [ "${PWD}X" != "${GOPATH}X" ]; then
    cd $GOPATH
  fi
  export GOBIN="$GOPATH/bin"
  #go install src/$*/$*.go
  go install src/$*/$*.go
  if [ $? -eq 0 ]; then
    $*
  else
    echo "Problem doing a go install of src/$*/$*.go"
  fi
}

_grun_dirs() {
  local cur=${COMP_WORDS[COMP_CWORD]};
  #COMPREPLY=($(\cd $GOPATH/src; compgen -d "$cur" | sed -e 's,$,/,'))
  COMPREPLY=($(\cd $GOPATH/src; compgen -d "$cur" ))
}

complete -o filenames -o nospace -F _grun_dirs grun
complete -o filenames -o nospace -F _grun_dirs vigo
### Functions

alias functions="typeset -f | egrep '^[a-z]+ \\(\\)' | sed -e 's/()//' | sort"

emw() {
  mwin $(echo $*)
}

kcu() {
  foodcritic -B ~/repos/cookbooks/"$@" | grep FC && echo "Foodcritic failed!" && return
  knife cookbook test "$@" || return
  knife cookbook upload "$@"
}

metaver() {
  echo $(awk '/version/ {print $2}' metadata.rb | tr -d \'\")
}

gitag() {
  TAG="$@"
  git tag "$TAG"
  # If the tag was successful, go ahead and push it out
  if [ $? -eq 0 ]; then
    echo ==== Pushing tag "$TAG" ====
    git push --tags
  fi
}

# Take the previous two functions and combine them to get the metadata version
# then do git tagging
cheftag() {
  gitag $(metaver)
}

demonbox() {
  scp -rp $* docxstudios@spectator.dreamhost.com:~/dropbox/demon/
}

dropbox() {
  scp -rp $* docxstudios@spectator.dreamhost.com:~/dropbox/
}

addsshkey() {
#  ssh $* 'mkdir ~/.ssh'
#  scp ~/.ssh/id_rsa.pub $*:~/.ssh/authorized_keys
  ssh-copy-id -i ~/.ssh/id_rsa.pub $*
  ssh $*
}

distsshkey() {
#  echo "Trying to login automatically"
  ssh -o PreferredAuthentications=publickey -o KbdInteractiveAuthentication=no -o PasswordAuthentication=no -o StrictHostKeyChecking=no $* 'hostname'
  if [ $? == 255 ]; then
#    echo "Could not log in automatically. Running ssh-copy-id."
#    ssh $* 'mkdir ~/.ssh'
#    scp ~/.ssh/id_rsa.pub $*:~/.ssh/authorized_keys
    ssh-copy-id -i ~/.ssh/id_rsa.pub $*
  else
    echo "Was able to log in. No need to copy id"
  fi
}

distkey() {
  distsshkey $*
}

delhostkey() {
  grep -v "$*" ~/.ssh/known_hosts > ~/.ssh/known_hosts.new
  mv ~/.ssh/known_hosts.new ~/.ssh/known_hosts
}

countdown() {
  NUM=$*
  while [ $NUM -gt 0 ]; do
    echo -n "${NUM} "
    NUM=$(expr $NUM - 1)
    sleep 1
  done
  echo 0
}

branch() {
  git co -b "${1}"
  git push --set-upstream origin "${1}"
}

cdr() {
  cd ~/repos/${1}
}

cdc() {
  cdr cookbooks/${1}
}

cdo() {
  cdr chef-${1}
}

gcb() {
  cd ~/repos/cookbooks
  DIR="${1}"
  if [ -d "$DIR" ]; then
    cd "$DIR"
    git up
  else 
    git clone git@bitbucket.org:vgtf/"${DIR}".git
  fi
  cd -
  cd ~/repos/"$DIR"
}

gco() {
  cd ~/repos
  git clone git@bitbucket.org:vgtf/chef-${1}.git
  cd chef-${1}
  bundle
}

gitup() {
  for i in ~/repos/*; do
    if [ -d ${i}/.git ]; then
      echo -e "* Updating ${i}"
      (
        cd $i
        git up
      )
    fi
  done
}

cab() {
  curlv http://${1}${3} | hlhttp
  curlv http://${2}${3} | hlhttp
}

_good_post_size() {
  if [ ${#1} -gt 140 ]; then
    echo "Comment is ${#1} characters long. Please shorten it to 140 or less"
    return 0
  fi
  return 1
}

post() {
  if [ -z "${2}" ]; then
    echo "post MESSAGE"
    return 1
  fi
  # Check the size of our tweet to see how long it is
  _good_post_size "${1}"
  if [ $? ]; then
    echo t update "${1}"
  fi
}

dm() {
  if [ -z "${2}" ]; then
    echo "dm USER MESSAGE"
    return 1
  fi
  # Check the size of our tweet to see how long it is
  _good_post_size "${2}"
  if [ $? ]; then
    echo t dm ${1} "${2}"
  fi
}

reply() {
  if [ -z "${2}" ]; then
    echo "reply TWEET_ID MESSAGE"
    return 1
  fi
  # Check the size of our tweet to see how long it is
  _good_post_size "${2}"
  if [ $? ]; then
    echo t reply ${1} "${2}"
  fi
}

rt() {
  t retweet "${1}"
}

which() {
  if declare -f "$*" > /dev/null; then
    type $*
  else
    WHICHOUT=$(/usr/bin/which $* 2>&1)
    if [ $? -eq 0 ]; then
      echo $WHICHOUT
      #/usr/bin/which $*
    else
      echo "Command '${*}' not found"
    fi
  fi
}

encrypt() {
  if [ -f "${@}.gpg" ]; then
    rm ${@}.gpg
  fi
  gpg --encrypt --recipient 'northrup@gmail.com' $@
  rm $@
}

decrypt() {
  FNAME=$(echo $@ | sed -e 's/.gpg$//')
  gpg --output $FNAME --decrypt $@
}

decat() {
  gpg --decrypt $@
}

espy() {
  knife search node "advertises:${1}" -i
}

# Completion for chef repos (thanks to Mark J Reed)
_cdc_dirs() {
  local cur=${COMP_WORDS[COMP_CWORD]};
  COMPREPLY=($(\cd ~/repos/cookbooks; compgen -d "$cur" | sed -e 's,$,/,'))
}

_cdo_dirs() {
  local cur=${COMP_WORDS[COMP_CWORD]};
  COMPREPLY=($(\cd ~/repos; compgen -d "chef-$cur" | sed -e 's,^chef-,,' -e 's,$,/,'))
}

_kcu_dirs() {
  local cur=${COMP_WORDS[COMP_CWORD]};
  COMPREPLY=($(\cd ~/repos/cookbooks; compgen -d "$cur" | sed -e 's,$,/,'))
}

_cdr_dirs() {
  local cur=${COMP_WORDS[COMP_CWORD]};
  COMPREPLY=($(\cd ~/repos; compgen -d "$cur" | sed -e 's,$,/,'))
}

complete -o filenames -o nospace -F _cdc_dirs cdc
complete -o filenames -o nospace -F _cdo_dirs cdo
complete -o filenames -o nospace -F _kcu_dirs kcu
complete -o filenames -o nospace -F _cdr_dirs cdr

notes() {
  NDIR="~/tickets/$@"
  mkdir $NDIR
  cd $NDIR
  vim notes
}

showcbs() {
  NODE="$@"
  echo "Retrieving cookbook list for $@"
  knife exec -E "puts JSON.pretty_generate(api.get(\"nodes/$NODE/cookbooks\").map { |name,data| {name => data.version} }.reduce :merge)"
}

cdiff() {
  diff "$@" | colorize blue "^>.*" red "^<.*"
}

sd() {
  svn diff "$@" | colorize blue "^+.*" red "^-.*"
}

hextojson() {
  cat "$@" | sed -e "s/: '/: \"/g; s/' *}/\"}/g"
}

m4atomp3() {
  i="$@"
  o=$(echo "$i" | sed -e 's/m4a$/mp3/')
  ffmpeg -i "$i" -acodec libmp3lame -ab 128k "$o"
}

# User-Agent Strings
# These are some example UA strings for use in curl strings
export AMIGA='AmigaVoyager/2.95 (compatible; MC680x0; AmigaOS)'
export AND4='Mozilla/5.0 (Linux; U; Android 4.0.3; de-ch; HTC Sensation Build/IML74K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30'
export AND23='Mozilla/5.0 (Linux; U; Android 2.3.5; en-us; HTC Vision Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'
export BB='Mozilla/5.0 (BlackBerry; U; BlackBerry 9860; en-US) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0.254 Mobile Safari/534.11+'
export CHROME='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.60 Safari/537.17'
export FIREFOX='Mozilla/5.0 (Windows NT 6.2; Win64; x64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1'
export IEMOBILE='Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0)'
export IPHONE='Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5'
export IPAD='Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25'
export SAFARI='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2'
export SAMSUNGU365='SCH-U365/1.0.NetFront/3.0.22.2.23.(GUI).MMP/2.0'
export WP7='Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; NOKIA; Lumia 800)'
export WP8='Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 920'
export BB9700='BlackBerry9700/5.0.0.862 Profile/MIDP-2.1 Configuration/CLDC-1.1 VendorID/120'
export NOKIA8310='Mozilla/5.0 (Symbian/3; Series60/5.3 NokiaE7-00/111.040.1511; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/535.1 (KHTML, like Gecko) NokiaBrowser/8.3.1.4 Mobile Safari/535.1'
