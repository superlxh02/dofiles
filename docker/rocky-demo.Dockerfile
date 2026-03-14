# =============================================================================
# rocky-demo — Rocky Linux 9（RHEL 系），包名与 Fedora 有差异处已按 EL9 习惯写
# =============================================================================
# RHEL/Rocky：无 pkgconf-pkg-config 时可用 pkgconf + 部分包在 CRB/PowerTools
# bcc-tools / bpftool 在 AppStream/BaseOS；kernel-devel 按运行内核版本最好用 @kernel-devel
# 瘦身：tsflags=nodocs + clean
# =============================================================================

FROM rockylinux:9

LABEL maintainer="dofiles" \
    description="Rocky Linux 9: C/C++ stack , slim"

ARG DNF_CLEAN="dnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/*"

# CRB（CodeReady Builder）里部分内容与开发头文件相关，按需启用
RUN dnf -y install epel-release && dnf -y update && eval "$DNF_CLEAN"

# --- GNU autotools（Rocky 包名与 Fedora 一致：autoconf automake libtool）---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    m4 autoconf automake libtool flex bison gettext-devel \
    pkgconf-pkg-config \
    && eval "$DNF_CLEAN"

# --- vcpkg bootstrap：见 scripts/bootstrap.sh；Red Hat 官方亦写 dnf install curl zip unzip tar ---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    zip unzip tar cmake git \
    && eval "$DNF_CLEAN"

# --- 工具链；Rocky 上 lldb/llvm 包名仍为 clang/llvm 家族 ---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    which file gzip xz sudo wget ca-certificates iproute \
    gcc gcc-c++ gcc-gfortran make gdb \
    llvm clang clang-tools-extra lldb \
    valgrind strace ltrace \
    perf sysstat \
    kernel-devel kernel-headers \
    bpftool bcc-tools bpftrace \
    dwarves \
    python3 python3-pip \
    && eval "$DNF_CLEAN"

RUN pip3 install --no-cache-dir conan

# xmake 官方脚本（Rocky 仓库通常无 xmake 包）
RUN curl -fsSL https://xmake.io/shget.text | bash
ENV PATH="/root/.local/bin:${PATH}"

RUN ARCH=$(uname -m); case "$ARCH" in x86_64) A=amd64;; aarch64) A=arm64;; *) A=amd64;; esac; \
    curl -fsSL "https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-${A}" -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel && ln -sf /usr/local/bin/bazel /usr/local/bin/bazelisk

ENV VCPKG_ROOT=/opt/vcpkg
RUN git clone --depth 1 https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT} \
    && ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics \
    && chmod +x ${VCPKG_ROOT}/vcpkg
ENV PATH="${VCPKG_ROOT}:${PATH}"
ENV CMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake

WORKDIR /workspace
CMD ["/bin/bash"]
