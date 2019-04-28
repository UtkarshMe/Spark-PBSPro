#!/bin/sh

image="spark-with-pbspro"
tag="nightly"

quit() {
  echo "$1"
  exit 1
}

# build image
cd ../../
sudo docker build -t $image:$tag -f resource-managers/pbs/Dockerfile . \
    || quit "Could not build docker image"

# push to docker hub
sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD \
    || quit "Could not login to docker"
sudo docker push $image:$tag \
    || quit "Could not push to docker hub"
