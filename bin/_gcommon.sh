#!/bin/bash
#
# Common functions to do gcloud activities.

lib_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd $lib_dir

. ${lib_dir}/_common.sh

DEFAULT_PROJECT="${DEFAULT_GCP_PROJECT}"

# Grab whatever project we have configured and use that
if [ -z ${PROJECT} ]; then
  gcloud_config_project=$(gcloud config get-value project 2>&1)
  # If we did not set a project, detect that and use a default
  echo "$gcloud_config_project" | egrep --color=never 'has no property' > /dev/null
  if [ $? -eq 0 ]; then
    PROJECT="${DEFAULT_PROJECT}"
  else
    PROJECT="${gcloud_config_project}"
  fi
fi

function _gcomp {
  gcloud --project="${PROJECT}" compute "$@"
}

function _ginst {
  _gcomp instances "$@"
}

function get_compute_instances_list {
  _ginst list
}

function _gnode_info {
  NODE="$1"
  LOC=$(node_location ${NODE})
  _ginst describe ${NODE} --zone=${LOC}
}

function node_location {
  NODE="$1"
  if [[ -z ${NODE} ]]; then
    msg "${RED}ERROR:${NOFMT} no NODE was provided to the 'node_location' function"
    return 1
  fi
  _ginst list | egrep --color=never "^${NODE}" | awk '{print $2}'
}

# Cluster commands
KUBE_CONTEXT_PREFIX="gke_${PROJECT}"
function _get_kube_context {
  CLUS_NAME="$1"
  CLUS_LOC="$2"
  echo "${KUBE_CONTEXT_PREFIX}_${CLUS_NAME}_${CLUS_LOC}"
}

function _kctl {
  local CLUSTER="$1"; shift
  local LOCATION=$(_gclu_loc ${CLUSTER})
  local CONTEXT=$(_get_kube_context ${LOCATION} ${CLUSTER})
  _gclu_auth ${CLUSTER} ${LOCATION}
  kubectl --context=${CONTEXT} --output=json "$@"
}

function _gclu {
  _rcog container clusters "$@"
}

function _gclu_auth {
  _gclu get-credentials "$1" --zone="$2"
}

function _gclu_list {
  _gclu list
}

function _gclu_loc {
  CLU_NAME=$1
  _gclu_list | awk -v cluster="${CLU_NAME}" '$1 == cluster {print $2}'
}
