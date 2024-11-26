#!/usr/bin/env python
# -*- coding: utf-8 -*-
set -x

export PYENV_ROOT="/opt/pyenv"

curl https://pyenv.run | bash

apt update
apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev libssl-dev
