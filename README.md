# Overview

This repository is meant to automate/document how to set up reasonable
development environments for working with/without the RCTA Manipulation
stack and with/without the RCTA Collaborative Environment (RCE).

# Directory structure

You'll need to set up the following directory structure for this to work:

```
RCTA_ROOT/
    docker/
    rce/
    rcta_installers/
    rcta_ws/
```

where RCTA_ROOT is the path to this repository and RCTA_ROOT is in your
environment so the docker build scripts can reference it.

The docker directory contains several dockerfiles for different development
environment configurations. The rce and rcta_installers directories correspond
to the same repsoitories available from Bitbucket. The rcta_ws directory is an
isolated catkin workspace that will contain the rcta_manipulation stack (you
need to create this and pull in all the source packages it needs as if you were
working only with [RCTA Manipulation](https://github.com/aurone/rcta_manipulation)).

The names of the directories are relevant, as the provided docker build and run
scripts will mount them to build the images and during development.

# Docker Installation

Follow instructions at https://docs.docker.com/install/linux/docker-ce/ubuntu/
to install Docker CE. Note that a more recent version than the one installed by
a package manager may be required to run with NVIDIA Docker.

Instructions here for Docker setup:

    https://roboticscta.seas.upenn.edu/confluence/display/rctasoftware/RFrame+Docker+Setup

# Additional Requirements

It's unclear what version of CMake is actually required to build the RCE. The
Confluence page lists 3.5 as the minimum required version, but I saw errors
that said 3.13 was required. The Docker build scripts will assume a tarball
for CMake 3.13 (cmake-3.13.2-Linux-x86_64.tar.gz) exists in $RCTA_ROOT.

TODO: So I thought CMake 3.13 was being used, but the PATH variable wasn't set
right and rce built fine using the system install of CMake on xenial...maybe
this _can_ be removed.

Cloning the RCE requires Git LFS (and git-subrepo?)

# Docker Configurations:

All Docker images are based off of some version of the Ubuntu 16.04 (xenial)
Linux distribution. On top of the xenial distribution, the image may contain
additional packages for (1) NVIDIA configuration to be used by nvidia docker,
(2) third-party dependencies used by packages in the RCE, or (3) third-party
dependencies for the RCTA Manipulation stack. All images contain the Kinetic
distribution of ROS.

For NVIDIA configurations, 2.0 is the targeted version of NVIDIA Docker.

# Outstanding Issues

## Ubuntu + RCE

The last I remember...this worked OK. Going to try now to see if I can bake in
the additional dependencies that get installed by rce/build.sh via
rce/build_tools/install_ros_deps.sh...as this takes forever on each docker
setup.

## Ubuntu + RCTA Manipulation

Works fine.

## Ubuntu + RCE + RCTA Manipulation

Tested this with a bit of manual setup:

(1) Modify the start-xenial-rce.sh script to mount rcta_ws into the home directory

(2) Install some missing dependencies: libqwt-dev, ros-kinetic-soem,
    ros-kinetic-socketcan-interface

  I'm not sure if all of these are required. libqwt-dev probably is, the other
  two might be depenencies on some local things I have in rcta_ws that aren't
  required to build the RCTA Manipulation stack.

(3) Install sbpl into the home directory within the container

      git clone https://github.com/sbpl/sbpl && cd sbpl && mkdir build && \
          mkdir install && cd build && cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/home/rcta/sbpl/install && make && make install

(4) Install libgoogleperftools-dev. A custom version of this already exists on
    the system that the rcta_ws build doesn't find. Hopefully not screwing too
    much else up by installing the dist-level version.

(5) Build the rcta_ws workspace, which extends /home/rcta/rce, and uses the
    custom (,system dep version of) sbpl

    sbpl_DIR=/home/rcta/sbpl/install catkin build --cmake-args -DSMPL_MOVEIT_INTERFACE_QT5=ON

## Ubuntu + NVIDIA + RCE

Failed to build RCE because of conflicting nvidia packages. The base image
installs one version of various CUDA packages and the RCE requires versions
used by PyTorch or something similar:

```sh
Errors were encountered while processing:
 nvidia-410
 nvidia-410-dev
 libcuda1-410
 nvidia-opencl-icd-410
 cuda-drivers
 cuda-runtime-9-2
 cuda-demo-suite-9-2
 cuda-9-2
 ros-kinetic-cudnn-9-2
 ros-kinetic-pytorch
E: Sub-process /usr/bin/dpkg returned an error code (1)
ERROR: the following rosdeps failed to install
  apt: command [sudo -H apt-get install -y ros-kinetic-nmea-navsat-driver] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-multimaster-launch] failed
  apt: Failed to detect successful installation of [ros-kinetic-nmea-navsat-driver]
  apt: Failed to detect successful installation of [ros-kinetic-multimaster-launch]
  apt: command [sudo -H apt-get install -y ros-kinetic-pytorch] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-octomap-ros] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-gazebo-plugins] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-g2o] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-laser-assembler] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-imu-filter-madgwick] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-gazebo-ros-control] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-joint-trajectory-controller] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-ros-controllers] failed
  apt: command [sudo -H apt-get install -y python-pyside] failed
  apt: command [sudo -H apt-get install -y libpyside-dev] failed
  apt: command [sudo -H apt-get install -y libshiboken-dev] failed
  apt: command [sudo -H apt-get install -y shiboken] failed
  apt: command [sudo -H apt-get install -y python-qt4] failed
  apt: command [sudo -H apt-get install -y python-qt4-dev] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-interactive-marker-twist-server] failed
  apt: command [sudo -H apt-get install -y ros-kinetic-hector-mapping] failed
  apt: Failed to detect successful installation of [ros-kinetic-pytorch]
```

## Ubuntu + NVIDIA + RCTA Manipulation

Works fine.

## Ubuntu + NVIDIA + RCE + RCTA_MANIPULATION

TODO

# Reference for some docker container run arguments that may be required for NVIDIA Docker configurations

```sh
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -e NVIDIA_DRIVER_CAPABILITIES=video,compute,utility,graphics \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
 TODO: need to figure out why --network host kills graphics D:
    --network host \
```

# TODO

Worth using git submodules/subtrees/subrepos to mark compatible versions of RCE
and RCTA Manipulation?

Include building PERCH
