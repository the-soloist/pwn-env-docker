#!/usr/bin/env bash
# set -x

function sync-git-repo() {
    url="$1"
    path="$2"
    if [ -z "$path" ]; then
        path=$(basename "$url")
    fi

    echo "sync '$url' -> '$path'"

    if [ -d "$path/.git" ]; then
        pushd "$path" >/dev/null || return 0
        git pull
        popd >/dev/null || return 0
    else
        git clone "$url" "$path"
    fi

    printf "\n"
}

# init
mkdir ./ssh
mkdir -p ./config/tmux/plugins
mkdir -p ./deps/python-package
mkdir -p ./docker/tools/gdb/plugins
echo "REPLACE THIS FILE" >./ssh/authorized_keys

# download python package
pushd ./deps/python-package >/dev/null
sync-git-repo https://github.com/the-soloist/pwn-toolkit pwnkit
popd >/dev/null

# download tools
pushd ./docker/tools/ >/dev/null
sync-git-repo https://github.com/matrix1001/glibc-all-in-one
sync-git-repo https://github.com/niklasb/libc-database
sync-git-repo https://github.com/NixOS/patchelf
popd >/dev/null

# download gdb plugins
pushd ./docker/tools/gdb/plugins/ >/dev/null
curl -C - https://raw.githubusercontent.com/hugsy/gef/master/gef.py -o gef.py
sync-git-repo https://github.com/pwndbg/pwndbg
sync-git-repo https://github.com/longld/peda
sync-git-repo https://github.com/scwuaptx/Pwngdb
popd

# download tmux plugins
pushd ./config/tmux/plugins/ >/dev/null
sync-git-repo https://github.com/thewtex/tmux-mem-cpu-load
sync-git-repo https://github.com/tmux-plugins/tmux-prefix-highlight
sync-git-repo https://github.com/tmux-plugins/tmux-sensible
sync-git-repo https://github.com/tmux-plugins/tmux-sidebar
sync-git-repo https://github.com/tmux-plugins/tmux-yank
sync-git-repo https://github.com/tmux-plugins/tpm

cd tmux-mem-cpu-load
cmake .
make -j16
popd >/dev/null
