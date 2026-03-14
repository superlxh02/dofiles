#!/bin/bash
#
# macOS 一键安装：基础工具链、多语言开发环境、终端与编辑器，并拷贝 dofiles 配置到对应目录。
# 仅支持 macOS，非 macOS 直接退出。
#

set -e

# ------------------------------------------------------------------------------
# 1. 仅允许在 macOS 上执行
# ------------------------------------------------------------------------------
if [[ "$(uname)" != "Darwin" ]]; then
    echo "此脚本仅支持 macOS，当前系统: $(uname)。退出。" >&2
    exit 1
fi

# dofiles 仓库根目录（脚本位于 scripts/install.sh）
DOFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"

echo "[1/7] Xcode Command Line Tools..."
# xcode-select --install 会弹出系统安装 UI，命令行会立即返回，不会等用户点完“安装”。
# 若未安装就直接继续，后续 brew 等会失败。因此：未安装时只弹窗并退出，装好后请重新执行本脚本。
if ! xcode-select -p &>/dev/null; then
    echo "未检测到 Command Line Tools，将打开安装程序。请在弹窗中完成安装后重新运行本脚本。"
    xcode-select --install
    exit 1
fi

# ------------------------------------------------------------------------------
# 2. Homebrew
# ------------------------------------------------------------------------------
echo "[2/7] 检查 Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "正在安装 Homebrew（可选中国镜像：将下方 URL 改为 gitee/cunkai/HomebrewCN 等）..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 安装器结束时 brew 可能还不在当前会话 PATH，需按官方提示把 shellenv 写入 zprofile 并立刻 eval
BREW_BIN=""
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$p" ]] && BREW_BIN="$p" && break
done
if [[ -z "$BREW_BIN" ]]; then
    echo "未找到 brew，请按 Homebrew 安装完成后的提示把 PATH 配好后再运行本脚本。" >&2
    exit 1
fi
ZPROFILE="${ZDOTDIR:-$HOME}/.zprofile"
if [[ -f "$ZPROFILE" ]] && grep -qF 'brew shellenv' "$ZPROFILE" 2>/dev/null; then
    :
else
    echo "写入 ${ZPROFILE}：eval \"\$(${BREW_BIN} shellenv)\""
    touch "$ZPROFILE"
    echo "" >> "$ZPROFILE"
    echo "# Homebrew (added by dofiles install.sh)" >> "$ZPROFILE"
    echo "eval \"\$(${BREW_BIN} shellenv)\"" >> "$ZPROFILE"
fi
eval "$("$BREW_BIN" shellenv)"

if command -v brew &>/dev/null; then
    brew update
fi

# ------------------------------------------------------------------------------
# 3. 基础工具链
# ------------------------------------------------------------------------------
echo "[3/7] 安装基础工具链..."
brew install \
    make pkg-config \
    ripgrep fd fzf bat lsd jq \
    tree htop

# ------------------------------------------------------------------------------
# 4. 常用语言开发环境
# ------------------------------------------------------------------------------
echo "[4/7] 安装语言开发环境..."

# C++ 全套：LLVM/Clang、CMake、Ninja、GDB 等（fish 里已配置 LLVM PATH）
brew install cmake ninja llvm gdb

# Java（LTS）
brew install openjdk@21

# Go
brew install go

# Rust
brew install rust

# Python：Homebrew Miniconda，安装后修复 conda 的 shebang（cask 构建机路径导致 bad interpreter）
brew install python
brew install --cask miniconda
# Cask 可能装在 Caskroom/miniconda/base 或带版本号的子目录
CONDA_BIN=$(find "$(brew --prefix)/Caskroom/miniconda" -type f -path '*/bin/conda' 2>/dev/null | head -1)
CONDA_ROOT=""
if [[ -n "$CONDA_BIN" ]]; then
    CONDA_ROOT="$(dirname "$(dirname "$CONDA_BIN")")"
fi
if [[ -z "$CONDA_ROOT" || ! -f "$CONDA_ROOT/bin/conda" ]]; then
    echo "未找到 Homebrew 安装的 Miniconda，请检查 brew install --cask miniconda 是否成功。" >&2
    exit 1
fi
if [[ -x "$CONDA_ROOT/bin/python" ]]; then
    # 将 conda 脚本首行 shebang 改为本机 base 的 python，避免 cask 自带的错误路径
    sed -i '' "1s|^#!.*|#!$CONDA_ROOT/bin/python|" "$CONDA_ROOT/bin/conda"
fi
# 接受 Anaconda 频道服务条款，否则 conda create 会报 CondaToSNonInteractiveError
"$CONDA_ROOT/bin/conda" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
"$CONDA_ROOT/bin/conda" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
echo "创建 conda 环境 py-base-env（python=3.12）..."
"$CONDA_ROOT/bin/conda" create -n py-base-env python=3.12 -y

# ------------------------------------------------------------------------------
# 4b. Zsh：Oh My Zsh + 插件 + 配置文件拷贝
# ------------------------------------------------------------------------------
echo "[4b/7] Zsh：安装 Oh My Zsh、插件并拷贝配置..."
brew install zsh
export ZSH="$HOME/.oh-my-zsh"
if [[ ! -d "$ZSH" ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
if [[ -f "$DOFILES_ROOT/zsh/.zshrc" ]]; then
    cp "$DOFILES_ROOT/zsh/.zshrc" "$HOME/.zshrc"
    echo "  已拷贝 ~/.zshrc"
fi

# ------------------------------------------------------------------------------
# 5. Fish / Neovim / Kitty / Fastfetch / Tmux / AeroSpace
# ------------------------------------------------------------------------------
echo "[5/7] 安装 Fish、Neovim、Kitty、Fastfetch、Tmux、AeroSpace..."
brew install fish neovim tmux fastfetch
brew install --cask kitty
brew install --cask nikitabobko/tap/aerospace

# 将 fish 加入合法 shell（需重启终端后 chsh 生效）
FISH_BIN="$(brew --prefix)/bin/fish"
if [[ -x "$FISH_BIN" ]] && ! grep -qF "$FISH_BIN" /etc/shells; then
    echo "将 fish 加入 /etc/shells，需要 sudo。"
    echo "$FISH_BIN" | sudo tee -a /etc/shells
fi
echo "若要将 fish 设为默认 shell，请执行: chsh -s $FISH_BIN"

# ------------------------------------------------------------------------------
# 6. 拷贝 dofiles 配置到对应目录
# ------------------------------------------------------------------------------
echo "[6/7] 拷贝 dofiles 配置（fish / kitty / tmux / aerospace / fastfetch）..."

# Fish
if [[ -d "$DOFILES_ROOT/fish" ]]; then
    mkdir -p "$HOME/.config/fish"
    if [[ -f "$DOFILES_ROOT/fish/config.fish" ]]; then
        # 将 conda 路径改为本机 Homebrew Miniconda 实际路径（兼容 Intel / Apple Silicon）
        sed "s|/opt/homebrew/Caskroom/miniconda/base|${CONDA_ROOT}|g" \
            "$DOFILES_ROOT/fish/config.fish" > "$HOME/.config/fish/config.fish"
    fi
    for f in fish_plugins fish_variables; do
        [[ -e "$DOFILES_ROOT/fish/$f" ]] && cp "$DOFILES_ROOT/fish/$f" "$HOME/.config/fish/"
    done
    echo "  Fish 配置已拷贝到 ~/.config/fish/"
fi

# Kitty
if [[ -d "$DOFILES_ROOT/kitty" ]]; then
    mkdir -p "$HOME/.config/kitty"
    for f in kitty.conf current-theme.conf; do
        [[ -f "$DOFILES_ROOT/kitty/$f" ]] && cp "$DOFILES_ROOT/kitty/$f" "$HOME/.config/kitty/"
    done
    echo "  Kitty 配置已拷贝到 ~/.config/kitty/"
fi

# Tmux：.tmux.conf + TPM
if [[ -f "$DOFILES_ROOT/tmux/.tmux.conf" ]]; then
    cp "$DOFILES_ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
    echo "  Tmux 配置已拷贝到 ~/.tmux.conf"
fi
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    mkdir -p "$HOME/.tmux/plugins"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "  TPM 已安装到 ~/.tmux/plugins/tpm（进入 tmux 后按 prefix+I 安装插件）"
fi

# AeroSpace
if [[ -f "$DOFILES_ROOT/aerospace/.aerospace.toml" ]]; then
    cp "$DOFILES_ROOT/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
    echo "  AeroSpace 配置已拷贝到 ~/.aerospace.toml"
fi

# Fastfetch
if [[ -d "$DOFILES_ROOT/fastfetch" ]]; then
    mkdir -p "$HOME/.config/fastfetch"
    for f in "$DOFILES_ROOT/fastfetch/"*.jsonc; do
        [[ -f "$f" ]] && cp "$f" "$HOME/.config/fastfetch/"
    done
    echo "  Fastfetch 配置已拷贝到 ~/.config/fastfetch/"
fi

# ------------------------------------------------------------------------------
# 7. Neovim（需终端交互，放最后）：备份 → 克隆 AstroNvim → 用 dofiles 的 lua 覆盖（含 keymaps.lua）
# ------------------------------------------------------------------------------
if [[ -d "$DOFILES_ROOT/nvim" ]]; then
    echo "[7/7] Neovim：备份、克隆 AstroNvim、覆盖 ~/.config/nvim/lua（替换模板自带 keymaps）..."
    for dir in "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
        if [[ -d "$dir" ]]; then
            bak="${dir}.bak"
            echo "  备份 $dir -> $bak"
            rm -rf "$bak"
            mv "$dir" "$bak"
        fi
    done
    echo "  克隆 AstroNvim 模板到 ~/.config/nvim..."
    git clone --depth 1 https://github.com/AstroNvim/template "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
    echo "  用 dofiles 的 lua 覆盖 ~/.config/nvim/lua/（替换模板自带的 keymaps.lua 等）..."
    if [[ -d "$DOFILES_ROOT/nvim/lua" ]]; then
        mkdir -p "$HOME/.config/nvim/lua"
        for f in "$DOFILES_ROOT/nvim/lua/"*; do
            [[ -e "$f" && "$(basename "$f")" != "readme.md" ]] && cp -R "$f" "$HOME/.config/nvim/lua/"
        done
    fi
    echo "  Neovim 就绪；首次运行 nvim 会拉取插件（可能需终端交互）。"
fi

echo ""
echo "安装完成。请重新打开终端（或 exec fish）；进入 tmux 后按 prefix+I 安装插件；首次运行 nvim 会拉取插件。"
