FROM ubuntu

RUN apt-get update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  vim gawk perl git wget curl net-tools telnet htop \
  gcc g++ make cmake gdb \
  clangd clang llvm lldb xmake \
  valgrind bpfcc-tools bpftrace linux-headers-generic linux-tools-generic \
  strace ltrace heaptrack smem sysstat tcpdump \
  automake autoconf libtool \
  wireshark \
  python3-pip \
  && apt-get clean \
  && ln -s /usr/lib/linux-tools/*/perf /usr/local/bin/perf

RUN wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-arm64 
RUN  chmod +x /usr/local/bin/bazel

# 安装 vcpkg 到 /opt/vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git /opt/vcpkg \
    && /opt/vcpkg/bootstrap-vcpkg.sh

# 添加 vcpkg 到 PATH
ENV VCPKG_ROOT=/opt/vcpkg
ENV PATH="$VCPKG_ROOT:$PATH"
ENV CMAKE_TOOLCHAIN_FILE=/opt/vcpkg/scripts/buildsystems/vcpkg.cmakeh

WORKDIR /workspace

CMD ["/bin/bash"]
