#!/usr/bin/env bash

# local proxy
socks_proxy="socks5://172.17.0.1:10810"
http_proxy="socks5://172.17.0.1:10810"

function proxy_off() {
    unset NO_PROXY
    unset ALL_PROXY
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset FTP_PROXY
    unset RSYNC_PROXY

    echo "[PROXY] proxy off"
}

function proxy_on() {
    export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
    export ALL_PROXY=$socks_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export FTP_PROXY=$socks_proxy
    export RSYNC_PROXY=$socks_proxy

    echo "[PROXY] proxy on"
}

COMMAND=$*
echo -e "[PROXY] $COMMAND"

proxy_on
echo " "

bash -c "$COMMAND"

echo " "
proxy_off
