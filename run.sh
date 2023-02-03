#!/bin/bash

# Basic Configuration
VERSION=gpu-jupyter:v1.4_cuda-11.6_ubuntu-20.04_python-only
PORT=8888
MOUNT_DIR=$(pwd)
NAME=CUDA_JUPYTER

usage() {
    echo "To start the CUDA container with Jupyter"
    echo "  $ bash $0 [-s] [-c]"
    echo
    echo "    <no option>  To start the container"
    echo "    -s           To stop the container"
    echo "    -c           To stop and remove the container"
    echo "    -t           To obtain the Jupyter token for login"
}

start() {
    # Start the container
    sudo docker run -d \
        --gpus all \
        -p $PORT:8888 \
        -v $MOUNT_DIR:/home/jovyan/work \
        -e GRANT_SUDO=yes \
        -e JUPYTER_ENABLE=yes \
        --user root \
        --name=$NAME \
        cschranz/$VERSION > /dev/null
}

stop() {
    sudo docker container stop $NAME > /dev/null
    echo "Container '$NAME' stopped"
}

remove() {
    sudo docker container rm $NAME > /dev/null
    echo "Container '$NAME' removed"
}

get_token() {
    TOKEN=$(sudo docker logs $NAME 2> >(grep token=) > head -n 1 | sed 's/.*token=//')
}

token() {
    get_token
    echo "Your jupyter token is: $TOKEN"
}

# if no option given, start the container
if [[ $1 == '' ]]; then
    start
    while [[ -z ${TOKEN+x} ]]; do
        get_token
        sleep 1
    done
    token
    exit 0
fi

# if option is given, execute the option
while getopts "hsct" argv; do
    case $argv in
        h )
            usage
            exit 0
            ;;

        s )
            stop
            exit 0
            ;;

        c )
            stop
            remove
            exit 0
            ;;

        t )
            token
            exit 0
            ;;

        ? )
            echo 'Not a support option'
            usage
            exit 1
            ;;
    esac
done
