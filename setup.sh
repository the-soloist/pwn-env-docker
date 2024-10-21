#!/usr/bin/env bash
# set -x

function sync-git-repo() {
    url="$1"
    path="$2"
    if [ -z "$path" ]; then
        path=$(basename "$url")
    fi

    echo ">>> sync '$url' -> '$path'"

    if [ -d "$path/.git" ]; then
        pushd "$path" >/dev/null || return 0
        git pull
        popd >/dev/null || return 0
    else
        git clone "$url" "$path"
    fi

    printf "\n"
}

### init ###

mkdir -p ./config/tmux/{plugins,themes}
mkdir -p ./deps/{tools,scripts,python-package}
mkdir -p ./docker/tools/gdb/plugins
mkdir -p ./share/tools
mkdir -p ./ssh
echo "REPLACE THIS FILE" >./ssh/authorized_keys

### download(private) ###

# @ gdb plugins
pushd ./docker/tools/gdb/plugins/ >/dev/null
[ -e "./gef.py" ] && rm ./gef.py
curl -C - https://raw.githubusercontent.com/hugsy/gef/master/gef.py -o gef.py
sync-git-repo https://github.com/pwndbg/pwndbg
sync-git-repo https://github.com/longld/peda
sync-git-repo https://github.com/scwuaptx/Pwngdb
popd

### download(shared) ###

# @ config/tmux
pushd ./config/tmux/plugins/ >/dev/null
sync-git-repo https://github.com/thewtex/tmux-mem-cpu-load
sync-git-repo https://github.com/tmux-plugins/tmux-prefix-highlight
sync-git-repo https://github.com/tmux-plugins/tmux-sensible
sync-git-repo https://github.com/tmux-plugins/tmux-sidebar
sync-git-repo https://github.com/tmux-plugins/tmux-yank
sync-git-repo https://github.com/tmux-plugins/tpm
popd >/dev/null

pushd ./config/tmux/themes/ >/dev/null
sync-git-repo https://github.com/dracula/tmux tmux-dracula
popd >/dev/null

# @ deps/python-package
pushd ./deps/python-package/ >/dev/null
sync-git-repo https://github.com/the-soloist/pwn-toolkit pwnkit
popd >/dev/null

# @ deps/tools
pushd ./deps/tools/ >/dev/null
sync-git-repo https://github.com/matrix1001/glibc-all-in-one
sync-git-repo https://github.com/niklasb/libc-database
sync-git-repo https://github.com/NixOS/patchelf
sync-git-repo https://github.com/Ex-Origin/debug-server
popd >/dev/null

# @ docker/tools
pushd ./docker/tools/ >/dev/null
sync-git-repo https://github.com/pyenv/pyenv
popd >/dev/null

### compile ###

# @ tmux-mem-cpu-load
echo ">>> compiling tmux-mem-cpu-load ..."
pushd ./config/tmux/plugins/tmux-mem-cpu-load >/dev/null
[ -e "./tmux-mem-cpu-load" ] && rm ./tmux-mem-cpu-load
cmake -DCMAKE_CXX_FLAGS="-static" .
make -j16
popd >/dev/null
printf "\n"
