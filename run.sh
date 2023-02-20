#!/bin/bash

# Basic Configuration
IMAGE=pyg-lightning
VERSION=1.0
EXPOSE_PORT=8888
WORKING_DIR=$(pwd)
NAME=pyg_pl

usage() {
    echo "To start the CUDA container with Jupyter"
    echo "  $ bash $0 [-r] [-s] [-c] [-t]"
    echo
    echo "    -r    To start the container"
    echo "    -s    To stop the container"
    echo "    -c    To stop and remove the container"
    echo "    -t    To obtain the Jupyter token for login"
}

start() {
    # Start the container
    docker run -d \
        --gpus all \
        -p $EXPOSE_PORT:8888 \
        -v $WORKING_DIR:/workspace/research \
        --name=$NAME \
        $IMAGE:$VERSION > /dev/null
}

stop() {
    docker container stop $NAME > /dev/null
    echo "Container '$NAME' stopped"
}

remove() {
    docker container rm $NAME > /dev/null
    echo "Container '$NAME' removed"
}

get_token() {
    TOKEN=$(docker logs $NAME 2> /dev/fd/1 1> /dev/null | grep 'token=' | head -n 1 | sed 's/.*token=//')
}

show_token() {
    get_token
    echo "Your jupyter token is: $TOKEN"
}

[[ $1 == '' ]] && usage && exit 0
while getopts "hrsct" argv; do
    case $argv in
        h )
            usage
            exit 0
            ;;

        r )
            start
            for i in $(seq 1 5); do
                get_token
                [[ ! $TOKEN == '' ]] && break
                sleep 1
            done
            show_token
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
            show_token
            exit 0
            ;;

        ? )
            echo 'Not a support option'
            usage
            exit 1
            ;;
    esac
done
