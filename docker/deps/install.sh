#!/usr/bin/env python
# -*- coding: utf-8 -*-

function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; } # greater or equal
function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }  # greater
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$1"; }  # less or equal
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; } # less

PY_VERSION=$(python -V 2>&1 | awk '{print $2}')

set -x

if version_gt $PY_VERSION "3.5"; then
    python3 -m pip install base45
fi

python3 -m pip install base58 pybase62 base91 pybase100
