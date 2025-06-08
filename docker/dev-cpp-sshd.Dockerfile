# 用户名dev
#密码:123456


FROM fedora:latest

# Configure Chinese mirror sources
RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' /etc/yum.repos.d/*.repo

# Install basic dependencies
RUN dnf update -y && \
    dnf install -y \
    perl git wget curl zip unzip net-tools telnet htop openssh-server rsync\
    gcc gcc-c++ make cmake gdb \
    clang clangd llvm lldb \
    automake autoconf libtool \
    valgrind kernel-devel perf strace sudo && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Configure SSH for password authentication
RUN ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    echo "AllowUsers dev" >> /etc/ssh/sshd_config

# Create dev user with password
RUN useradd -m -u 1000 -s /bin/bash dev && \
    echo "dev:123456" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/dev/.ssh && \
    chmod 700 /home/dev/.ssh && \
    chown dev:dev /home/dev/.ssh
    
# Create workspace directory
RUN mkdir -p /home/dev/workspace && \
chown dev:dev /home/dev/workspace

# Install vcpkg as dev user
USER dev
WORKDIR /home/dev
RUN git clone https://github.com/Microsoft/vcpkg.git /home/dev/vcpkg && \
    /home/dev/vcpkg/bootstrap-vcpkg.sh

# Set environment variables
ENV VCPKG_ROOT=/home/dev/vcpkg \
    PATH="/home/dev/vcpkg:${PATH}" \
    CMAKE_TOOLCHAIN_FILE=/home/dev/vcpkg/scripts/buildsystems/vcpkg.cmake

# Configure bash environment
RUN echo 'export PATH="/home/dev/vcpkg:$PATH"' >> ~/.bashrc && \
    echo 'export VCPKG_ROOT=/home/dev/vcpkg' >> ~/.bashrc && \
    echo 'export CMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake' >> ~/.bashrc && \
    echo 'source ~/.bashrc' >> ~/.bash_profile

# Fix permissions for vcpkg
USER root
RUN chown -R dev:dev /home/dev/vcpkg && \
    chmod -R 775 /home/dev/vcpkg

# Expose SSH port and start service
EXPOSE 22
VOLUME /home/dev/workspace
CMD ["/usr/sbin/sshd", "-D", "-e"]