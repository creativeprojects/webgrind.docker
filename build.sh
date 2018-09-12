#!/bin/sh

image_name=creativeprojects/webgrind
version=1.5.0

cd $(dirname "${0}")

docker pull debian:stretch
docker pull ${image_name}:${version}
docker pull ${image_name}:latest
docker rmi ${image_name}:latest
docker build -t ${image_name}:${version} -t ${image_name}:latest ./
docker push ${image_name}:${version}
docker push ${image_name}:latest
