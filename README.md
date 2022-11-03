# e2calib_docker

## Requirements

The following packahes are required in order to run the docker container:
* [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)

## Getting Started
This repository has been created and tested using Ubuntu 18.04, ROS Melodic, Docker Version 20.10.17.

1. Clone the repo to a folder on the host machine.
2. Build the Docker Container. Substitute `[image-tag]` with a memorable tag
```
cd path/to/docker/file
docker build -t [image-tag] . 
```

3. Launch the docker container using the docker_launch.sh file


## Using the container

Once the container is opening the following command must be run
```
source /home/docker/dev/env.sh
```

To convert a rosbag to a h5 file the following command can be run from the top directory. We suggest placing all data into the data folder provided in the repository:
```
 python3 /home/docker/dev/bundles/e2calib/scripts/convert/convert.py data/<bagfile> --topic /prophesee/camera/cd_events_buffer
```

To extract the calibration images from the h5 file the following command can be run for the top directory:
```
python3 dev/tools/e2calib/python/offline_reconstruction.py --h5file data/<h5file> - -freq_hz 10 --output_folder data/<location> --height 360 --width 480
```
