#!/usr/bin/env bash
set -x

docker-compose -f docker-compose-dev.yml build ubuntu-16.04
docker-compose -f docker-compose-dev.yml build ubuntu-18.04
docker-compose -f docker-compose-dev.yml build ubuntu-20.04
docker-compose -f docker-compose-dev.yml build ubuntu-22.04