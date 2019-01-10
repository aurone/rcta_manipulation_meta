#!/bin/sh

DOCKERID=aurone
CONTAINER=rcta-xenial-manip
TAG=1.0

docker container run \
    --rm \
    -it \
    -v $RCTA_ROOT/rcta_ws:/home/rcta/rcta_ws:rw \
    -h $CONTAINER \
    --name $CONTAINER \
    $DOCKERID/$CONTAINER:$TAG \
    bash
