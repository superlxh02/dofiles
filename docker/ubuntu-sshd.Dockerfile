# =============================================================================
# ubuntu-sshd — Ubuntu + SSH，依赖与 ubuntu-demo 对齐，vcpkg 在 dev 家目录
# =============================================================================
# 默认用户 dev / 密码 123456（请修改）。暴露 22，便于 ssh dev@host -p <port>
# =============================================================================

FROM ubuntu:24.04

LABEL maintainer="dofiles" \
    description="Ubuntu + SSH + C/C++ stack , slim"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    m4 autoconf automake libtool flex bison gettext \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    curl zip unzip tar cmake ninja-build git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    openssh-server rsync \
    build-essential gfortran gdb llvm clang clangd lldb pkg-config \
    linux-headers-generic linux-tools-generic linux-tools-common \
    bpfcc-tools bpftrace valgrind strace ltrace dwarves \
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

RUN ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    echo "AllowUsers dev" >> /etc/ssh/sshd_config

RUN useradd -m -s /bin/bash dev && \
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
