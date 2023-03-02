# 镜像环境安装

## 编译基础镜像
```bash
# 编译arm64
docker buildx build -t go_ubuntu:arm64 --platform=linux/arm64 -o type=docker .
# 编译amd64
docker buildx build -t go_ubuntu:amd64 --platform=linux/amd64 -o type=docker .
```

## 创建go_ubuntu容器
```bash
# arm64
docker run -d --privileged --network host --ipc=host --name go_build_arm go_ubuntu:arm64 tail -f /dev/null 
# amd64
docker run -d --privileged --network host --ipc=host --name go_build_amd go_ubuntu:amd64 tail -f /dev/null
```

## 进入容器
```bash
# arm64
docker exec -it go_build_arm /bin/bash
# amd64
docker exec -it go_build_amd /bin/bash
```

## 安装环境

### 1.设置代理
```bash
export http_proxy=http://192.168.18.119:7890
export https_proxy=http://192.168.18.119:7890
```

### 2.更新依赖
```bash
apt -y update
apt -y install vim sudo unzip wget build-essential cmake curl git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
```

### 3.安装go
```bash
# arm64
wget -c https://go.dev/dl/go1.19.4.linux-arm64.tar.gz -O - | tar -xz -C /usr/local
# amd64
wget -c https://go.dev/dl/go1.19.4.linux-amd64.tar.gz -O - | tar -xz -C /usr/local
```

### 4.安装 gocv
```bash
git clone https://github.com/hybridgroup/gocv
cd gocv && make install_static
```
> 静态编译

### 5.容器导出到镜像
```bash
# arm64
docker commit go_build_arm go_build:arm64
# amd64
docker commit go_build_amd go_build:amd64
```

### 6.编译项目
```bash
# arm
docker run --rm -t \
  -e VERSION=${版本号} -e PKG_NAME=${包名} \
  -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static \
  -v ${项目目录}:/app -v ${输出目录}:/output \
  go_build:arm64 sh /init/build.sh

#amd64
docker run --rm -t \
  -e VERSION=${版本号} -e PKG_NAME=${包名} \
  -v ${项目目录}:/app -v ${输出目录}:/output \
   go_build:amd64 sh /init/build.sh
```

### 7.错误记录
1. arm下静态编译gocv报错
```bash
root@pc-MS-7D17:/init/gocv# go run -tags static ./cmd/version/main.go 
# command-line-arguments
/usr/local/go/pkg/tool/linux_arm64/link: running g++ failed: exit status 1
/usr/bin/ld: cannot find -lippiw
/usr/bin/ld: cannot find -lippicv
/usr/bin/ld: cannot find -lquadmath
collect2: error: ld returned 1 exit status
```