#!/bin/sh

# This script assumes:
# - spark connector is at resource-managers/pbs/ inside spark project root.
# - spark project is already compiled with pbs support.
# - DOCKER_USERNAME, DOCKER_PASSWORD environment variables are set.

image="spark-with-pbspro"
tag="nightly"

quit() {
  echo "$1"
  exit 1
}

# build image
# we go to the spark root to build image because we want the spark project files
# in the docker context while building.
cd ../../
sudo docker build -t $image:$tag -f resource-managers/pbs/Dockerfile . \
    || quit "Could not build docker image"

# push to docker hub
sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD \
    || quit "Could not login to docker"
sudo docker push $image:$tag \
    || quit "Could not push to docker hub"
