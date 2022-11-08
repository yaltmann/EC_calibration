# INSTALL PROCESS FOR RUNNING ON HOST MACHINE.

1. REMOVE ALL NVIDIA AND CUDA PASSED PACKAGES WITH sudo. 
```
sudo apt clean
sudo apt update
sudo apt purge cuda
sudo apt purge nvidia-*
sudo apt autoremove
sudo apt install cuda
```

2. INSTALL CUDA [HERE](https://developer.nvidia.com/cuda-downloads)

```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu1804-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu1804-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
```

3. PERFORM POST INSTALL ACTIONS [HERE](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
```
export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}
```
4. RESTART MACHINE

5. SETUP CONDA [HERE](https://pytorch.org/get-started/locally/)
```
conda create -y -n e2calib
conda activate e2calib
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
conda install -y -c conda-forge h5py opencv tqdm
conda install -y scipy
```
6. INSTALL e2vid
```
pip install python/
```