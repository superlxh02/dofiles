#!/bin/bash

#macos工具链
xcode-select --install

# 检查是否已安装Homebrew
if ! command -v brew &> /dev/null; then
    echo "正在使用中国镜像安装Homebrew..."
    /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
else
    brew update
fi

#主流语言开发环境
brew install cmake rust go openjdk@11 

# 安装Miniconda（轻量级conda）
brew install --cask miniconda

#其他工具
brew install neovim
brew install --cask kitty      
brew install --cask neovide
brew install fish
echo '/opt/homebrew/bin/fish' | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
brew install tmux






