#!/bin/bash

# 设置代理
export http_proxy=http://192.168.18.119:7890
export https_proxy=http://192.168.18.119:7890

# # 备份并换源
mv /etc/apt/sources.list /etc/apt/sources.list_backup
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list

# 安装依赖
apt -y update
apt -y install vim sudo unzip wget build-essential cmake curl git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev

# 安装 gocv
echo "安装 gocv"
git clone https://github.com/hybridgroup/gocv
cd gocv && make install

# 清除缓存
apt clean
rm -rf /tmp/*