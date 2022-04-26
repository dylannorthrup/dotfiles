#!/bin/bash

curl -sSL ${ES_URL}/_cat/shards | sort | egrep --color=always -C 2 UNASSIGNED

if [ $? -eq 1 ]; then
  echo "No UNASSIGNED shards found"
fi
