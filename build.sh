cd /app

# 设置代理
export http_proxy=http://192.168.18.119:7890
export https_proxy=http://192.168.18.119:7890

# 安装依赖
go mod tidy

# 编译 开启CGO
if [ $(arch) = "x86_64" ]; then
  CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -tags static --ldflags '-extldflags "-static"' -o /output/$VERSION/$PKG_NAME_x86_64
else
  CGO_ENABLED=1 GOOS=linux GOARCH=arm64 go build -tags static --ldflags '-extldflags "-static"' -o /output/$VERSION/$PKG_NAME_arm64
fi