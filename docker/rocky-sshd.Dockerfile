#
# rocky-sshd — Rocky Linux 9 + SSH，沿用 rocky-demo 的工具栈，增加 dev 用户和 SSH
#

FROM rockylinux:9

LABEL maintainer="dofiles" \
    description="Rocky Linux 9 + SSH + C/C++ stack, slim"

ARG DNF_CLEAN="dnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/*"

# 基础更新与 EPEL
RUN dnf -y install epel-release && dnf -y update && eval "$DNF_CLEAN"

# --- GNU autotools（Rocky 包名与 Fedora 一致：autoconf automake libtool）---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    m4 autoconf automake libtool flex bison gettext-devel \
    pkgconf-pkg-config \
    && eval "$DNF_CLEAN"

# --- vcpkg bootstrap 依赖 ---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    zip unzip tar cmake git \
    && eval "$DNF_CLEAN"

# --- 工具链 + SSH ---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    which file gzip xz sudo wget ca-certificates iproute rsync \
    gcc gcc-c++ gcc-gfortran make gdb \
    llvm clang clang-tools-extra lldb \
    valgrind strace ltrace \
    perf sysstat \
    kernel-devel kernel-headers \
    bpftool bcc-tools bpftrace \
    dwarves \
    python3 python3-pip \
    openssh-server \
    && eval "$DNF_CLEAN"

RUN pip3 install --no-cache-dir conan

# xmake 官方脚本
RUN curl -fsSL https://xmake.io/shget.text | bash
ENV PATH="/root/.local/bin:${PATH}"

RUN ARCH=$(uname -m); case "$ARCH" in x86_64) A=amd64;; aarch64) A=arm64;; *) A=amd64;; esac; \
    curl -fsSL "https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-${A}" -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel && ln -sf /usr/local/bin/bazel /usr/local/bin/bazelisk

# SSH 配置 + dev 用户
RUN ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    echo "AllowUsers dev" >> /etc/ssh/sshd_config

RUN useradd -m -u 1000 -s /bin/bash dev && \
    echo "dev:123456" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/dev/.ssh /home/dev/workspace && chmod 700 /home/dev/.ssh && \
    chown -R dev:dev /home/dev/.ssh /home/dev/workspace

USER dev
WORKDIR /home/dev
ENV VCPKG_ROOT=/home/dev/vcpkg
RUN git clone --depth 1 https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT} \
    && ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics \
    && chmod +x ${VCPKG_ROOT}/vcpkg
ENV PATH="${VCPKG_ROOT}:${PATH}"
ENV CMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake

RUN printf '%s\n' \
    'export PATH="'${VCPKG_ROOT}':$PATH"' \
    'export VCPKG_ROOT='${VCPKG_ROOT} \
    'export CMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake' \
    >> /home/dev/.bashrc

USER root
RUN chown -R dev:dev /home/dev/vcpkg && chmod -R 775 /home/dev/vcpkg

EXPOSE 22
VOLUME /home/dev/workspace
CMD ["/usr/sbin/sshd", "-D", "-e"]

