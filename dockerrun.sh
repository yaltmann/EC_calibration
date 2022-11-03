docker build -t e2calib:main -f Dockerfile . 
docker run -it --mount type=bind,source=/home/craig/Github/e2calib/docker/data,target=/home/docker/data e2calib:main


