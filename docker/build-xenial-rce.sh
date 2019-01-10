#!/bin/bash
DOCKERID=aurone
CONTAINER=rcta-xenial-rce
TAG=1.0
DOCKERFILE=Dockerfile-xenial-rce

docker build -t $DOCKERID/$CONTAINER:$TAG -f ./$DOCKERFILE $RCTA_ROOT
