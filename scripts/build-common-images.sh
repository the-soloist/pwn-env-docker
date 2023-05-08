#!/usr/bin/env bash
set -x

docker-compose build ubuntu-16.04
docker-compose build ubuntu-18.04
docker-compose build ubuntu-20.04
docker-compose build ubuntu-22.04
