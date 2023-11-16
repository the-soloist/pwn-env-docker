#!/bin/sh
set -x

cp ./xinetd.conf /etc/xinetd.d/xinetd
/etc/init.d/xinetd restart
