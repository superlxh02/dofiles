# =============================================================================
# ubuntu-demo — Debian/Ubuntu；vcpkg 官方写 apt install curl zip unzip tar；
# 源码编译 vcpkg-tool 时需 cmake ninja-build git
# 瘦身：--no-install-recommends、rm -rf /var/lib/apt/lists、pip --no-cache-dir
# =============================================================================

FROM ubuntu:24.04

LABEL maintainer="dofiles" \
    description="Ubuntu: C/C++ stack , slim"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    m4 autoconf automake libtool flex bison gettext \
    && rm -rf /var/lib/apt/lists/*

# vcpkg bootstrap 硬性 + 源码编译回退
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    curl zip unzip tar \
    cmake ninja-build git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential gfortran \
    gdb llvm clang clangd lldb \
    pkg-config \
    linux-headers-generic linux-tools-generic linux-tools-common \
    bpfcc-tools bpftrace \
    valgrind strace ltrace dwarves \
    python3 python3-pip python3-venv sudo \
    && rm -rf /var/lib/apt/lists/*

RUN set -e; P=$(ls -d /usr/lib/linux-tools/*/perf 2>/dev/null | head -1); \
    [ -n "$P" ] && [ -x "$P" ] && ln -sf "$P" /usr/local/bin/perf || true

RUN pip3 install --no-cache-dir --break-system-packages conan 2>/dev/null || pip3 install --no-cache-dir conan

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
