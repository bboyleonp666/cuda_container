#!/bin/bash

# ITEM  | VERSION
# ----- | ----------
# OS    | Ubuntu 20.04 5
# GPU   | RTX 3080ti

sudo apt update

# install nvidia driver
sudo apt install nvidia-driver-515

# install docker
sudo apt install docker.io

# install nvidia-container
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker

# verify installation
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi