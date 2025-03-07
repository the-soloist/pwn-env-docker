#!/usr/bin/env python
# -*- coding: utf-8 -*-
set -x

function print_help() {
    echo "Usage:  $0 -p <python-version> -v <ubuntu-version>"
    echo "  e.g.: $0 -p 3.8.16 -v ubuntu-22.04"
    exit 1
}

while getopts "p:v:h" OPT; do
    case $OPT in
    p) PYTHON_VERSION="$OPTARG" ;;
    v) UBUNTU_VERSION="$OPTARG" ;;
    h) print_help ;;
    ?) print_help ;;
    esac
done

export PYENV_ROOT="/opt/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(command pyenv init -)"

pyenv shell $PYTHON_VERSION

cd "$(dirname "$0")"
python base.py -v "$UBUNTU_VERSION"
