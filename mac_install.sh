#!/bin/bash

# macOS开发环境安装脚本
# 使用Homebrew安装C/C++、Python、Rust、Java、Go开发环境及现代化开发工具

set -e  # 遇到错误时退出

echo "🚀 开始安装macOS开发环境..."
echo "======================================"

# 首先安装Xcode命令行工具（Homebrew的依赖）
echo "🔧 检查Xcode命令行工具..."
if ! xcode-select -p &> /dev/null; then
    echo "⚠️  Homebrew依赖Xcode命令行工具，正在安装..."
    xcode-select --install
    echo "请在弹出的对话框中完成Xcode命令行工具的安装"
    echo "这是Homebrew正常工作的必要条件"
    read -p "安装完成后按回车键继续..."
else
    echo "✅ Xcode命令行工具已安装"
fi

# 检查是否已安装Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew未安装，正在使用中国镜像安装Homebrew..."
    /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
    echo "✅ Homebrew安装完成"
else
    echo "✅ Homebrew已安装，正在更新..."
    brew update
fi

echo ""
echo "======================================"
echo "🔧 开始安装开发工具和编程语言..."
echo "======================================"

# 安装基础开发工具
echo "📋 安装基础开发工具..."
brew install git
brew install curl
brew install wget
brew install tree
brew install htop
echo "✅ 基础开发工具安装完成"

# 安装C/C++开发环境
echo ""
echo "🔨 配置C/C++开发环境..."
echo "✅ C/C++编译器已通过Xcode命令行工具提供（clang/clang++）"

# 安装额外的C/C++工具（移除gdb，因为macOS不支持）
brew install cmake
brew install make
echo "✅ C/C++开发环境配置完成"

# 安装Python开发环境（更新版本）
echo ""
echo "🐍 安装Python开发环境..."

# 安装Miniconda（轻量级conda）
echo "📦 安装Miniconda..."
brew install --cask miniconda
echo 'export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"' >> ~/.zshrc
# 初始化conda
/opt/homebrew/Caskroom/miniconda/base/bin/conda init zsh
echo "✅ Miniconda安装完成"
# 重新加载环境变量以使conda命令可用
source ~/.zshrc || true
export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"

# 设置conda默认Python版本为3.10.8
echo "🐍 配置conda默认Python版本..."
# 创建一个名为python3108的环境，使用Python 3.10.8
conda create -n my-base-env python=3.10.8 -y
# 激活环境
conda activate my-base-env
# 设置为默认环境（修改.condarc配置）
echo "auto_activate_base: false" > ~/.condarc
echo "default_environment: my-base-env" >> ~/.condarc
echo "✅ conda默认Python版本设置为3.10.8"
# 安装Python包管理工具
echo "📦 安装Python包管理工具..."
python -m pip install --upgrade pip
python -m pip install virtualenv
python -m pip install pipenv
python -m pip install poetry
echo "✅ Python包管理工具安装完成"

# 安装Rust开发环境
echo ""
echo "🦀 安装Rust开发环境..."
brew install rust
echo "✅ Rust开发环境安装完成"

# 安装Java开发环境
echo ""
echo "☕ 安装Java开发环境..."
# 安装OpenJDK
brew install openjdk@11
brew install openjdk@21
# 设置JAVA_HOME环境变量
echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"' >> ~/.zshrc

echo "✅ Java开发环境安装完成"

# 安装Go开发环境
echo ""
echo "🐹 安装Go开发环境..."
brew install go
# 设置Go环境变量
echo 'export GOPATH="$HOME/go"' >> ~/.zshrc
echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.zshrc
echo "✅ Go开发环境安装完成"

# 安装现代化终端和编辑器
echo ""
echo "🖥️  安装现代化终端和编辑器..."

# 安装Neovim（现代化的Vim）
echo "📝 安装Neovim..."
brew install neovim
echo "✅ Neovim安装完成"

# 安装现代化终端模拟器
echo "🖥️  安装终端模拟器..."
brew install --cask wezterm    # 现代化终端模拟器
brew install --cask kitty      # 快速的终端模拟器
echo "✅ 终端模拟器安装完成"

# 安装Neovide（Neovim的GUI前端）
echo "🎨 安装Neovide..."
brew install --cask neovide
echo "✅ Neovide安装完成"

# 安装Fish Shell（用户友好的shell）
echo "🐠 安装Fish Shell..."
brew install fish
# 将fish添加到可用shell列表
echo '/opt/homebrew/bin/fish' | sudo tee -a /etc/shells
echo "✅ Fish Shell安装完成"
chsh -s /opt/homebrew/bin/fish

# 安装tmux（终端复用器）
echo "📺 安装tmux..."
brew install tmux
echo "✅ tmux安装完成"


# 安装版本控制工具
echo ""
echo "📝 配置Git..."
echo "请设置你的Git用户信息："
read -p "请输入你的Git用户名: " git_username
read -p "请输入你的Git邮箱: " git_email
git config --global user.name "$git_username"
git config --global user.email "$git_email"
echo "✅ Git配置完成"

# 配置Fish Shell环境变量
echo "🐠 配置Fish Shell环境变量..."
# 创建Fish配置目录
mkdir -p ~/.config/fish

# 创建Fish配置文件，同步zsh中的环境变量
cat > ~/.config/fish/config.fish << 'EOF'
#基础环境变量
  set -x PATH /opt/homebrew/bin $PATH
    set -x PATH /usr/local/bin $PATH

# Miniconda配置
set -gx PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH

# 初始化conda for fish
if test -f "/opt/homebrew/Caskroom/miniconda/base/bin/conda"
    eval "/opt/homebrew/Caskroom/miniconda/base/bin/conda" "shell.fish" "hook" $argv | source
end

# 激活默认conda环境
if test -f "/opt/homebrew/Caskroom/miniconda/base/bin/conda"
    conda activate my-base-env
end

# Java环境变量
set -gx JAVA_HOME "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"

# Go环境变量
set -gx GOPATH "$HOME/go"
set -gx PATH "$GOPATH/bin" $PATH
EOF

echo "✅ Fish Shell环境变量配置完成"

# 为Fish Shell初始化conda
echo "🐍 为Fish Shell初始化conda..."
/opt/homebrew/Caskroom/miniconda/base/bin/conda init fish
echo "✅ Fish Shell conda初始化完成"



echo ""
echo "======================================"
echo "🎉 开发环境安装完成！"
echo "======================================"
echo "🔄 请重新启动终端或运行以下命令来刷新环境变量："
echo "source ~/.zshrc"