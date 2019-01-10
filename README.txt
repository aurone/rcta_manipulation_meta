Follow instructions at https://docs.docker.com/install/linux/docker-ce/ubuntu/
to install Docker CE.

RCTA_ROOT/
    docker/
    rce/
    rcta-indigo/
    rcta_installers/
    rcta_ws/

Instructions here for Docker setup:

https://roboticscta.seas.upenn.edu/confluence/display/rctasoftware/RFrame+Docker+Setup

Various Docker Configurations:

Ubuntu 16.04
(Optional) NVIDIA
(Optional) ROS Kinetic
if ROS Kinetic
    (Optional) RCE
    (Optional) RCTA Manipulation

[-] Ubuntu 16.04

[ ] Ubuntu 16.04 + ROS Kinetic
[x] Ubuntu 16.04 + ROS Kinetic + RCE

    The last I remember...this worked OK. Going to try now to see if I can bake
    in the additional dependencies that get installed by rce/build.sh via
    rce/build_tools/install_ros_deps.sh...as this takes forever on each docker
    setup.

[ ] Ubuntu 16.04 + ROS Kinetic + RCTA Manipulation
[ ] Ubuntu 16.04 + ROS Kinetic + RCE + RCTA Manipulation

[x] Ubuntu 16.04 + NVIDIA

[x] Ubuntu 16.04 + NVIDIA + ROS Kinetic

    This seems to work fine.

[x] Ubuntu 16.04 + NVIDIA + ROS Kinetic + RCE

    Failed to build RCE because of conflicting nvidia packages. The base image
    installs one version of various CUDA packages and the RCE requires versions
    used by PyTorch or something similar:

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

[x] Ubuntu 16.04 + NVIDIA + ROS Kinetic + RCTA Manipulation

    This also seems to work fine.

[ ] Ubuntu 16.04 + NVIDIA + ROS Kinetic + RCE + RCTA Manipulation

#    --env="DISPLAY" \
#    --env="QT_X11_NO_MITSHM=1" \
#    -e NVIDIA_VISIBLE_DEVICES=all \
#    -e NVIDIA_DRIVER_CAPABILITIES=video,compute,utility,graphics \
#    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#    --env="XAUTHORITY=$XAUTH" \
#    --volume="$XAUTH:$XAUTH" \
#    -v /tmp/.X11-unix:/tmp/.X11-unix \
# TODO: need to figure out why --network host kills graphics D:
#    --network host \
