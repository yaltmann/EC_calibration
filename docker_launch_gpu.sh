docker build -t e2calibGPU -f DockerfileGPU .
docker run -it --gpus "device=0" --mount type=bind,source="$(pwd)"/data,target=/workspace/data e2calibGPU
