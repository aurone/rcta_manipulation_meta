#!/bin/bash

DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-all
TAG=1.0

nvidia-docker container run \
    --rm \
    -it \
    --privileged \
    --network host \
    --env="QT_X11_NO_MITSHM=1" \
    --env="DISPLAY=$DISPLAY" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$RCTA_ROOT/rcta_ws:/home/rcta/rcta_ws:rw" \
    -h $(hostname) \
    --name $CONTAINER \
    $DOCKERID/$CONTAINER:$TAG \
    bash
