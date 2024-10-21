#!/usr/bin/env bash
# set -x

function print_help() {
    echo "Usage:"
    echo "  $0"
    echo "  '-f': force update images"
    exit 1
}

function force_update() {
    docker rmi th3s/pwn-env:ubuntu-16.04
    docker rmi th3s/pwn-env:ubuntu-18.04
    docker rmi th3s/pwn-env:ubuntu-20.04
    docker rmi th3s/pwn-env:ubuntu-22.04
    docker rmi th3s/pwn-env:ubuntu-24.04
}

docker compose down

while getopts "fh" OPT; do
    case $OPT in
    f) force_update ;;
    h) print_help ;;
    esac
done

docker compose pull ubuntu-16.04
docker compose pull ubuntu-18.04
docker compose pull ubuntu-20.04
docker compose pull ubuntu-22.04
docker compose pull ubuntu-24.04
