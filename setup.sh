#!/usr/bin/env bash
set -x

# init
mkdir ./challenge
mkdir ./ssh
mkdir -p ./config/tmux/plugins
mkdir -p ./deps/python-package
mkdir -p ./docker/tools/gdb/plugins
echo "REPLACE THIS FILE" >./ssh/authorized_keys

# deps
pushd ./deps/python-package
git clone https://github.com/the-soloist/pwn-utils pwnutils
popd

# download gdb plugins
pushd ./docker/tools/gdb/plugins/
curl -C - https://raw.githubusercontent.com/hugsy/gef/master/gef.py -o gef.py
git clone https://github.com/pwndbg/pwndbg
git clone https://github.com/longld/peda
git clone https://github.com/scwuaptx/Pwngdb
popd

# download tmux plugins
pushd ./config/tmux/plugins/
git clone https://github.com/thewtex/tmux-mem-cpu-load
git clone https://github.com/tmux-plugins/tmux-prefix-highlight
git clone https://github.com/tmux-plugins/tmux-sensible
git clone https://github.com/tmux-plugins/tmux-sidebar
git clone https://github.com/tmux-plugins/tmux-yank
git clone https://github.com/tmux-plugins/tpm

cd tmux-mem-cpu-load
cmake .
make -j16
popd
