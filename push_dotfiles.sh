#!/bin/bash

for i in $(grep -v '^#' filelist); do
  echo Differences for $i:;
  diff $i ~/$i | grep -v ^Only
  echo "Press ENTER to continue"
  read do_it
  # Need to do detection for directories since OS X doesn't do a proper recursive copy 
  # without the trailing slash(es)
  if [ -d $i ]; then
    cp -rp $i/ ~/$i/
  else
    cp -rp $i ~/$i
  fi
done
