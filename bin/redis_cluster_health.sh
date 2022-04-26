#!/bin/bash

REDIS_HOST="$1"

run_redis_cmd() {
  echo "== Running '$*'"
  redis-cli -h ${REDIS_HOST} $*
}


run_redis_cmd cluster nodes
#run_redis_cmd cluster info
#run_redis_cmd info stats
run_redis_cmd info replication
#run_redis_cmd info memory
