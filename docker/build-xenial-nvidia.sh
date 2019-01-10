#!/bin/bash
DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia
TAG=1.0
DOCKERFILE=Dockerfile-xenial-nvidia

docker build -t $DOCKERID/$CONTAINER:$TAG -f ./$DOCKERFILE $RCTA_ROOT
