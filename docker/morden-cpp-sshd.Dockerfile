#
# morden-cpp-sshd — Fedora Rawhide + SSH，沿用 morden-cpp 的工具栈，增加 dev 用户和 SSH
#

FROM fedora:rawhide

LABEL maintainer="dofiles" \
    description="Fedora Rawhide + SSH + C/C++ stack, slim"

ARG DNF_CLEAN="dnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/*"

# --- GNU autotools ---
RUN dnf update -y && dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    m4 autoconf automake libtool flex bison gettext-devel \
    && eval "$DNF_CLEAN"

# --- vcpkg 官方依赖：curl zip unzip tar；源码编译时 cmake ninja git ---
RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    curl zip unzip tar cmake ninja-build git \
    && eval "$DNF_CLEAN"

RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    which file gzip xz sudo perl wget ca-certificates iproute rsync \
    openssh-server \
    gcc gcc-c++ gcc-gfortran make gdb gdb-gdbserver \
    llvm clang clang-tools-extra lldb compiler-rt pkgconf-pkg-config \
    valgrind strace ltrace perf sysstat \
    kernel-devel kernel-headers bpftool bcc-tools bpftrace dwarves pahole \
    python3 python3-pip conan xmake \
    && eval "$DNF_CLEAN"

RUN ARCH=$(uname -m); case "$ARCH" in x86_64) A=amd64;; aarch64) A=arm64;; *) A=amd64;; esac; \
    curl -fsSL "https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-${A}" -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel && ln -sf /usr/local/bin/bazel /usr/local/bin/bazelisk

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

