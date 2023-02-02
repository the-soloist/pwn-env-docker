#!/usr/bin/env bash
# set -x

if [ -z $TCPDUMP_ENABLE ]; then
    echo "Set TCPDUMP_ENABLE to enable packet capture."
    kill -9 $(pgrep tcpdump)
    exit 0
fi

if [ -z $TCPDUMP_DIR ]; then
    TCPDUMP_DIR="/var/lib/tcpdump"
fi

if [ ! -d $TCPDUMP_DIR ]; then
    mkdir -p $TCPDUMP_DIR
fi

if [ ! -z $TCPDUMP_PREMISSION ]; then
    chmod $TCPDUMP_PREMISSION $TCPDUMP_DIR
fi

if [ -z $TCPDUMP_ROTATE_SEC ]; then
    TCPDUMP_ROTATE_SEC=600
fi

if [ -z $TCPDUMP_FILENAME ]; then
    TCPDUMP_FILENAME="capture-%F-%H-%M-%S.pcap"
fi

if [ -z $CTF_PORT ]; then
    CTF_PORT=8888
fi

echo "TCPDUMP: capture port: $CTF_PORT, rotate interval: ${TCPDUMP_ROTATE_SEC}s, capture filename: capture-\$time.pcap"
exec /usr/sbin/tcpdump -Z root -i eth0 port $CTF_PORT -U -w $TCPDUMP_DIR/$TCPDUMP_FILENAME -G $TCPDUMP_ROTATE_SEC
