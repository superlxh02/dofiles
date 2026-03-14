# =============================================================================
# devcontainer — 与 fedora-demo 同依赖拆分；无 Qt
# =============================================================================

FROM fedora:latest

LABEL maintainer="dofiles" \
      description="Dev Container: Fedora C/C++ stack (no Qt), slim"

ARG DNF_CLEAN="dnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/*"

RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' /etc/yum.repos.d/*.repo

RUN dnf update -y && dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    m4 autoconf automake libtool flex bison gettext-devel \
    && eval "$DNF_CLEAN"

RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    curl zip unzip tar cmake ninja-build git \
    && eval "$DNF_CLEAN"

RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    which file gzip xz sudo gawk perl wget net-tools \
    gcc gcc-c++ gcc-gfortran make gdb \
    llvm clang clang-tools-extra lldb pkgconf-pkg-config \
    valgrind strace ltrace perf \
    kernel-devel kernel-headers bpftool bcc-tools bpftrace dwarves pahole \
    python3 python3-pip conan xmake \
    && eval "$DNF_CLEAN"

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
