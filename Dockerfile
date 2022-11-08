FROM ros:melodic-ros-core

MAINTAINER "Javier Hidalgo-Carrio" <https://jhidalgocarrio.github.io>

RUN apt-get update && \
    apt-get upgrade -y


RUN apt install -y --no-install-recommends \
    sudo zsh vim build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev wget

RUN apt-get install -y ruby ruby-dev

RUN apt-get install -y libboost-all-dev

COPY install/metavision.list /etc/apt/sources.list.d
RUN apt update
RUN apt -y install metavision-sdk

# Create docker user
RUN adduser  --disabled-password --gecos -m docker && adduser docker sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV HOME /home/docker

USER docker

RUN mkdir /home/docker/dev

WORKDIR /home/docker/dev


RUN wget https://raw.githubusercontent.com/rock-core/autoproj/stable/bin/autoproj_bootstrap

RUN export AUTOPROJ_OSDEPS_MODE=all
RUN export AUTOPROJ_IGNORE_NONEMPTY_DIR=1
RUN echo "ID=ubuntu\nID_LIKE=ubuntu\nVERSION_ID=18.04\n" > os-release

RUN sudo mv os-release /etc

RUN sudo gem install utilrb

RUN export GEM_HOME=$HOME/.local/share/autoproj/gems/ruby/2.5.0
RUN export AUTOPROJ_OS=ubuntu,debian:18.04
RUN export SHELL=/bin/bash
ENV SHELL /bin/bash

RUN git config --global user.email "docker@example.com"
RUN git config --global user.name "docker"

RUN ruby autoproj_bootstrap git https://github.com/jhidalgocarrio/e2calib-buildconf.git push_to=git@github.com:jhidalgocarrio/e2calib-buildconf.git --no-interactive

SHELL ["/bin/bash", "-c"]

# Update and build rock
RUN source env.sh &&\
    autoproj update --no-interactive &&\
    autoproj build -k --no-interactive

# Build e2calib
WORKDIR /home/docker/dev/tools/e2calib

RUN source /home/docker/dev/env.sh &&\
    sudo apt install -y python3-tqdm python3-yaml python3-opencv 

RUN source /home/docker/dev/env.sh &&\
    pip3 install --no-cache-dir -r requirements.txt

RUN source /home/docker/dev/env.sh &&\
    pip3 install dataclasses # if your system Python version is < 3.7

RUN source /home/docker/dev/env.sh &&\
    pip3 install --extra-index-url https://rospypi.github.io/simple/ rospy rosbag

# CUSTOM ADDED ITEMS
RUN source /home/docker/dev/env.sh &&\
    pip3 install --upgrade pip

RUN source /home/docker/dev/env.sh &&\
    pip3 install h5py opencv-python tqdm torch torchvision scipy

RUN source /home/docker/dev/env.sh &&\
    pip3 install python/

WORKDIR /home/docker/dev

# Build pocolog_pybind
RUN source /home/docker/dev/env.sh &&\
    python3 -m pip install tools/pocolog_pybind

# Install catkin tools
RUN sudo apt-get install -y python-catkin-tools

# Install DVS ROS driver
RUN mkdir /home/docker/ros
RUN mkdir /home/docker/ros/src

WORKDIR /home/docker/ros

RUN catkin config --init --mkdirs --extend /opt/ros/melodic --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release

WORKDIR /home/docker/ros/src

RUN git clone https://github.com/uzh-rpg/rpg_dvs_ros.git

WORKDIR $HOME

RUN wget https://download.ifi.uzh.ch/rpg/e2calib/pocolog/e2calib_example.log --quiet -O /tmp/e2calib_example.log

# CHECK: log file content
RUN source /home/docker/dev/env.sh &&\
    pocolog /tmp/e2calib_example.log

# TEST: convert pocolog to rosbag
RUN source /home/docker/dev/env.sh &&\
    source /opt/ros/melodic/setup.bash &&\
    cd /home/docker/ros &&\
    catkin build dvs_msgs && cd $HOME &&\
    source /home/docker/ros/devel/setup.sh &&\
    python3 ~/dev/bundles/e2calib/scripts/pocolog/pocolog2rosbag.py \
    /tmp/e2calib_example.log -pe /camera_prophesee.events -te \
    /camera_prophesee/events -pimu /camera_prophesee.imu -timu /camera_prophesee/imu

# Check the generated rosbag
RUN source /opt/ros/melodic/setup.bash &&\
    rosbag info /tmp/e2calib_example.bag

# TEST: convert pocolog to h5
RUN ln -s /home/docker/dev/tools/e2calib/python/ /home/docker/dev/bundles/e2calib/scripts/convert
RUN source /home/docker/dev/env.sh &&\
    python3 /home/docker/dev/bundles/e2calib/scripts/convert/convert.py /tmp/e2calib_example.log --topic /camera_prophesee.events

# Attaching point
CMD /bin/bash


