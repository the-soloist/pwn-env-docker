#!/usr/bin/env bash

if [ $# -lt 0 ]; then
    echo "Usage:  $0 <container-id> [shell-type]"
    echo "  e.g.: $0 <id> bash"
    echo "  e.g.: $0 <id>  # 默认使用 bash"

    echo -e "\n>>> docker ps"
    docker ps

    exit 1
fi

CONTAINER_ID="$1"
SHELL_TYPE="${2:-bash}"

set -x

docker compose exec -it $CONTAINER_ID $SHELL_TYPE
