#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "  e.g.: $0 <id>"
    exit 1
fi

WORK_HOME="$(dirname $(realpath $0))"
PY_VERSION="3.8.16"

set -x

cd "$(dirname $WORK_HOME)/deps"

rm -rf Python-$PY_VERSION.tar.xz Python-$PY_VERSION python-$PY_VERSION

wget https://www.python.org/ftp/python/$PY_VERSION/Python-$PY_VERSION.tar.xz -O ./Python-$PY_VERSION.tar.xz
tar -xvf Python-$PY_VERSION.tar.xz
mv Python-$PY_VERSION python-$PY_VERSION

docker exec -it $1 bash -c \
    "cd /deps/python-$PY_VERSION && \
    ./configure --prefix=/opt/python-$PY_VERSION && \
    make -j16 && make install"

docker exec -it $1 bash -c "sed -i 's/python-package\"/&\nexport PATH=\"\/opt\/python-$PY_VERSION\/bin:\$PATH\"/' /root/.bashrc"

rm Python-$PY_VERSION.tar.xz
