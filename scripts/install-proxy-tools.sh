#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "Usage:  $0 <container-id> <host> <port>"
    echo "  e.g.: $0 <id> 127.0.0.1 10808"
    exit 1
fi

WORK_HOME="$(dirname $(realpath $0))"
CONTAINER_ID="$1"
HOST="$2"
PORT="$2"

set -x

docker exec -it $CONTAINER_ID bash -c "apt-get update"
docker exec -it $CONTAINER_ID bash -c "apt-get install proxychains4"
docker exec -it $CONTAINER_ID bash -c "sed -i '/^socks4/csocks5 $HOST $PORT' /etc/proxychains4.conf"
