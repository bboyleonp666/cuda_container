#!/bin/bash

# Basic Configuration
VERSION=gpu-jupyter:v1.4_cuda-11.6_ubuntu-20.04_python-only
PORT=8888
MOUNT_DIR=$(pwd)
NAME=CUDA_JUPYTER

# Start the container
sudo docker run \
    --gpus all \
    -p $PORT:8888 \
    -v $MOUNT_DIR:/home/jovyan/work \
    -e GRANT_SUDO=yes \
    -e JUPYTER_ENABLE=yes \
    --user root \
    --name=$NAME \
    cschranz/$VERSION