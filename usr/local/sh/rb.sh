#!/bin/bash
. /etc/profile
echo 0 0 > /usr/local/sh/net/net0
echo 0 0 > /usr/local/sh/net/net1
sleep 1
/sbin/reboot