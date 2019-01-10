#!/bin/bash
DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-rce
TAG=1.0
DOCKERFILE=Dockerfile-xenial-nvidia-rce

docker build -t $DOCKERID/$CONTAINER:$TAG -f ./$DOCKERFILE $RCTA_ROOT
