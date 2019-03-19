#!/bin/bash

DOCKERID=aurone
CONTAINER=rcta-xenial-nvidia-manip
TAG=1.0

WITH_ROBOT=0
while [ "$#" -ne "0" ]; do
    case $1 in
    "--robot") WITH_ROBOT=1;;
    esac
    shift
done

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
#
##    --runtime=nvidia \
#
#docker container run \
#    --runtime=nvidia \
#    --rm \
#    -it \
#    --user=$(id -u) \
#    --net host \
#    --env="QT_X11_NO_MITSHM=1" \
#    -v "/etc/group:/etc/group:ro" \
#    -v "/etc/passwd:/etc/passwd:ro" \
#    -v "/etc/shadow:/etc/shadow:ro" \
#    -v "/etc/sudoers.d:/etc/sudoers.d:ro" \
#    --env="ROS_MASTER_URI=\"http://tl1-1-am1:11311\"" \
#    --env="XAUTHORITY=$XAUTH" \
#    --env="DISPLAY=$DISPLAY" \
#    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#    -v "$XAUTH:$XAUTH" \
#    -v "$RCTA_ROOT/rcta_ws:/home/rcta/rcta_ws:rw" \
#    -h $(hostname) \
#    --name $CONTAINER \
#    $DOCKERID/$CONTAINER:$TAG \
#    bash

# Tried all the suggestions
#    --net host \
#    --user=$(id -u) \
#    -v "/etc/group:/etc/group:ro" \
#    -v "/etc/passwd:/etc/passwd:ro" \
#    -v "/etc/shadow:/etc/shadow:ro" \
#    -v "/etc/sudoers.d:/etc/sudoers.d:ro" \

if [ "$WITH_ROBOT" -eq 1 ]; then
    ROS_IP="$(echo -e `ip address | grep 172.16 | cut -f1 -d'/' | sed -e 's/^[[:space:]]*//' | cut -f2 -d' '`)"
    nvidia-docker container run \
        --rm \
        -it \
        --privileged \
        --network host \
        --env="QT_X11_NO_MITSHM=1" \
        --env="ROS_IP=$ROS_IP" \
        --env="ROS_MASTER_URI=http://tl1-1-am1:11311" \
        --env="DISPLAY=$DISPLAY" \
        -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v "$RCTA_ROOT/rcta_ws:/home/rcta/rcta_ws:rw" \
        -h $(hostname) \
        --name $CONTAINER \
        $DOCKERID/$CONTAINER:$TAG \
        bash
else
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
fi
