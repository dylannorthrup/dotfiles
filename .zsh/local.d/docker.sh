## Docker stuff
# Lets you get a container ID based on grepping `docker ps` output
docker_id() {
  # For mjr, this is simpler than shoving the value into an awk variable
  # then testing that. Been there, done that, chose this way instead.
  docker ps | grep "$*" | awk '{print $1}'
}

debug_docker_build() {
  IMG_ID="${1}"
  docker commit ${1} tmpdebug
  docker run -ti --rm tmpdebug bash
  docker image rm tmpdebug
}

_maria_id() {
  docker ps | awk '/mariadb/ {print $1}'
}

db_start() {
  cd ~/repos/admin/server/local_dev/mariadb
  docker run -d -v ~/mariadb/datadir:/var/lib/mysql -p 3306:3306 tock_mariadb:latest
}

db_bash() {
  docker exec -it $(_maria_id) /bin/bash
}

db_stop() {
  docker stop $(_maria_id)
}

# If you're only running a single container, this works
dbash() {
  docker exec -it $(docker ps -q) /bin/bash
}

