#!/bin/bash

INDEX_NAME=$1

if [ -z $1 ]; then
  echo "Usage: $0 <shard_name_to_clear>"
  echo "  Running against ${ES_URL}"
  exit 1
fi

set -x
curl -XPUT ${ES_URL}/${INDEX_NAME}/_settings -H 'Content-Type: application/json' -d '{"index": {"routing.allocation.require._name": null}}'
