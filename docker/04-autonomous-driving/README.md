# Apollo 与 CyberRT

## Apollo 全量环境

`Dockerfile.apollo-full` 包装 Apollo 仓库当前指定的官方 x86_64 开发镜像。
镜像包含完整构建依赖，但 Apollo 源码应从宿主机挂载到 `/apollo`：

```bash
docker build -f Dockerfile.apollo-full -t dofiles/apollo-full .
docker run --rm -it --privileged --network host \
  --shm-size 2g -v /path/to/apollo:/apollo dofiles/apollo-full
```

需要地图、设备、GPU 或模型卷时，优先在 Apollo 源码目录运行官方的
`bash docker/scripts/dev_start.sh`，因为该脚本会配置这些额外挂载项。

## CyberRT-only 环境

`Dockerfile.cyberrt` 使用官方 CyberRT 镜像，适合只构建和测试 `cyber`：

```bash
docker build -f Dockerfile.cyberrt -t dofiles/cyberrt .
docker run --rm -it --privileged --network host \
  --shm-size 2g -v /path/to/apollo:/apollo dofiles/cyberrt

# 容器内
./apollo.sh build cyber
```

两个默认官方基础镜像都是 `linux/amd64`，Dockerfile 已显式声明该平台。
Apple Silicon 可以通过容器运行时仿真，但大型编译会明显慢于原生 x86_64。
如有匹配版本的官方 ARM64 镜像，可同时覆盖 `APOLLO_PLATFORM` 和对应的
`APOLLO_DEV_IMAGE` 或 `CYBERRT_IMAGE` 构建参数。
