#!/usr/bin/env bash
set -x

docker-compose down
docker rmi th3s/pwn-env:ubuntu-16.04
docker rmi th3s/pwn-env:ubuntu-18.04
docker rmi th3s/pwn-env:ubuntu-20.04
docker rmi th3s/pwn-env:ubuntu-22.04
docker-compose pull
