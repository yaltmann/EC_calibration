docker build -t e2calibgpu -f DockerfileGPU .
docker run -it --gpus "device=0" --mount type=bind,source="$(pwd)"/data,target=/workspace/data e2calibgpu
#python e2calib/python/offline_reconstruction.py --h5file data/jupiter.h5 --width 1280 --height 720 --output_folder data/ --freq_hz 10 --use_gpu