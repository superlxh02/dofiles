FROM fedora:rawhide

LABEL org.opencontainers.image.title="modern-cpp-rawhide" \
      org.opencontainers.image.description="Forward-looking GNU/LLVM C++ toolchain test line on Fedora Rawhide"

RUN dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
        ca-certificates \
        ccache \
        clang \
        clang-tools-extra \
        cmake \
        compiler-rt \
        cppcheck \
        gcc \
        gcc-c++ \
        gdb \
        git \
        libcxx-devel \
        libcxxabi-devel \
        libomp-devel \
        lld \
        lldb \
        llvm \
        make \
        mold \
        ninja-build \
        pkgconf-pkg-config \
    && dnf clean all \
    && rm -rf /var/cache/dnf /tmp/* \
    && command -v clangd \
    && command -v clang-format

ENV CC=clang \
    CXX=clang++ \
    CMAKE_GENERATOR=Ninja \
    CMAKE_EXPORT_COMPILE_COMMANDS=ON

WORKDIR /workspace
CMD ["/bin/bash"]
