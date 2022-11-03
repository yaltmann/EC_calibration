docker build -t e2calib:main -f Dockerfile . 
docker run -it --mount type=bind,source="$(pwd)"/data,target=/home/docker/data e2calib:main


