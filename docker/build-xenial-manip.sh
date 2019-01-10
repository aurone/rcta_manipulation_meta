#!/bin/bash
DOCKERID=aurone
CONTAINER=rcta-xenial-manip
TAG=1.0
DOCKERFILE=Dockerfile-xenial-manip

docker build -t $DOCKERID/$CONTAINER:$TAG -f ./$DOCKERFILE $RCTA_ROOT
