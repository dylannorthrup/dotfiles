#!/bin/bash
PODNAME="$1"
OUZORECIPEVERSION="$2"

if [ -z $PODNAME ]; then
  echo "Usage: mkpod.sh <pod_name> <ouzo_recipe_version>"
  echo "Need to provide a podname. Exiting"
  exit
fi

if [ -z $OUZORECIPEVERSION ]; then
  echo "Usage: mkpod.sh <pod_name> <ouzo_recipe_version>"
  echo "Need to provide a specific version of the ouzo recipe. Exiting"
  exit
fi

echo -n "Beginning pod creation for $PODNAME with recipe version ${OUZORECIPEVERSION}. Press enter to continue.."
read FOO

echo "Creating L2 boxes"
# And create 4 L2 boxes
for i in {1..4}; do
  echo === ${i} ===
  spin-up -r "recipe[cnn-ouzo-wrapper@${OUZORECIPEVERSION}]" -s medium -n cnn-ouzo-${PODNAME}-prod-l2-${i}
  sleep 1
done
echo "... L2 boxes complete"

echo "Waiting 5 minutes for those to complete so the L1 boxes are able to espy for them"
sleep 300
echo "5 minutes is up!"
echo -n "Press enter to begin making the L1 boxes.."
read FOO

# Create 8 L1 boxes
echo "Creating L1 boxes"
for i in {1..8}; do
  echo === ${i} ===
  spin-up -r "recipe[cnn-ouzo-wrapper@${OUZORECIPEVERSION}]" -s medium -n cnn-ouzo-${PODNAME}-prod-l1-${i}
  sleep 1
done
echo "... L1 boxes complete"


echo "Pod creation done for $PODNAME"
