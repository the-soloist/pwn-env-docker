#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "Usage:  $0 <container-id> <shell-type>"
    echo "  e.g.: $0 <id> bash"

    echo -e "\n>>> docker ps"
    docker ps

    exit 1
fi

CONTAINER_ID="$1"
SHELL_TYPE="$2"

set -x

docker exec -it $CONTAINER_ID $SHELL_TYPE
