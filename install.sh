#!/bin/bash

# ITEM  | VERSION
# ----- | ----------
# OS    | Ubuntu 20.04 5
# GPU   | RTX 3080ti

sudo apt update

# install nvidia driver
## sudo lshw -C display
if [[ $1 != '' ]]; then
    if [[ $1 =~ 'nvidia-driver-'.+ ]]; then
        sudo apt install $1
    else
        echo "The format of nvidia driver must be 'nvidia-driver-*'"
        exit 1
    fi
else
    if [[ $(grep 'NAME="Ubuntu"' /etc/os-release) ]]; then
        drivers=$(sudo ubuntu-drivers devices)
        ver=$(echo "$drivers" | grep recommended | cut -d '-' -f 3)

        echo ''
        echo '$ sudo ubuntu-drivers devices'
        echo ''
        echo "$drivers"
        echo ''
        echo 'Install recommended version?'
        echo "  $ sudo apt install nvidia-drivers-$ver"
        read -p '[yes|no|skip] ' install_check
        while [[ $install_check != 'yes' ]] && [[ $install_check != 'no' ]] && [[ $install_check != 'skip' ]]; do
            read -p '[yes|no|skip] ' install_check
        done
        
        [[ $install_check == 'yes' ]] && sudo apt install nvidia-drivers-$ver
        [[ $install_check == 'no' ]] && echo 'Nvidia driver must be pre-install for GPU support' && exit 0
        [[ $install_check == 'skip' ]] && echo "Skip ..."

    elif [[ $1 == '' ]]; then
            echo 'Your OS is not Ubuntu, please provide the nvidia driver version'
            echo 'Ex:'
            echo "    bash $0 nvidia-driver-515"
            exit 0

    fi
fi

# install docker
sudo apt install docker.io

# install nvidia-container
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker

# verify installation
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi