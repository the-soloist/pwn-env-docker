#!/usr/bin/env python
# -*- coding: utf-8 -*-
set -x

### init ###

gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/

### install ###

function gem_install() {
    _name="$1"
    _version="$2"
    if [[ "$_version" = "-1" ]]; then
        gem install $_name
    else
        gem install $_name -v $_version
    fi
}

# bindata
if [[ ! -z "$BINDATA_VER" ]]; then
    echo "install bindata $BINDATA_VER ..."
    gem_install bindata $BINDATA_VER
fi

# elftools
if [[ ! -z "$ELFTOOLS_VER" ]]; then
    echo "install elftools $ELFTOOLS_VER ..."
    gem_install elftools $ELFTOOLS_VER
fi

# one_gadget
if [[ ! -z "$ONE_GADGET_VER" ]]; then
    echo "install one_gadget $ONE_GADGET_VER ..."
    gem_install one_gadget $ONE_GADGET_VER
fi

# seccomp-tools
if [[ ! -z "$SECCOMP_TOOLS_VER" ]]; then
    echo "install seccomp-tools $SECCOMP_TOOLS_VER ..."
    gem_install seccomp-tools $SECCOMP_TOOLS_VER
fi

# pwndbg
if [[ ! -z "$PWNDBG_VER" ]]; then
    echo "install pwndbg $PWNDBG_VER ..."
    pushd /root/tools/gdb/plugins/pwndbg
    if [[ "$PWNDBG_VER" != "-1" ]]; then
        git checkout -f $PWNDBG_VER
    fi
    ./setup.sh
    cp /root/tools/gdb/init/pwndbg.conf /root/.gdbinit
    popd
fi
