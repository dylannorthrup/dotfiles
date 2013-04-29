#!/bin/sh
#
# Something to show me what git branch I'm on if I'm in a git directory

REPO_PATH="${HOME}/repos/"
SAFE_PATTERN=$(printf "%s\n" "$REPO_PATH" | sed 's/[][\.*^$(){}?+|/]/\\&/g')

OUT=''

case "${PWD}" in 
  ${REPO_PATH}* ) 
    REPODIR=$(echo ${PWD} | sed -e "s/${SAFE_PATTERN}//; s/\/.*$//")
    if [ -d ${REPO_PATH}${REPODIR}/.git ]; then
      OUT=$(git branch | grep "^\*" | sed -e "s/^\* /GIT BRANCH: [/; s/$/] /" | colorize white 'GIT BRANCH:' red '[^ ]* $') 
    fi ;;
  * ) ;;
esac

# If this is blank, exit (so we don't print a blank line)
if [ -z "$OUT" ]; then
  exit
fi
# Print out the branch name
echo $OUT
