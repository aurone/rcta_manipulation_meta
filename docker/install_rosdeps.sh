#!/bin/bash
set -e
source /opt/ros/kinetic/setup.bash
sudo apt-get update
rosdep install -i -y -r --from-paths /home/rcta/rcta_ws/src
