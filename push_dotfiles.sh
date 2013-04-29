#!/bin/bash

diff_file() {
  fname=$1
  echo Differences for $fname:;
  diff $fname ~/$fname
  if [ $? -lt 1 ]; then
    return 0
  fi
  return 1
}

diff_dir() {
  dname=$1
  echo Differences for $dname:;
  diff $dname ~/$dname | egrep '[<>]'
  if [ $? -gt 0 ]; then
    return 1
  fi
  return 0
}

confirm_copy() {
  fname=$1
  read -p "Copy ${fname} (Y/N) " -n 1
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    return 1
  fi
  echo "Skipping copy for ${fname}"
  return 0
}

copy_file() {
  echo cp -rp $1 ~/$1
}

check_and_copy_file() {
  fname=$1
  diff_file $fname
  if [ $? -gt 0 ]; then
    confirm_copy $fname
    if [ $? -gt 0 ]; then
      # Build out dir structure if necessary
      DIRNAME=$(dirname $fname)
      if [ ! -d $DIRNAME ]; then
        mkdir $DIRNAME
      fi
      copy_file $fname
    fi
  else
    echo "No differences, continuing to next directory"
  fi
}

for i in $(grep -v '^#' filelist); do
  # If the entry is a file, we want to check the files underneath for differences
  if [ -f $i ]; then
    check_and_copy_file $i
  elif [ -d $i ]; then
    # Find to get the list of files and run check_and_copy_file on each file
    for fname in $(find $i -type f); do
      check_and_copy_file $fname
    done
  else
    # This isn't a file or directory, so skip it
    echo "Not a file or directory. Skipping"
  fi
done
