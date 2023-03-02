FROM ubuntu:20.04

WORKDIR /init

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# go环境变量
ENV GOPROXY=https://goproxy.cn,direct
ENV GO111MODULE=on
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin

# 打包环境变量
ENV VERSION=0.0.1
ENV PKG_NAME=main

# 复制当前文件到容器
COPY build.sh /init/build.sh