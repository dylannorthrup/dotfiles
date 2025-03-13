#!/bin/bash

echo "This tool is abandonware, but left here in case it can be useful to me later."
bailEarly="1"
[[ "${bailEarly}" == "1" ]] && exit  # Done this way to avoid having shellcheck yell at me

diff_file() {
  fname=$1
  echo "Differences for ${fname}:"
  diff "${fname}" "${HOME}"/"${fname}"
  if [[ $? -lt 1 ]]; then
    return 0
  fi
  return 1
}

diff_dir() {
  dname=$1
  echo "Differences for ${dname}:"
  if ! diff "${dname}" "${HOME}"/"${dname}" | grep -E '[<>]'; then
    return 1
  fi
  return 0
}

confirm_copy() {
  fname=$1
  read -r -p "Copy ${fname} (Y/N) " -n 1
  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    return 1
  fi
  echo "Skipping copy for ${fname}"
  return 0
}

copy_file() {
  cp -rp "${1}" "${HOME}"/"${1}"
}

check_and_copy_file() {
  fname=$1
  if ! diff_file "${fname}"; then
    if ! confirm_copy "${fname}"; then
      set -x
      # Build out dir structure if necessary
      DIRNAME=$(dirname "${HOME}"/"${fname}")
      if [[ ! -d "${DIRNAME}" ]]; then
        echo "Directory '${DIRNAME}' does not exist"
        mkdir "${DIRNAME}"
      else
        echo "Directory '${DIRNAME}' exists"
      fi
      set +x
      copy_file "${fname}"
    fi
  else
    echo "No differences, continuing to next file"
  fi
}

grep -v '^#' filelist | while read -r i; do
  # If the entry is a file, we want to check the files underneath for differences
  if [[ -f "${i}" ]]; then
    check_and_copy_file "${i}"
  elif [[ -d "${i}" ]]; then
    # Find to get the list of files and run check_and_copy_file on each file
    find "${i}" -type f | while read -r fname; do
      check_and_copy_file "${fname}"
    done
  else
    # This isn't a file or directory, so skip it
    echo "Not a file or directory. Skipping"
  fi
done

echo ""
