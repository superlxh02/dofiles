FROM ubuntu:24.04

LABEL org.opencontainers.image.title="embedded-linux-dev" \
      org.opencontainers.image.description="Embedded Linux, kernel and driver development environment with ARM, AArch64 and RISC-V cross toolchains"

ENV DEBIAN_FRONTEND=noninteractive \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu-

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        autoconf automake bash bc bear binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabihf binutils-riscv64-linux-gnu bison \
        build-essential bzip2 ca-certificates ccache chrpath clang clangd \
        clang-format coccinelle cpio curl \
        device-tree-compiler diffstat fakeroot file flex g++-aarch64-linux-gnu \
        g++-arm-linux-gnueabihf g++-riscv64-linux-gnu gcc-aarch64-linux-gnu \
        gcc-arm-linux-gnueabihf gcc-riscv64-linux-gnu gdb-multiarch git \
        iputils-ping kmod libelf-dev libncurses-dev libssl-dev libtool \
        linux-headers-generic linux-source lz4 make ninja-build patch \
        pkg-config python3 python3-git python3-jinja2 python3-pexpect \
        python3-pip python3-venv qemu-system-arm qemu-system-misc \
        qemu-user-static rsync socat sparse swig tar texinfo u-boot-tools \
        unzip wget xz-utils zstd \
    && rm -rf /var/lib/apt/lists/* \
    && command -v clangd \
    && command -v clang-format

WORKDIR /workspace
CMD ["/bin/bash"]
