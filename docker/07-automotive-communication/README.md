# 汽车通信 C++ 开发镜像

该镜像基于 Ubuntu 24.04，包含 GNU/LLVM、CMake、Ninja、GDB、clangd、
clang-format，以及以下通信栈：

- COVESA vsomeip 3.5.4；
- CommonAPI C++ Core Runtime 与 SOME/IP Runtime 3.2.4；
- Fast DDS 3.6.2；
- Eclipse Cyclone DDS 与 Cyclone DDS C++ 11.0.1。

所有源码构建产物安装在 `/opt/automotive`。镜像已经设置
`CMAKE_PREFIX_PATH`、`PKG_CONFIG_PATH`、`LD_LIBRARY_PATH`，CMake 项目可直接
使用各组件提供的 package config。

## 构建与运行

```bash
cd docker
docker build -f 07-automotive-communication/Dockerfile \
  -t dofiles/automotive-communication:1.0 .

docker run --rm -it \
  --network host \
  -v "$PWD:/workspace" \
  dofiles/automotive-communication:1.0
```

SOME/IP 和 DDS 的发现机制依赖组播。Linux 主机可使用 `--network host`；
Docker Desktop 不提供等价的 Linux host 网络语义时，应改用显式端口、固定
对端地址或自建 Docker 网络。

## CommonAPI 代码生成器

COVESA 发布的 CommonAPI 生成器是 Linux x86-64 可执行文件，因此镜像只在
`linux/amd64` 构建时安装它们；ARM64 镜像仍包含全部 CommonAPI 运行库。
生成器位于 `/opt/commonapi-generators`。如在 Apple Silicon 上需要生成代码，
请使用 `docker build --platform linux/amd64 ...` 构建。

各组件版本都可以通过 Docker build argument 覆盖，例如：

```bash
docker build -f 07-automotive-communication/Dockerfile \
  --build-arg FAST_DDS_VERSION=v3.6.2 \
  -t dofiles/automotive-communication:custom .
```
