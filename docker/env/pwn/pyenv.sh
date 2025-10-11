#!/usr/bin/env python
# -*- coding: utf-8 -*-
set -x

function print_help() {
    echo "Usage:  $0 -p <python-version>"
    echo "  e.g.: $0 -p 3.8.16"
    exit 1
}

while getopts "p:h" OPT; do
    case $OPT in
    p) PY_VERSION="$OPTARG" ;;
    h) print_help ;;
    ?) print_help ;;
    esac
done

export PYENV_ROOT="/opt/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(command pyenv init -)"

pyenv shell $PY_VERSION

if [[ $? -ne 0 ]]; then
    echo "errors in 'pyenv shell $PY_VERSION'"
    exit 1
fi

pip3 install pip setuptools wheel --upgrade || exit -1
pip3 install rich prettytable colorama loguru tqdm termcolor tabulate || exit -1
pip3 install ipdb ipython websocket-client psutil requests redis || exit -1
pip3 install gmpy2 pycryptodome || exit -1
pip3 install z3-solver angr pwntools winpwn || exit -1
pip3 install pybase62 base58 base91 pybase100 || exit -1
