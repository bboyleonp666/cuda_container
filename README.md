# Pytorch Docker Container Controller
This is a repository for pytorch with GPU Support using CUDA.  
It supports
1. PyTorch
1. PyTorch-Geometric
1. PyTorch-Lightning
1. Mlflow
1. Gensim

## Environment
- OS: Ubuntu 20.04  
- GPU: RTX 3080ti
> Verified OS versions: Ubuntu 20.04, 22.04

## Installation
### Install Docker
This repository uses nvidia container for Ubuntu OS.  
In order to create a container environment for CUDA support.  
```
bash install.sh [nvidia-driver-version]
```
> **Note:** Be very careful when installing nvidia driver, since it modifies the driver setting.

Reference:  
- [installation guide](https://medium.com/%E5%B7%A5%E7%A8%8B%E9%9A%A8%E5%AF%AB%E7%AD%86%E8%A8%98/docker-%E5%BB%BA%E7%AB%8B-cuda-%E5%8F%8A-cudnn-%E7%92%B0%E5%A2%83-2d0684b16df3)
- [docker offical](https://docs.docker.com/engine/install/ubuntu/)
- [nvidia offical](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

To test the GPU support
```
bash test_gpu.sh
```
You should see output like below if your installation works correctly.
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 515.86.01    Driver Version: 515.86.01    CUDA Version: 11.7     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0 Off |                  N/A |
|  0%   35C    P8    25W / 400W |  10980MiB / 12288MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```

**Note:** If you would like to make your current user running `docker` command without `sudo`
```
sudo usermod -aG docker $(whoami)
newgrp docker
```
### Build Docker Image
Modify `Dockerfile` accroding to your need and run `bash build.sh` to build the docker image for the environment.

## Quick Start
1. Modify the configuration in `run.sh`
```
# docker image name
IMAGE=pyg-lightning

# docker image version
VERSION=1.0

# exposed port
PORT=8888

# mounting directory
MOUNT_DIR=$(pwd)

# name of the container
NAME=pyg_pl
```
2. Start your container
```
To start the CUDA container with Jupyter
  $ bash run.sh [-h] [-r] [-s] [-c] [-t]

    -h    Show help and exit
    -r    To start the container
    -s    To stop the container
    -c    To stop and remove the container
    -t    To obtain the Jupyter token for login
```

If you are opening the service in remote machine, you can forward the port using ssh.
```
ssh -NfL <local port>:localhost:<remote port> <username>@<ip address>
```
And open your browser with url `localhost:<port>`


**Example:**
```
# On remote machine
user@remote_machine ~$ cd my_dir
user@remote_machine ~/my_dir$ bash <cuda_container>/run.sh -r # suppose port exposed on 8888

# On local machine
local_user@local_machine ~$ ssh -NfL 10000:localhost:8888 user@<IP>
# Open browser with URL: localhost:10000
```

![demo](imgs/jupyter_lab_demo.png)

