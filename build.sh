#!/bin/sh

image_name=creativeprojects/webgrind
version=1.4.0

docker pull debian:jessie
docker build -t ${image_name}:${version} ./
docker push ${image_name}:${version}
