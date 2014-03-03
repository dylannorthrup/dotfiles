# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
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

PROMPT_COMMAND='~/bin/show_git_branch.sh'

PATH=/opt/junkdrawer/bin:/usr/local/opt/ruby/bin:/usr/local/bin:$PATH:~/repos/chef-atom/bin:/opt/bin:/opt/local/bin:/opt/chef/embedded/bin:~/bin

# Adding in Android tools path
if [ -d "/Users/dnorthrup/temp/adt-bundle-mac-x86_64-20130729/sdk/platform-tools" ]; then
  PATH=$PATH:/Users/dnorthrup/temp/adt-bundle-mac-x86_64-20130729/sdk/platform-tools
fi
if [ -d "/Users/docx/temp/adt-bundle-mac-x86_64-20130729/sdk/platform-tools" ]; then
  PATH=$PATH:/Users/docx/temp/adt-bundle-mac-x86_64-20130729/sdk/platform-tools
fi

# User specific aliases and functions
alias curl='curl -sS 2>&1'
alias curlv='curl -sS -o /dev/null -v 2>&1'
alias curlvt='curl -sS -o /dev/null -v -w "HTTP Code: %{response_code}; Connect time: %{time_connect}; Total time:%{time_total}\n" 2>&1'
alias curlhead='curl -sSL -D - -o /dev/null'
alias dxn='ssh docxstudios@johnnyblaze.dreamhost.com'
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
alias prespace='sed -e "s/^/ /g"'
alias random='echo $(( ( RANDOM % 60 )  + 1 ))'
alias repos='ls ~/repos'
alias s3cmd="$HOME/bin/gs3"
alias ssr='ssh -l root'
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
export CHEF_REPODIR="$HOME/repos"

# Make it so we append history to the history file each time we
# type a command so it doesn't get lost because of disconnections
# for long-running sessions
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
HISTFILESIZE=10000

### Functions

alias functions="typeset -f | egrep '^[a-z]+ \\(\\)' | sed -e 's/()//' | sort"

function emw {
  mwin $(echo $*)
}

function kcu {
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

function demonbox {
  scp -rp $* docxstudios@johnnyblaze.dreamhost.com:~/dropbox/demon/
}

function dropbox {
  scp -rp $* docxstudios@johnnyblaze.dreamhost.com:~/dropbox/
}

function addsshkey {
#  ssh $* 'mkdir ~/.ssh'
#  scp ~/.ssh/id_rsa.pub $*:~/.ssh/authorized_keys
  ssh-copy-id -i ~/.ssh/id_rsa.pub $*
  ssh $*
}

function distsshkey {
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

function distkey {
  distsshkey $*
}

function delhostkey {
  grep -v "$*" ~/.ssh/known_hosts > ~/.ssh/known_hosts.new
  mv ~/.ssh/known_hosts.new ~/.ssh/known_hosts
}

function countdown {
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

function gitup {
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

function cab() {
  curlv http://${1}${3} | hlhttp
  curlv http://${2}${3} | hlhttp
}

function which {
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
