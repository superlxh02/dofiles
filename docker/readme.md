# Docker 镜像说明

本目录下的 Dockerfile 面向 **C/C++ 开发**，尽量统一包含：

| 类别              | 内容                                                                       |
| ----------------- | -------------------------------------------------------------------------- |
| **GCC 系**        | gcc、g++、gfortran、make、cmake、ninja、gdb                                |
| **LLVM 系**       | clang、clangd、lldb、compiler-rt 等                                        |
| **性能与调试**    | perf、strace、ltrace、valgrind、sysstat                                    |
| **内核 / eBPF**   | kernel-devel、kernel-headers、bpftool、bcc-tools bpftrace、dwarves、pahole |
| **包管理 / 构建** | **Conan**、**xmake**、**vcpkg**、**Bazel（bazelisk）**                     |

---

## 各 Dockerfile 主要功能

### `fedora-demo.Dockerfile`

- **基础镜像**：`fedora:latest`（当前 Fedora 稳定）
- **用途**：本机或 CI 里快速搭一套 **Fedora 系** 隔离环境；工具链与 perf/bcc/vcpkg/bazel 一次装齐
- **适用**：日常开发、与 Fedora 生态对齐、国内可配合镜像 sed 加速

### `morden-cpp.Dockerfile`

- **基础镜像**：`fedora:rawhide`（**非稳定**，滚动前沿）
- **用途**：在 **Fedora Rawhide** 上尝鲜最新 GCC/Clang 与系统库，适合做 **冒烟 / 预适配**
- **注意**：rawhide 可能偶发包冲突，不适合作为唯一生产基线；要稳定请用 `fedora-demo.Dockerfile`

### `ubuntu-demo.Dockerfile`

- **基础镜像**：`ubuntu:24.04`
- **用途**：**Debian/Ubuntu 系** 工具链与 **linux-tools-generic**（perf）、bpfcc-tools、bpftrace；pip 安装 Conan，脚本安装 xmake，vcpkg + bazelisk
- **适用**：与 Ubuntu 服务器或 CI（如 GitHub Actions ubuntu-latest）行为接近

### `rocky-demo.Dockerfile`

- **基础镜像**：`rockylinux:9`（RHEL 系）
- **用途**：与 **RHEL/Rocky/Alma** 生产环境对齐的编译与调试；EPEL + 同类工具集，Conan 用 pip，xmake 用官方脚本，vcpkg + bazelisk
- **适用**：需要与 RHEL 系发行版一致时的本地/CI 环境

### `base-dev.Dockerfile`

- **基础镜像**：`fedora:latest`
- **用途**：**最小可复用基底**，仅 GCC/Clang/CMake/Git 等核心；**不含** perf/bcc/SSH/vcpkg 全家桶
- **适用**：多阶段构建的第一阶段，或自己在其上再 `RUN dnf install ...` 扩展

### `fedora-sshd.Dockerfile`

- **基础镜像**：`fedora:latest`
- **用途**：跑 **sshd**，用 SSH 登入容器做远程开发；内置 **dev** 用户、工作区与完整 C++ 栈（与 demo 同级）
- **默认**：用户 `dev` / 密码 `123456`（**务必修改**）；`-p 2222:22` 等映射后 `ssh dev@host -p 2222`

### `ubuntu-sshd.Dockerfile`

- **基础镜像**：`ubuntu:24.04`
- **用途**：与 `ubuntu-demo` 同栈 + **sshd**，便于在 Ubuntu 系远程开发
- **默认**：用户 `dev` / 密码 `123456`（**务必修改**）

### `morden-cpp-sshd.Dockerfile`

- **基础镜像**：`fedora:rawhide`
- **用途**：与 `morden-cpp` 同栈（Rawhide 前沿工具链）+ **sshd**，用 SSH 登入做远程开发
- **默认**：用户 `dev` / 密码 `123456`（**务必修改**）；映射 `-p 2222:22` 后 `ssh dev@host -p 2222`
- **注意**：同 Rawhide 镜像，不适合作为唯一生产基线

### `rocky-sshd.Dockerfile`

- **基础镜像**：`rockylinux:9`
- **用途**：与 `rocky-demo` 同栈 + **sshd**，便于在 RHEL/Rocky 系远程开发
- **默认**：用户 `dev` / 密码 `123456`（**务必修改**）

### `devcontainer/Dockerfile`

- **用途**：**VS Code / Cursor Dev Container** 专用；装齐与 `fedora-demo` 同级的开发依赖，在容器里直接打开仓库开发
- **配合**：同目录 `devcontainer.json` 指定 `dockerFile`

---

## 构建示例

```bash
cd docker

# Fedora 稳定 + 全工具链
docker build -f fedora-demo.Dockerfile -t dofiles/fedora-cpp .

# Fedora Rawhide（前沿）
docker build -f morden-cpp.Dockerfile -t dofiles/morden-cpp .

# Ubuntu
docker build -f ubuntu-demo.Dockerfile -t dofiles/ubuntu-cpp .

# Rocky
docker build -f rocky-demo.Dockerfile -t dofiles/rocky-cpp .

# SSH 开发（任选其一；镜像名可自行替换）
docker build -f fedora-sshd.Dockerfile -t dofiles/fedora-sshd .
docker build -f ubuntu-sshd.Dockerfile -t dofiles/ubuntu-sshd .
docker build -f morden-cpp-sshd.Dockerfile -t dofiles/morden-cpp-sshd .
docker build -f rocky-sshd.Dockerfile -t dofiles/rocky-sshd .
docker run -d -p 2222:22 -v /path/to/workspace:/home/dev/workspace --name fedora-ssh dofiles/fedora-sshd
```

`docker-compose.yml` 默认使用 **`fedora-demo.Dockerfile`** 挂工作区；按需改 `dockerfile:` 与 `volumes` 路径即可。

---

## 一键构建（除 devcontainer 外）

统一 tag `1.0`，命名约定：

- **无 sshd**：`{fedora|ubuntu|rocky}-base-dev-mirror:1.0`
- **同栈 + sshd**：在 `base-dev` 后加 `-ssh`，即 `{fedora|ubuntu|rocky}-base-dev-ssh-mirror:1.0`
- **Rawhide**：常规为 `modern-cpp-dev-mirror`，带 sshd 为 `modern-cpp-dev-ssh-mirror`（与 morden-cpp 文件名对应，未用 `base` 前缀）

| 镜像名                             | Dockerfile                       |
| ---------------------------------- | -------------------------------- |
| `fedora-base-dev-mirror:1.0`       | fedora-demo（完整 Fedora 栈）    |
| `fedora-base-dev-ssh-mirror:1.0`   | fedora-sshd                      |
| `fedora-min-base-dev-mirror:1.0`  | base-dev（最小 Fedora 基底）     |
| `ubuntu-base-dev-mirror:1.0`       | ubuntu-demo                      |
| `ubuntu-base-dev-ssh-mirror:1.0`   | ubuntu-sshd                      |
| `rocky-base-dev-mirror:1.0`        | rocky-demo                       |
| `rocky-base-dev-ssh-mirror:1.0`    | rocky-sshd                       |
| `modern-cpp-dev-mirror:1.0`        | morden-cpp（Rawhide）            |
| `modern-cpp-dev-ssh-mirror:1.0`    | morden-cpp-sshd（Rawhide + SSH） |

```bash
cd docker
python3 build_images.py          # 构建全部
python3 build_images.py --dry-run
```

---

## 说明与限制

1. **perf**：容器内 perf 与宿主内核需匹配时结果最可靠；仅编译与静态分析不依赖此点。
2. **vcpkg**：demo 镜像多装到 `/opt/vcpkg`；**SSH 镜像**（fedora/ubuntu/morden-cpp/rocky-sshd）统一在 **`dev` 家目录** `~/vcpkg`（即 `/home/dev/vcpkg`），并已设置 `CMAKE_TOOLCHAIN_FILE`。
3. **Bazel**：统一使用 **bazelisk**，命令仍为 `bazel`，版本由 bazelisk 管理。
4. **Rocky/Rawhide**：部分包名或仓库可能随版本变化，若构建失败可注释掉非必需包再试。

---

## vcpkg 依赖（官方 `scripts/bootstrap.sh`）

- **必装（下载预编译 vcpkg 二进制时）**：`curl`、`zip`、`unzip`、`tar`（脚本会逐项检查）。
- **从源码编译 vcpkg-tool 时额外需要**：`cmake`、`ninja`、`git`。
- 各 Dockerfile 中已 **单独一段 RUN 安装上述依赖**，再执行 `bootstrap-vcpkg.sh`，避免漏装。

## GNU autotools（auto* 系列）

- 已单独一层安装：**m4、autoconf、automake、libtool、flex、bison**；Fedora/Rocky 另加 **gettext-devel**（或 Ubuntu 的 **gettext**），满足常见 `./configure && make` 工程。

## Rocky vs Fedora 包名

- **dnf/yum 族**：Rocky 9 与 Fedora 多数开发包名一致（如 `gcc-c++`、`kernel-devel`、`bcc-tools`）；**pkg-config** 在 EL9 上通过 **`pkgconf-pkg-config`** 提供 `pkg-config` 命令。
- **差异**：Rocky 上 **xmake** 常不在默认仓库，Dockerfile 里用 **官方安装脚本**；**conan** 在部分 EL 镜像里用 **pip** 安装更稳。
- **瘦身**：统一使用 `dnf install ... --setopt=tsflags=nodocs --setopt=install_weak_deps=False` 与 `apt-get ... --no-install-recommends`，每段安装后 **`dnf/apt clean` + 删缓存** 以减小体积。
