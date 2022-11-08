# e2calib_docker
This repository contains the required files to create a docker container for the e2calib pipeline detailed in [How to Calibrate Your Event Camera](http://rpg.ifi.uzh.ch/docs/CVPRW21_Muglikar.pdf). All depenedencies are handled with the Dockerfile, as such the pipeline is ready to run out of the box with very little configuration needed. 

Please remember to site the original source of this work: 

[Manasi Muglikar](https://manasi94.github.io/), [Mathias Gehrig](https://magehrig.github.io/), [Daniel Gehrig](https://danielgehrig18.github.io/), [Davide Scaramuzza](http://rpg.ifi.uzh.ch/people_scaramuzza.html), "How to Calibrate Your Event Camera", Computer Vision and Pattern Recognition Workshops (CVPRW), 2021

```bibtex
@InProceedings{Muglikar2021CVPR,
  author = {Manasi Muglikar and Mathias Gehrig and Daniel Gehrig and Davide Scaramuzza},
  title = {How to Calibrate Your Event Camera},
  booktitle = {{IEEE} Conf. Comput. Vis. Pattern Recog. Workshops (CVPRW)},
  month = {June},
  year = {2021}
}
```

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

3. Run the docker image. Substitute `[image-tag]` with the same tag used in step 2 and `[container-name]` with a memorable name. (This command worked during testing but more experienced users may wish to modify it)
```
docker run -it --mount type=bind,source="$(pwd)"/data,target=/home/docker/data [image-tag]
```
Steps 3 and 4 have been include in the 'docker_launch.sh' file. This is to speed up the build and run process if modifications are needed.

NOTE: The basic image takes a significant amount of time to build. An alternative image is provided that offers several benefits but also some drawbacks.
The dokcer_launch_gpu.sh script will launch an alternative version of the container built upon the pytorch image. This image offers GPU support but cannot convert files from raw. Files created are also initially given root permissions but this can currently be fixed by running the rrperms.sh script with the user name as input.

## Using the "basic" container

Once the container is opening the following command must be run:
```
source /home/docker/dev/env.sh
```

To convert a rosbag to a h5 file the following command can be run from the top directory. We suggest placing all data into the data folder provided in the repository:
```
 python3 /home/docker/dev/bundles/e2calib/scripts/convert/convert.py data/[bagfile] --topic /prophesee/camera/cd_events_buffer
```

To extract the calibration images from the h5 file the following command can be run for the top directory:
```
python3 dev/tools/e2calib/python/offline_reconstruction.py --h5file data/[h5file] --freq_hz 10 --output_folder data/<location> --height [heigh] --width [width] 
```

## Using the GPU container

Unlike the basic container we do not need to source an environment and can instead run the necessary files straight away.

To convert a rosbag to a h5 file the following command can be run from the top directory. We suggest placing all data into the data folder provided in the repository:
```
 python /e2calib/python/convert.py data/[bagfile] --topic /prophesee/camera/cd_events_buffer
```
To extract the calibration images from the h5 file the following command can be run for the top directory:
```
python e2calib/python/offline_reconstruction.py --h5file data/[h5file] --freq_hz 10 --output_folder data/<location> --height [heigh] --width [width] --use_gpu
```
Note: Unlike the basic container we require the --use_gpu argument to be passed otherwise it will run on the CPU.