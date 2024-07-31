#!/bin/bash

# 安装环境包
sudo apt update
sudo apt install -y snapd
sudo snap install core
sudo snap install gost

# 防火墙放开端口
sudo ufw allow 18080/tcp
sudo ufw allow 18080/udp

# 获取vps的IP
IP_ADDRESS=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# 为gost创建systemd服务
sudo tee /etc/systemd/system/gost.service > /dev/null <<EOT
[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/snap/bin/gost -L=username:password@$IP_ADDRESS:18080
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# 设置服务为开机启动
sudo systemctl enable gost
sudo systemctl start gost

# 打印服务状态和socks字段
systemctl status gost
