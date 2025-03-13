#!/usr/bin/zsh
# shellcheck shell=bash
# GPG Stuff

if command -v tty > /dev/null; then
  GPG_TTY=$(tty)
  export GPG_TTY
else
  >&2 echo "Could not find 'tty' command. Not setting GPG_TTY env var."
fi

gpgcat() {
    local passw;
    fname="$(echo $@)"
    if [[ ! -f "${fname}" ]]; then
      if [[ -f "${fname}.gpg" ]]; then
        encryptedFile="${fname}.gpg"
      else
        >&2 echo "Could not find file '${fname}' to decrypt."
        return
      fi
    else
      encryptedFile="${fname}"
    fi
    read -rs "?GPG Password: " passw;
    echo;
    stty echo;
    echo "${passw}" | gpg -q -d --batch --passphrase-fd 0 "${encryptedFile}"
}

decrypt () {
  encryptedFname=$(echo $@)
  fname=$(echo $encryptedFname | sed -e 's/.gpg$//')
  if [[ ! -f "${encryptedFname}" ]]; then
    >&2 echo "Could not find file '${encryptedFname}' to decrypt."
    return
  fi
  gpg --output $fname --decrypt $encryptedFname && rm $encryptedFname
}

encrypt() {
  if [ -f "${@}.gpg" ]; then
    rm ${@}.gpg
  fi
  gpg -c $@ && rm $@
}

# PASS stuff
# Put in here as it relies on gpg
# Increase clipboard clear time to 10 minutes
export PASSWORD_STORE_CLIP_TIME=600
