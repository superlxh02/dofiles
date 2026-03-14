# =============================================================================
# base-dev — 最小 C/C++ 基底；vcpkg 若需单独再装见上文分段
# =============================================================================

FROM fedora:latest

ARG DNF_CLEAN="dnf clean all && rm -rf /var/cache/dnf /tmp/*"

RUN dnf update -y && dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    m4 autoconf automake libtool pkgconf-pkg-config \
    gcc gcc-c++ make cmake ninja-build gdb \
    git curl wget ca-certificates \
    python3 python3-pip \
    && eval "$DNF_CLEAN"

WORKDIR /workspace
CMD ["/bin/bash"]
