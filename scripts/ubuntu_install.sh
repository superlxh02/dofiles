#!/bin/bash

# Ubuntu开发环境一键安装脚本
# 包含基本工具、C/C++开发、内核分析、多语言环境、Docker和嵌入式开发工具

set -e  # 遇到错误时退出

echo "开始安装Ubuntu开发环境..."

# 换源（可选）
#if [[ "$1" == "--change-mirror" ]] || [[ "$2" == "--change-mirror" ]]; then
    echo "更换为国内镜像源..."
    # 备份原始源
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    
    # 使用清华大学镜像源
    sudo sed -i 's|http://archive.ubuntu.com|https://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list
    sudo sed -i 's|http://security.ubuntu.com|https://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list
    
    # 或者使用阿里云镜像源（注释掉上面的清华源，取消注释下面的阿里源）
    # sudo sed -i 's|http://archive.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list
    # sudo sed -i 's|http://security.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list
    
    echo "镜像源更换完成"
#fi

# 更新系统
echo "更新系统包..."
sudo apt update && sudo apt upgrade -y

# 安装基本工具
echo "安装基本工具..."
sudo apt install -y \
    curl wget git vim neovim nano tree htop btop \
    unzip zip tar gzip bzip2 xz-utils zstd \
    which file findutils grep sed gawk ripgrep fd-find \
    bash-completion zsh fish \
    tmux screen \
     bat fzf

# 安装现代命令行工具（需要snap或手动安装）
sudo snap install lsd procs btop || echo "某些现代工具需要手动安装"

# 安装C/C++开发工具
echo "安装C/C++开发工具..."
sudo apt install -y \
    gcc g++ gdb make cmake ninja-build meson \
    clang  clang-tools clang-format \
    llvm llvm-dev lldb lld \
    autoconf automake libtool \
    pkg-config \
    valgrind strace ltrace \
    ccache distcc \
    cppcheck bear

# 安装Qt开发环境
echo "安装Qt开发环境..."
sudo apt install -y \
        qt6-*\
        qtcreator \


# 安装内核性能分析工具
echo "安装内核性能分析工具..."
sudo apt install -y \
    linux-tools-common linux-tools-generic \
    systemtap systemtap-runtime systemtap-client systemtap-sdt-dev \
    bpftrace bpfcc-tools \
    sysstat iotop iftop nethogs \
    tcpdump wireshark-common tshark \
    lsof psmisc procps \
    numactl \
    stress-ng sysbench fio

# 安装PCP（性能分析工具）
sudo apt install -y pcp pcp-gui || echo "PCP可能需要额外配置"

# 安装Rust开发环境
echo "安装Rust开发环境..."
sudo apt install -y rustc cargo

# 安装Python开发环境
echo "安装Python开发环境..."
sudo apt install -y \
    python3 python3-pip python3-dev \
    python3-setuptools python3-wheel \
    python3-venv python3-virtualenv


# 安装Go开发环境
echo "安装Go开发环境..."
sudo apt install -y golang-go
# 设置Go环境变量
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

# 安装Java开发环境
echo "安装Java开发环境..."
sudo apt install -y \
    default-jdk default-jre \
    openjdk-11-jdk openjdk-17-jdk

# 安装Node.js开发环境
echo "安装Node.js开发环境..."
sudo apt install -y nodejs npm
# 安装Docker开发环境
echo "安装Docker开发环境..."
# 安装Docker
# 卸载旧版本
sudo apt remove -y docker docker.io containerd runc || true

# 安装依赖
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加Docker官方GPG密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加Docker仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动Docker服务
sudo systemctl start docker
# 将用户添加到docker组
sudo usermod -aG docker $USER

# 安装嵌入式开发工具
echo "安装嵌入式开发工具..."

# 安装交叉编译工具链
sudo apt install -y \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    binutils-arm-linux-gnueabihf binutils-aarch64-linux-gnu

# 安装STLink和OpenOCD
sudo apt install -y stlink-tools openocd

# 安装其他嵌入式工具
sudo apt install -y \
    minicom picocom screen \
    avrdude dfu-util \
    qemu-system-arm qemu-system-misc

# 安装代码编辑器和IDE
echo "安装开发工具..."

# VS Code（使用微软官方仓库）
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# 清理
rm packages.microsoft.gpg
#刷新docker组
newgrp docker
echo "安装完成！"
echo "请重新登录或运行 'source ~/.bashrc' 来加载环境变量"
echo "某些工具可能需要额外配置，请查看相关文档"