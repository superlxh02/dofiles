# Docker 开发镜像

Dockerfile 按用途分为七组。`devcontainer/` 保持独立，不参与批量构建；旧的
根目录 Dockerfile 已移除。

## 目录结构

| 目录 | 基础镜像 | 用途 |
| --- | --- | --- |
| `01-minimal-cpp/` | Ubuntu latest、Fedora latest、Ubuntu 24.04 | 小体积 GNU/LLVM、CMake、Ninja 基础开发环境 |
| `02-full-cpp/` | Ubuntu latest、Fedora latest、Ubuntu 24.04 | 完整编译、调试、分析、构建及包管理工具 |
| `03-robotics/` | Ubuntu 24.04 | ROS 2 Jazzy 无 GUI 版，以及 Desktop Full + Qt/Gazebo + VNC 版 |
| `04-autonomous-driving/` | Apollo 官方镜像 | Apollo 全量和 CyberRT-only 开发环境 |
| `05-modern-cpp/` | Fedora Rawhide | 最新编译器和标准库的前沿兼容性测试 |
| `06-embedded-linux/` | Ubuntu 24.04 | 嵌入式 Linux、内核、驱动和交叉编译 |
| `07-automotive-communication/` | Ubuntu 24.04 | SOME/IP、CommonAPI、Fast DDS 与 Cyclone DDS |

所有 C++ 开发镜像都包含 `clangd` 和 `clang-format`，并在构建期间检查这两个
命令是否可用。

## 1. 小体积 C++ 开发

三个镜像都包含 GCC、Clang/LLVM、clangd、clang-format、GDB/LLDB、CMake、
Ninja、Git 和 pkg-config，不包含包管理器、性能工具和大型 SDK。

```bash
docker build -f 01-minimal-cpp/Dockerfile.ubuntu-latest -t dofiles/cpp-min:ubuntu-latest .
docker build -f 01-minimal-cpp/Dockerfile.fedora-latest -t dofiles/cpp-min:fedora-latest .
docker build -f 01-minimal-cpp/Dockerfile.ubuntu-24.04 -t dofiles/cpp-min:ubuntu-24.04 .
```

## 2. 全量 C++ 开发

在 GNU/LLVM 工具链之外，还包含：

- CMake、Ninja、Meson、GNU Autotools、Make、mold 和 LLD；
- GDB、LLDB、Valgrind、strace、tcpdump、wrk、clang-tidy、clang-format、
  clangd 和 cppcheck；
- Linux perf、bpftool、BPF Compiler Collection、bpftrace、libbpf、ELF/BTF
  开发库；
- Conan 2、vcpkg、xmake 和 Bazelisk；
- GCC/Clang sanitizer 运行时、libstdc++ 与 libc++。

```bash
docker build -f 02-full-cpp/Dockerfile.ubuntu-latest -t dofiles/cpp-full:ubuntu-latest .
docker build -f 02-full-cpp/Dockerfile.fedora-latest -t dofiles/cpp-full:fedora-latest .
docker build -f 02-full-cpp/Dockerfile.ubuntu-24.04 -t dofiles/cpp-full:ubuntu-24.04 .
```

## 3. 机器人开发

ROS 2 镜像固定使用 Ubuntu 24.04 + Jazzy LTS，提供精简无界面版，以及包含
Desktop Full、RViz2、RQt、Qt、Gazebo、XFCE 和 TigerVNC 的完整图形版。详情见
[`03-robotics/README.md`](03-robotics/README.md)。

```bash
docker build -f 03-robotics/Dockerfile.ros2-jazzy -t dofiles/ros2-jazzy-headless .
docker build -f 03-robotics/Dockerfile.ros2-jazzy-desktop-vnc -t dofiles/ros2-jazzy-desktop-vnc .
```

## 4. 自动驾驶开发

- `Dockerfile.apollo-full`：Apollo 官方完整开发环境；
- `Dockerfile.cyberrt`：Apollo 官方 CyberRT-only 环境。

这两个上游镜像体积较大并主要支持 `linux/amd64`。运行参数、源码挂载和
GPU/设备注意事项见
[`04-autonomous-driving/README.md`](04-autonomous-driving/README.md)。

## 5. 现代 C++ 前沿测试

Fedora Rawhide 镜像默认使用 Clang + Ninja，保留 GCC，并安装最新可用的
LLVM、libc++、mold、sanitizer 和静态分析工具。Rawhide 不作为发布基线。

```bash
docker build -f 05-modern-cpp/Dockerfile -t dofiles/modern-cpp .
```

## 6. 嵌入式 Linux、内核与驱动

固定使用 Ubuntu 24.04，提供 ARM、AArch64、RISC-V 交叉工具链、QEMU、
设备树、U-Boot、内核源码/头文件，以及 Buildroot/Yocto 常用依赖。详情见
[`06-embedded-linux/README.md`](06-embedded-linux/README.md)。

```bash
docker build -f 06-embedded-linux/Dockerfile -t dofiles/embedded-linux .
```

## 7. 汽车通信

固定使用 Ubuntu 24.04，包含 GNU/LLVM、CMake、Ninja、COVESA vsomeip、
CommonAPI Core/SOME/IP Runtime、Fast DDS、Cyclone DDS 及其 C++ binding。
详细版本、网络运行方式和 CommonAPI 生成器的架构限制见
[`07-automotive-communication/README.md`](07-automotive-communication/README.md)。

```bash
docker build -f 07-automotive-communication/Dockerfile \
  -t dofiles/automotive-communication .
```

## 批量构建

```bash
python3 build_images.py --dry-run
python3 build_images.py

# 仅构建一个镜像；既可传镜像名，也可传 Dockerfile 路径
python3 build_images.py --only cpp-min-ubuntu-24.04:1.0
```

所有常规开发镜像默认工作目录都是 `/workspace`。推荐运行时挂载源码，而不
要把业务源码复制进开发镜像：

```bash
docker run --rm -it -v "$PWD:/workspace" IMAGE_NAME
```
