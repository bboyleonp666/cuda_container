#!/bin/bash

IMAGE=pyg-lightning
VERSION=1.0
DOCKERFILE=Dockerfile

docker build -t $IMAGE:$VERSION -f $DOCKERFILE .