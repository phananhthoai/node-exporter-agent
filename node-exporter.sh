#!/usr/bin/env bash

set -ex

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz

echo "download succsess !"

tar -xvf node_exporter-1.8.1.linux-amd64.tar.gz

sudo mv node_exporter-1.8.1.linux-amd64/node_exporter /opt/

sudo touch /etc/systemd/system/node_exporter.service

cat <<EOF | sudo tee -a /etc/systemd/system/node_exporter.service > /dev/null
[Unit]
Description=Node Exporter

[Service]
Type=simple
ExecStart=/opt/node_exporter --web.systemd-socket --collector.systemd --collector.ethtool --collector.network_route --collector.tcpstat

[Install]
WantedBy=multi-user.target

EOF

sudo touch /etc/systemd/system/node_exporter.socket

cat <<EOF | sudo tee -a /etc/systemd/system/node_exporter.socket > /dev/null
[Unit]
Description=Node Exporter

[Socket]
ListenStream=/run/node_exporter.sock
SocketMode=0660
SocketUser=root
SocketGroup=root

[Install]
WantedBy=sockets.target

EOF


sudo systemctl start node_exporter.socket
sudo systemctl enable node_exporter.socket
sudo systemctl start node_exporter.service
sudo systemctl enable node_exporter.service
