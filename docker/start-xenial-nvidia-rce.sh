#!/bin/bash

DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-rce
TAG=1.0

#XAUTH=/tmp/.docker.xauth
#if [ ! -f $XAUTH ]; then
#    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
#    if [ ! -z "$xauth_list" ]; then
#        echo $xauth_list | xauth -f $XAUTH nmerge -
#    else
#        touch $XAUTH
#    fi
#    chmod a+r $XAUTH
#fi

#    --runtime=nvidia \
#    --env="XAUTHORITY=$XAUTH" \
#    -v "$XAUTH:$XAUTH" \
nvidia-docker container run \
    --rm \
    -it \
    --privileged \
    --network host \
    --env="QT_X11_NO_MITSHM=1" \
    --env="DISPLAY=$DISPLAY" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$RCTA_ROOT/rce:/home/rcta/rce:rw" \
    -h $(hostname) \
    --name $CONTAINER \
    $DOCKERID/$CONTAINER:$TAG \
    bash
