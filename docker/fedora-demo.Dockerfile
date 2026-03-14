# =============================================================================
# fedora-demo — Fedora 稳定版，C/C++ 开发
# =============================================================================
# 主要功能：隔离的 Fedora 工具链 + perf/eBPF + Conan/xmake/vcpkg/Bazelisk
# 瘦身：--setopt=tsflags=nodocs、install_weak_deps=False、每段 clean + 删缓存
# =============================================================================

FROM fedora:latest

LABEL maintainer="dofiles" \
    description="Fedora stable: full C/C++ stack , slim"

ARG DNF_CLEAN="dnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/*"

# 可选镜像（需要时取消注释）
# RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
#     sed -i 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' /etc/yum.repos.d/*.repo

# --- GNU autotools 系（auto* 系列，单独一层便于复用与排查）---
# m4/autoconf/automake/libtool + flex/bison
RUN dnf update -y && dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    m4 autoconf automake libtool flex bison gettext-devel \
    && eval "$DNF_CLEAN"

# --- vcpkg bootstrap 依赖（官方 scripts/bootstrap.sh）---
# 预编译二进制：需 curl zip unzip tar；若回落源码编译 vcpkg-tool：需 cmake ninja git
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    curl zip unzip tar \
    cmake ninja-build git \
    && eval "$DNF_CLEAN"

# --- 工具链与内核/性能（与 vcpkg 分开，便于按需裁剪）---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    which file gzip xz sudo \
    perl wget ca-certificates \
    iproute \
    gcc gcc-c++ gcc-gfortran \
    make gdb gdb-gdbserver \
    llvm clang clang-tools-extra lldb compiler-rt \
    pkgconf-pkg-config \
    valgrind strace ltrace \
    perf sysstat \
    kernel-devel kernel-headers bpftool bcc-tools bpftrace dwarves pahole \
    python3 python3-pip conan xmake \
    && eval "$DNF_CLEAN"

# Bazelisk：单二进制，无多余依赖
RUN ARCH=$(uname -m); case "$ARCH" in x86_64) A=amd64;; aarch64) A=arm64;; *) A=amd64;; esac; \
    curl -fsSL "https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-${A}" -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel && ln -sf /usr/local/bin/bazel /usr/local/bin/bazelisk

# --- vcpkg：前置已满足 bootstrap，此处仅 clone + bootstrap ---
ENV VCPKG_ROOT=/opt/vcpkg
RUN git clone --depth 1 https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT} \
    && ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics \
    && chmod +x ${VCPKG_ROOT}/vcpkg
ENV PATH="${VCPKG_ROOT}:${PATH}"
ENV CMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake

WORKDIR /workspace
CMD ["/bin/bash"]
