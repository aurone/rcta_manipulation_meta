# Overview

This is a meta-repository that provides a stable development environment for
building and deploying the RCTA Manipulation stack, with and without the RCTA
Collaborative Environment (RCE), using docker.

# Getting Started

0. Install Docker and NVIDIA Docker

These instructions are known to work with Docker 18.06.1-ce and NVIDIA Docker
1.0. You may want to follow the additional instructions for using docker without
invoking root privileges.

1. Clone this repository

```sh
git clone https://github.com/aurone/rcta_manipulation_meta
```

2. Set the RCTA_ROOT environment variable

Set this environment variable to the path to this repository. The build and run
scripts will use this environment variable to denote the docker context and
the volume to mount for development.

3. Create the catkin workspace for RCTA Manipulation

Create the following directory structure to house the catkin workspace:

```
RCTA_ROOT/
  rcta_ws/
    src/
```

4. Clone the RCTA Manipulation stack and its source dependencies:

```sh
cd $RCTA_ROOT/rcta_ws/src
wstool init
git clone https://github.com/aurone/rcta_manipulation
wstool merge rcta_manipulation/rcta.rosinstall
wstool update
```

The `wstool` command is used to track the locations and versions of required
source dependencies. At this point, you have enough to build the development
environment for the standalone RCTA Manipulation stack.

5. Optionally, clone the RCE and its external dependencies

Instructions for cloning the RCE are not provided here, but the directory
structure in RCTA_ROOT should look like this:

```
RCTA_ROOT/
    docker/
    rce/
    rcta_installers/
    rcta_ws/
```

6. Build the docker environment

The docker directory contains several Dockerfiles for different development
environments. In the docker directory, scripts of the form build-* each build a
different environment. The name of the script determines whether the environment
is setup to use NVIDIA Docker (for OpenGL applications), whether the RCTA
Manipulation stack is included, and whether the RCE is included. For example,
running

```sh
./build-xenial-nvidia-manip.sh
```

will build an environment with NVIDIA extensions and the RCTA Manipulation stack.

The scripts of the form start-* create the corresponding container running an
interactive bash shell. For example, running

```
./start-xenial-nvidia-manip.sh
```

will create a bash shell in the corresponding container, under the `rcta` user,
ready for development.

# Docker Installation

Follow instructions at https://docs.docker.com/install/linux/docker-ce/ubuntu/
to install Docker CE. Note that a more recent version than the one installed by
a package manager may be required to run with NVIDIA Docker.

The RCE also provides docker environments. Instructions here for Docker setup:

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

Working.

## Ubuntu + RCTA Manipulation

Working.

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

This may no longer be an issue since reverting to NVIDIA Docker 1, though it
needs to be tested exactly which packages are required with NVIDIA Docker 1 to
use OpenGL functionality.

## Ubuntu + NVIDIA + RCTA Manipulation

Works fine.

## Ubuntu + NVIDIA + RCE + RCTA_MANIPULATION

TODO

# TODO

Worth using git submodules/subtrees/subrepos to mark compatible versions of RCE
and RCTA Manipulation?

Include building PERCH
