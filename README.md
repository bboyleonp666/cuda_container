# Docker installation

## Requirement
OS: Ubuntu 20.04  
GPU: RTX 3080ti

## Installation
This repository is the installer of docker and nvidia-container for Ubuntu 20.04.  
In order to create a container environment for CUDA support in deep learning.  
```
bash setup_cuda_container.sh
```

Reference:  
- [installation guide](https://medium.com/%E5%B7%A5%E7%A8%8B%E9%9A%A8%E5%AF%AB%E7%AD%86%E8%A8%98/docker-%E5%BB%BA%E7%AB%8B-cuda-%E5%8F%8A-cudnn-%E7%92%B0%E5%A2%83-2d0684b16df3)
- [docker offical](https://docs.docker.com/engine/install/ubuntu/)
- [nvidia offical](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

To test the GPU support
```
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

**Note:** If you would like to make your current user running `docker` command without `sudo`
```
sudo usermod -aG docker $(whoami)
// sudo reboot 0
```
Some system need to reboot to get the configuration take effect.

## Quick Start
To start a container for jupyter lab with conda installed, I personally recommend use [iot-salzburg/gpu-jupyter](https://github.com/iot-salzburg/gpu-jupyter) container images.  
If you do not care about the details, simply modify the following command according to your need.
```
docker run --gpus all -d -it -p <port>:8888 -v $(pwd)/<directory>:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE=yes --user root cschranz/gpu-jupyter:v1.4_cuda-11.2_ubuntu-20.04_python-only
```

For example, I have a directory named `work` under my current working directory, then I can mount it to my container.  
Since jupyter lab is a web service, so you can map the port to your host by modifying `<port>`.  
If you are opening the service in remote machine, you can forward the port using ssh.
```
ssh -NfL <local port>:localhost:<remote port> <username>@<ip address>
```
And open your browser with url `localhost:<port>`


**Example:**
```
# On remote machine
user@remote_machine ~$ ls -F    # mydir/
user@remote_machine ~$ docker run --docker run --gpus all -d -it -p 9999:8888 -v $(pwd)/mydir:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE=yes --user root cschranz/gpu-jupyter:v1.4_cuda-11.2_ubuntu-20.04_python-only

# On local machine
local_user@local_machine ~$ ssh -NfL 10000:localhost:9999 user@<IP>
# Open browser with URL: localhost:10000
```

![demo](imgs/jupyter_lab_demo.png)

