#!/usr/bin/env bash
set -x

docker-compose up -d ubuntu-16.04
docker-compose up -d ubuntu-18.04
docker-compose up -d ubuntu-20.04
docker-compose up -d ubuntu-22.04
