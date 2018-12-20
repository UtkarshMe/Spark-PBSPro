#!/bin/sh

quit() {
  echo "$1"
  exit 1
}

cd ../../
sudo docker build -f resource-managers/pbs/Dockerfile .
