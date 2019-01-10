#!/bin/bash

DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-rce
TAG=1.0

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]; then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

docker container run \
    --runtime=nvidia \
    --rm \
    -it \
    --env="XAUTHORITY=$XAUTH" \
    --env="DISPLAY=$DISPLAY" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$XAUTH:$XAUTH" \
    -v "$RCTA_ROOT/rce:/home/rcta/rce:rw" \
    -h $CONTAINER \
    --name $CONTAINER \
    $DOCKERID/$CONTAINER:$TAG \
    bash
