#!/bin/sh

image_name=creativeprojects/webgrind
version=1.4.0

docker pull debian:jessie
docker rmi ${image_name}:latest
docker build -t ${image_name}:${version} -t ${image_name}:latest ./
docker push ${image_name}:${version}
docker push ${image_name}:latest
