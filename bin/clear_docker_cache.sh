#!/bin/bash

echo "Pruning all resources from stopped and unused images"
docker system prune -a
exit 

# This is what I used to do, but the above does everything I need
echo "Pruning containers"
docker container prune -f
echo "Pruningi images"
docker image prune -a -f
echo "Pruning volumes"
docker volume prune -f
