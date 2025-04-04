#!/usr/bin/env bash

set -ex


sudo iptables -A INPUT -p tcp -s 192.168.200.0/24 --dport 9100 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9100 -j REJECT