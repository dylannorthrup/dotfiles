# Git-related aliases, functions, etc.

alias gla='git la'
alias todo='GH_TODO_REPO=dylannorthrup/todo gh todo'

function gfd() {
  git diff $(git st | awk '/modified: / {print $2}' | head -1)
}

function syncbranch {
  # Prune local branches that are not on the remote origin
  git fetch -p
  # Now, prune local dana
  # List remote branches and put them into a string
  REMOTE_BRANCHES=$(git branch -r --no-color | awk '{print $1}')
  # Get list of local branches (ignoring 'master') that are tracking origin.
  for b in $(git branch -vv --no-color | grep -v '^\* master' | \grep --color=never origin | awk '{print $1}'); do
    # Compare each local branch against the list of remote branches
    echo "${b}" | \grep --color=never "${REMOTE_BRANCHES}" > /dev/null
    # If the local branch that is supposedly tracking an origin branch does not have
    # a remote partner, go ahead and delete it
    if [[ $? -eq 1 ]]; then   # Local branch NOT on remote
      echo "Deleting branch '${b}'"
      git branch -D "${b}"
    fi
  done
  # And show the remaining branches
  git branch
}

function gitag() {
  TAG="$@"
  git tag "$TAG"
  # If the tag was successful, go ahead and push it out
  if [ $? -eq 0 ]; then
    echo ==== Pushing tag "$TAG" ====
    git push --tags
  fi
}


function branch() {
  git co -b "${1}"
  git push --set-upstream origin "${1}"
}

function gitup() {
  for i in ~/repos/*; do
    if [ -d ${i}/.git ]; then
      echo -e "* Updating ${i}"
      (
        cd $i
        git pull --rebase --autostash
      )
    fi
  done
}
