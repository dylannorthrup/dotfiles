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
  # Source in ssh-agent environment (with some double checking)
  if [ -f $SSH_ENV ]; then
    . $SSH_ENV
    /usr/bin/ssh-add
  else
    echo "Something bad is going on. The file '$SSH_ENV' is not present and it should be"
    echo "Please investigate!"
  fi
fi

PROMPT_COMMAND='/Users/dnorthrup/bin/show_git_branch.sh'

PATH=/usr/local/opt/ruby/bin:$PATH:~/repos/chef-master/bin

# User specific aliases and functions
alias be='bundle exec'
alias beb='bundle exec berks'
alias bebr='bundle exec braid'
alias bek='bundle exec knife'
alias beke='bundle exec knife environment'
alias bel='bundle exec librarian-chef'
alias bev='bundle exec vagrant'
alias cd56='cd ~/repos/chef-cnn-56m'
alias cdgust='cd ~/repos/svnrepo/puppet/branches/STAGE/files/gust'
alias cdlax='cd ~/repos/chef-cnn-lax'
alias cdmain='cd ~/repos/chef-main'
alias cdmaster='cd ~/repos/chef-master'
alias cdpup='cd ~/repos/svnrepo/puppet/branches/STAGE/'
alias cdrepo='cd ~/repos'
alias curl='curl -sS'
alias curlv='curl -sS -o /dev/null -v'
alias curlhead='curl -sSL -D - -o /dev/null'
alias dxn='ssh docxstudios@johnnyblaze.dreamhost.com'
alias gc='egrep --color'
alias gittyup='git tyup'
alias gr='gc -r'
alias iob='ssh io-build-2.cnn.vgtf.net'
alias ke='bundle exec knife environment'
alias knife='bundle exec knife'
alias knofe='knife'
alias mon8zen1='ssh mon8zen1'
alias monp1zendev1='ssh monp1zendev1'
alias ng='nodegrep'
alias lng='laxnodegrep'
alias p2='ssh phalanx2'
alias prespace='sed -e "s/^/ /g"'
alias psu='cd ~/repos/svnrepo/puppet; svn up; cd -'
alias puppet-master="ssh puppet"
alias pupup='cd ~/repos/svnrepo/puppet/branches/STAGE; svn up; cd -'
alias reset56='cd ~/repos; rm -rf chef-cnn-56m; mkdir chef-cnn-56m; git clone git@bitbucket.org:vgtf/chef-cnn-56m.git'
alias resetlax='cd ~/repos; rm -rf chef-cnn-lax; mkdir chef-cnn-lax; git clone git@bitbucket.org:vgtf/chef-cnn-lax.git'
alias resetmain='cd ~/repos; rm -rf chef-main; mkdir chef-main; git clone git@bitbucket.org:vgtf/chef-main.git chef-main'
alias resetmaster='cd ~/repos; rm -rf chef-master; mkdir chef-master; git clone git@bitbucket.org:vgtf/chef-main.git chef-master'
alias rg='rolegrep'
alias rls='find . | egrep -v "CVS|.svn"'
alias ssr='ssh -l root'
alias ssz='ssh -i ~/.ssh/id_rsa.zenoss -l zenoss'
alias ta='tmux new -t 0'
alias view='vim -R'
alias xwing='ssh xwing.turner.com'
alias ywing='ssh ywing.cnn.vgtf.net'

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
export PS1='[\w] [\t] \h> '

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

function demonbox {
  scp -rp $* docxstudios@johnnyblaze.dreamhost.com:~/dropbox/demon/
}

function dropbox {
  scp -rp $* docxstudios@johnnyblaze.dreamhost.com:~/dropbox/
}

function kick_nginx {
  ssh $* 'sudo /etc/init.d/nginx restart'
}

function laxnodegrep {
  egrep "$@" ~/knife/lax-node-list
}

function nodegrep {
  egrep "$@" ~/knife/node-list
}

function rolegrep {
  egrep "$@" ~/knife/role-list
}

function ppsvn {
  export SVN_SSH='ssh -l dnorthrup'
  export SVNROOT='svn+ssh://dnorthrup@puppet.turner.com/svn/puppet/'
}

function websvn {
  export SVN_SSH='ssh -l dnorthrup'
  export SVNROOT='svn+ssh://dnorthrup@web.turner.com/SVN/'
}

function addsunsshkey {
  ssh $* 'mkdir .ssh'
  scp ~/.ssh/id_rsa.pub $*:.ssh/authorized_keys
  ssh $* hostname
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

function which {
  if declare -f "$*" > /dev/null; then
    type $*
  else
    /usr/bin/which -s $*
    if [ $? -eq 0 ]; then
      /usr/bin/which $*
    else
      echo "Command '${*}' not found"
    fi
  fi
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
