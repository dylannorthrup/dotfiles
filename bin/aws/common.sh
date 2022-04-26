#!/bin/bash

#if [ -z "$BIN_COMMON_ZOURCED" ]; then
#
#export BIN_COMMON_SOURCED=true

CACHE_DIR="${HOME}/.aws_cache"

# Set this unless it's already set
if [ -z ${AWS_REGION} ]; then
  AWS_REGION="us-east-1"
fi

function make_cache_dir_if_it_does_not_exist {
  if [ -d ${CACHE_DIR} ]; then
    return
	else
  	mkdir ${CACHE_DIR}
  fi
}

function build_cache_filename {
  echo "${CACHE_DIR}/$1"
}

# Do aws query and cache those results
# NOTE: DOES NOT ECHO BACK CONTENTS OF FILE
function describe_aws_instance_and_cache {
  local HOST=$1
  local FNAME=$(build_cache_filename ${HOST})
	if [ "${region}X" == "X" ]; then # No $region defined. We trust ENV vars are appropriate defined
		aws ec2 describe-instance-status --include-all-instances --instance-ids ${HOST} > ${FNAME}
	else
	  aws ec2 describe-instances --instance-ids ${HOST} --profile $AWS_PROFILE $region > ${FNAME}
	fi
}

function read_cache_or_query_aws {
  HOST=$1
  make_cache_dir_if_it_does_not_exist
  FNAME=$(build_cache_filename ${HOST})
  # If no file, query aws and cache it;
  # If file older than a day, query aws and cache it
  if [ ! -f "${FNAME}" ]; then
    describe_aws_instance_and_cache ${HOST}
  elif [[ $(find "$FNAME" -mtime +1 -print) ]]; then
    describe_aws_instance_and_cache ${HOST}
  fi
  # cat the contents (either newly retrieved or cached less than a day ago
  cat "${FNAME}"
}

#set -x
#fi
