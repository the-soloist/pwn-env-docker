#!/bin/bash

# 定义常量
VERSION_LATEST="latest"

# 初始化版本信息
declare -A UBUNTU_1604
UBUNTU_1604[bindata]="2.4.14"
UBUNTU_1604[elftools]="$VERSION_LATEST"
UBUNTU_1604[one_gadget]="1.7.3"
UBUNTU_1604[seccomp_tools]="1.3.0"
UBUNTU_1604[pwndbg]="2022.01.05"

declare -A UBUNTU_1804
UBUNTU_1804[bindata]="$VERSION_LATEST"
UBUNTU_1804[elftools]="1.1.3"
UBUNTU_1804[one_gadget]="1.9.0"
UBUNTU_1804[seccomp_tools]="1.5.00"
UBUNTU_1804[pwndbg]="2022.08.30"

declare -A UBUNTU_2004
UBUNTU_2004[bindata]="$VERSION_LATEST"
UBUNTU_2004[elftools]="1.2.0"
UBUNTU_2004[one_gadget]="1.9.0"
UBUNTU_2004[seccomp_tools]="$VERSION_LATEST"
UBUNTU_2004[pwndbg]="2024.02.14"

declare -A UBUNTU_2204
UBUNTU_2204[bindata]="$VERSION_LATEST"
UBUNTU_2204[elftools]="$VERSION_LATEST"
UBUNTU_2204[one_gadget]="$VERSION_LATEST"
UBUNTU_2204[seccomp_tools]="$VERSION_LATEST"
UBUNTU_2204[pwndbg]="$VERSION_LATEST"

declare -A UBUNTU_2404
UBUNTU_2404[bindata]="$VERSION_LATEST"
UBUNTU_2404[elftools]="$VERSION_LATEST"
UBUNTU_2404[one_gadget]="$VERSION_LATEST"
UBUNTU_2404[seccomp_tools]="$VERSION_LATEST"
UBUNTU_2404[pwndbg]="$VERSION_LATEST"

# Gem安装函数
gem_install() {
    local name=$1
    local version=$2

    if [ "$version" = "$VERSION_LATEST" ]; then
        gem install "$name"
    else
        gem install "$name" -v "$version"
    fi
}

# 主函数
main() {
    local sys_version=$1
    local -n versions

    # 根据系统版本选择对应的版本信息
    case "$sys_version" in
    "ubuntu-16.04")
        versions=UBUNTU_1604
        ;;
    "ubuntu-18.04")
        versions=UBUNTU_1804
        ;;
    "ubuntu-20.04")
        versions=UBUNTU_2004
        ;;
    "ubuntu-22.04")
        versions=UBUNTU_2204
        ;;
    "ubuntu-24.04")
        versions=UBUNTU_2404
        ;;
    *)
        echo "Unsupported Ubuntu version: $sys_version"
        exit 1
        ;;
    esac

    # 设置gem源
    gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/

    # 安装工具
    gem_install "bindata" "${versions[bindata]}"
    gem_install "elftools" "${versions[elftools]}"
    gem_install "one_gadget" "${versions[one_gadget]}"
    gem_install "seccomp-tools" "${versions[seccomp_tools]}"

    # pwndbg
    pushd "/root/tools/gdb/plugins/pwndbg"
    git clone https://github.com/pwndbg/pwndbg
    if [ "${versions[pwndbg]}" != "$VERSION_LATEST" ]; then
        git checkout -f "${versions[pwndbg]}"
    fi
    ./setup.sh
    cp /root/tools/gdb/init/pwndbg.conf /root/.gdbinit
    popd
}

# 解析命令行参数
if [ $# -ne 2 ] || [ "$1" != "-v" ] && [ "$1" != "--version" ]; then
    echo "Usage: $0 -v|--version <ubuntu-version>"
    echo "Example: $0 -v ubuntu-22.04"
    exit 1
fi

main "$2"
