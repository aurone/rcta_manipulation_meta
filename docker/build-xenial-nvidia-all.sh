#!/bin/bash
DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-all
TAG=1.0
DOCKERFILE=Dockerfile-xenial-nvidia-all

docker build -t $DOCKERID/$CONTAINER:$TAG -f ./$DOCKERFILE $RCTA_ROOT
