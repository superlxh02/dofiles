FROM fedora:latest
# Configure Chinese mirror sources
RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' /etc/yum.repos.d/*.repo

RUN dnf update -y && \
  dnf install -y \
  vim gawk perl git wget curl net-tools telnet htop zip unzip openssh-server\
  gcc gcc-c++ make cmake gdb \
  clangd clang llvm lldb xmake conan valgrind \
  python pip \
  automake autoconf libtool && \
  dnf copr enable -y thebeanogamer/golang-github-bazelbuild-bazelisk && \
  dnf install -y bazelisk && \
  dnf clean all

# 安装 vcpkg 到 /opt/vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git /opt/vcpkg \
    && /opt/vcpkg/bootstrap-vcpkg.sh

# 添加 vcpkg 到 PATH
ENV VCPKG_ROOT=/opt/vcpkg
ENV PATH="$VCPKG_ROOT:$PATH"
ENV CMAKE_TOOLCHAIN_FILE=/opt/vcpkg/scripts/buildsystems/vcpkg.cmake


CMD ["/bin/bash"]
