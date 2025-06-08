FROM fedora:latest

# Configure Chinese mirror sources
RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' /etc/yum.repos.d/*.repo

#基本依赖
RUN dnf update -y && \
    dnf install -y \
    perl git wget curl zip unzip\
    gcc gcc-c++ make cmake gdb clangd \
    automake autoconf libtool  \
    valgrind  kernel-devel perf strace  && \
    dnf clean all

#扩展依赖
RUN dnf update -y && \
    dnf install -y \
    vim  net-tools telnet htop\
    xmake conan \
    bcc-tools bpftrace \
    ltrace heaptrack smem sysstat wireshark tcpdump &&\
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

WORKDIR /workspace

CMD ["/bin/bash"]