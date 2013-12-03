#!/bin/bash
PODNAME="$1"
DOMAIN="$2"

if [ -z $PODNAME ]; then
  echo "Usage: killpod.sh <pod_name> <dns_subdomain>"
  echo "Need to provide a podname. Exiting"
  exit
fi
if [ -z $PODNAME ]; then
  echo "Usage: killpod.sh <pod_name> <dns_subdomain>"
  echo "Need to provide a dns subdomain. Exiting"
  exit
fi

echo "******* WARNING ******* WARNING ******* WARNING ******* WARNING *******"
echo "******* YOU WILL BE COMPLETELY DELETING THE HOSTS FOR $PODNAME IN *******"
echo "******* $DOMAIN PLEASE MAKE DAMNED SURE THIS IS WHAT YOU WANT TO DO *******"
echo -n "Beginning pod destruction for $PODNAME in $DOMAIN. Press enter to continue.."
read FOO

# Nuke 8 L1 boxes
echo "Deleting L1 boxes"
for i in {1..8}; do
  echo === ${i} ===
  knife aerosol guest delete cnn-ouzo-${PODNAME}-prod-l1-${i}.${DOMAIN} --nuke -y
  sleep 1
done
echo "... L1 boxes complete"

echo "Deleting L2 boxes"
# And Nuke 4 L2 boxes
for i in {1..4}; do
  echo === ${i} ===
  knife aerosol guest delete cnn-ouzo-${PODNAME}-prod-l2-${i}.${DOMAIN} --nuke -y
  sleep 1
done
echo "... L2 boxes complete"

echo "Pod deletion done for $PODNAME in $DOMAIN"
