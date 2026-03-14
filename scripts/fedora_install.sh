#!/bin/bash

# Fedora开发环境一键安装脚本（优先使用dnf）
# 包含基本工具、C/C++开发、内核分析、多语言环境、Docker和嵌入式开发工具

set -e  # 遇到错误时退出

echo "开始安装Fedora开发环境（优先使用dnf）..."
# 换源（可选）
#if [[ "$1" == "--change-mirror" ]] || [[ "$2" == "--change-mirror" ]]; then
    echo "更换为国内镜像源..."
    # 备份原始源
    sudo cp /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora.repo.bak
    sudo cp /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-updates.repo.bak
    
    # 使用清华大学镜像源
    sudo sed -e 's|^metalink=|#metalink=|g' \
             -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora|g' \
             -i /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
    
    # 或者使用阿里云镜像源（注释掉上面的清华源，取消注释下面的阿里源）
    # sudo sed -e 's|^metalink=|#metalink=|g' \
    #          -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.aliyun.com/fedora|g' \
    #          -i /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo
    
    echo "镜像源更换完成"
#fi
# 更新系统
echo "更新系统包..."
sudo dnf upgrade --refresh -y


# 安装基本工具
echo "安装基本工具..."
sudo dnf install -y \
    curl wget git vim neovim nano tree htop btop \
    unzip zip tar gzip bzip2 xz zstd \
    which file findutils grep sed awk ripgrep fd-find \
    bash-completion zsh fish lsd procs bat\
    tmux screen \
    jq bat  fzf

# 安装C/C++开发工具（全部用dnf）
echo "安装C/C++开发工具..."
sudo dnf install -y \
    gcc gcc-c++ gdb make cmake ninja-build meson \
    clang clang++ clang-tools-extra clang-analyzer \
    llvm llvm-devel lldb lld \
     autoconf automake libtool \
    pkgconfig pkg-config \
    valgrind strace ltrace \
    ccache distcc \
    cppcheck bear

# 安装Qt开发环境（全部用dnf）
echo "安装Qt开发环境..."
sudo dnf install -y qt6-* qt5-* qtcreator

# 安装内核性能分析工具（全部用dnf）
echo "安装内核性能分析工具..."
sudo dnf install -y \
    perf kernel-tools \
    systemtap systemtap-runtime systemtap-client systemtap-devel \
    bpftrace bcc-tools \
    sysstat iotop iftop nethogs \
    tcpdump wireshark-cli tshark \
    lsof psmisc procps-ng \
    numactl  \
    pcp pcp-gui pcp-system-tools \
    stress-ng sysbench fio

# 安装Rust开发环境（优先dnf，补充rustup）
echo "安装Rust开发环境..."
sudo dnf install -y rust cargo rust-src rust-std-static rust-analyzer


# 安装Python开发环境（全部用dnf）
echo "安装Python开发环境..."
sudo dnf install -y \
    python3 python3-pip  python3-devel \
    python3-setuptools python3-wheel \
    python3-virtualenv python3-poetry \

# 安装Go开发环境（优先dnf）
echo "安装Go开发环境..."
sudo dnf install -y golang golang-bin golang-src
# 设置Go环境变量
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

# 安装Java开发环境（全部用dnf）
echo "安装Java开发环境..."
sudo dnf install -y \
    java \

# 安装Node.js开发环境（优先dnf）
echo "安装Node.js开发环境..."
sudo dnf install -y nodejs npm yarn


# 安装Docker开发环境（使用官方仓库，因为dnf版本可能较旧）
echo "安装Docker开发环境..."
# 先尝试dnf安装
sudo dnf install -y docker docker-compose
sudo systemctl start docker
sudo usermod -aG docker $USER


# 安装嵌入式开发工具（优先dnf）
echo "安装嵌入式开发工具..."

# 安装交叉编译工具链（dnf）
sudo dnf install -y \
    gcc-arm-linux-gnu gcc-c++-arm-linux-gnu \
    gcc-aarch64-linux-gnu gcc-c++-aarch64-linux-gnu\
    binutils-arm-linux-gnu binutils-aarch64-linux-gnu \

sudo dnf install -y stlink
sudo dnf install -y openocd

# 安装其他嵌入式工具（全部用dnf）
sudo dnf install -y \
    minicom picocom screen \
    avrdude dfu-util \
    qemu-system-arm qemu-system-aarch64 qemu-system-riscv

# 安装代码编辑器和IDE（优先dnf）
echo "安装vscode..."
# VS Code（使用微软官方仓库，因为功能更完整）
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code

#刷新docker组
newgrp docker
echo "安装完成！"
echo "请重新登录或运行 'source ~/.bashrc' 来加载环境变量"
