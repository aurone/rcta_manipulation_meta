#!/bin/bash
DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-manip
TAG=1.0
DOCKERFILE=Dockerfile-xenial-nvidia-manip

docker build -t $DOCKERID/$CONTAINER:$TAG -f ./$DOCKERFILE $RCTA_ROOT
