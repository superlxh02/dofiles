#!/usr/bin/env bash
# macOS：安装开发工具链，并把本仓库管理的配置部署到标准位置。
#
# 明确不做：安装/配置 WezTerm、构建 Dockerfile、启动容器、启动 OrbStack、
# 自动执行 Neovim/Lazy/Mason。首次打开相应程序时再完成其自身初始化。

set -Eeuo pipefail
trap 'echo "安装失败：第 ${LINENO} 行执行出错。" >&2' ERR

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "此脚本仅支持 macOS，当前系统: $(uname -s)。" >&2
    exit 1
fi

readonly DOFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly BACKUP_ROOT="${HOME}/.dofiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKUP_CREATED=false

backup_file() {
    local target="$1"
    local relative_target backup_target

    [[ -f "${target}" || -L "${target}" ]] || return 0
    relative_target="${target#"${HOME}/"}"
    backup_target="${BACKUP_ROOT}/${relative_target}"
    mkdir -p "$(dirname "${backup_target}")"
    cp -p "${target}" "${backup_target}"
    BACKUP_CREATED=true
}

deploy_file() {
    local source="$1"
    local target="$2"

    [[ -f "${source}" ]] || return 0
    if [[ -f "${target}" ]] && cmp -s "${source}" "${target}"; then
        return 0
    fi
    backup_file "${target}"
    mkdir -p "$(dirname "${target}")"
    install -m 0644 "${source}" "${target}"
}

echo "[1/9] 检查 Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
    echo "未检测到 Command Line Tools，将打开系统安装器；安装完成后请重新运行本脚本。"
    xcode-select --install
    exit 1
fi

echo "[2/9] 安装或更新 Homebrew"
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_BIN=""
for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "${candidate}" ]]; then
        BREW_BIN="${candidate}"
        break
    fi
done
if [[ -z "${BREW_BIN}" ]]; then
    echo "Homebrew 安装后仍未找到 brew。" >&2
    exit 1
fi

ZPROFILE="${ZDOTDIR:-${HOME}}/.zprofile"
BREW_MARKER="# Homebrew (managed by dofiles install.sh)"
if ! grep -qF "${BREW_MARKER}" "${ZPROFILE}" 2>/dev/null; then
    backup_file "${ZPROFILE}"
    mkdir -p "$(dirname "${ZPROFILE}")"
    touch "${ZPROFILE}"
    printf '\n%s\neval "$(%s shellenv)"\n' "${BREW_MARKER}" "${BREW_BIN}" >>"${ZPROFILE}"
fi
eval "$("${BREW_BIN}" shellenv)"
brew update

echo "[3/9] 安装命令行工具与开发工具链"
# macOS 已自带 bash、curl、make 和 zsh，因此不重复安装。
# 不安装 gdb：macOS 上需要额外 codesign，Neovim 使用 codelldb/LLDB。
# 不安装 mold：Homebrew 当前版本已移除 Mach-O 目标支持。
BREW_FORMULAE=(
    autoconf
    automake
    bat
    ccache
    cmake
    coreutils
    cppcheck
    fastfetch
    fd
    fish
    fzf
    gcc
    git
    go
    htop
    jq
    lazygit
    libtool
    llvm
    lsd
    meson
    nasm
    neovim
    ninja
    node
    openjdk@21
    pkgconf
    pnpm
    python
    ripgrep
    rustup
    shellcheck
    tmux
    tree
    uv
    wget
    xz
    yq
)
brew install "${BREW_FORMULAE[@]}"

echo "[4/9] 初始化 Rust 工具链"
RUSTUP_BIN="$(brew --prefix rustup)/bin/rustup"
"${RUSTUP_BIN}" toolchain install stable --profile default
"${RUSTUP_BIN}" default stable
"${RUSTUP_BIN}" component add rust-analyzer rust-src rustfmt clippy

echo "[5/9] 安装桌面程序、字体和容器运行时"
brew tap FelixKratz/formulae
brew tap nikitabobko/tap

# AeroSpace 的 after-startup-command 会调用 borders。
brew install borders

BREW_CASKS=(
    aerospace
    font-mononoki-nerd-font
    kitty
    miniconda
)

MACOS_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
if ((MACOS_MAJOR >= 14)); then
    BREW_CASKS+=(orbstack)
else
    # OrbStack 要求 macOS 14 或更新版本；旧系统使用 Docker Desktop。
    BREW_CASKS+=(docker)
fi
brew install --cask "${BREW_CASKS[@]}"

echo "[6/9] 初始化 Python 环境"
CONDA_BIN="$(find "$(brew --prefix)/Caskroom/miniconda" -type f -path '*/bin/conda' -print -quit 2>/dev/null || true)"
if [[ -z "${CONDA_BIN}" ]]; then
    echo "未找到 Miniconda 的 conda 可执行文件。" >&2
    exit 1
fi
CONDA_ROOT="$(dirname "$(dirname "${CONDA_BIN}")")"
if "${CONDA_BIN}" tos --help &>/dev/null; then
    "${CONDA_BIN}" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    "${CONDA_BIN}" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
fi
if [[ ! -d "${CONDA_ROOT}/envs/py-base-env" ]]; then
    "${CONDA_BIN}" create -n py-base-env python=3.12 -y
else
    echo "  Conda 环境 py-base-env 已存在，跳过创建。"
fi

echo "[7/9] 安装 Shell 插件"
ZSH="${HOME}/.oh-my-zsh"
export ZSH
if [[ ! -d "${ZSH}" ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH}/custom}"
mkdir -p "${ZSH_CUSTOM}/plugins"
if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions/.git" ]]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi
if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/.git" ]]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

echo "[8/9] 部署配置并安装 Fish/Tmux 插件"
deploy_file "${DOFILES_ROOT}/zsh/.zshrc" "${HOME}/.zshrc"
deploy_file "${DOFILES_ROOT}/fish/config.fish" "${HOME}/.config/fish/config.fish"
deploy_file "${DOFILES_ROOT}/fish/fish_plugins" "${HOME}/.config/fish/fish_plugins"
# fish_variables 保存机器专属 universal variables，不跨机器覆盖。

deploy_file "${DOFILES_ROOT}/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
deploy_file "${DOFILES_ROOT}/kitty/current-theme.conf" "${HOME}/.config/kitty/current-theme.conf"
deploy_file "${DOFILES_ROOT}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
deploy_file "${DOFILES_ROOT}/aerospace/.aerospace.toml" "${HOME}/.aerospace.toml"
for source_file in "${DOFILES_ROOT}/fastfetch/"*.jsonc; do
    [[ -f "${source_file}" ]] || continue
    deploy_file "${source_file}" "${HOME}/.config/fastfetch/$(basename "${source_file}")"
done

FISH_BIN="$(brew --prefix)/bin/fish"
if ! "${FISH_BIN}" -c 'type -q fisher'; then
    "${FISH_BIN}" -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher'
fi
if [[ -f "${DOFILES_ROOT}/fish/fish_plugins" ]]; then
    "${FISH_BIN}" -c 'fisher update'
fi

TPM_ROOT="${HOME}/.tmux/plugins/tpm"
if [[ ! -d "${TPM_ROOT}/.git" ]]; then
    mkdir -p "${HOME}/.tmux/plugins"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "${TPM_ROOT}"
fi
TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins" "${TPM_ROOT}/bin/install_plugins"

if [[ -x "${FISH_BIN}" ]] && ! grep -qxF "${FISH_BIN}" /etc/shells; then
    echo "将 Fish 加入 /etc/shells（需要 sudo）"
    printf '%s\n' "${FISH_BIN}" | sudo tee -a /etc/shells >/dev/null
fi

echo "[9/9] 初始化并部署 Neovim 配置"
NVIM_ROOT="${HOME}/.config/nvim"
if [[ ! -e "${NVIM_ROOT}" ]]; then
    git clone --depth 1 https://github.com/AstroNvim/template "${NVIM_ROOT}"
    rm -rf "${NVIM_ROOT}/.git"
fi

# 只覆盖本仓库明确管理的 Lua 文件，不删除模板或用户的其他文件。
while IFS= read -r -d '' source_file; do
    relative_file="${source_file#"${DOFILES_ROOT}/nvim/lua/"}"
    [[ "${relative_file}" == "readme.md" ]] && continue
    deploy_file "${source_file}" "${NVIM_ROOT}/lua/${relative_file}"
done < <(find "${DOFILES_ROOT}/nvim/lua" -type f -print0)

echo
echo "安装与配置部署完成。"
if [[ "${BACKUP_CREATED}" == true ]]; then
    echo "被覆盖的旧配置已备份到：${BACKUP_ROOT}"
fi
echo "如需把 Fish 设为默认 Shell：chsh -s ${FISH_BIN}"
echo "请手动打开 OrbStack/Docker Desktop 完成首次初始化；脚本没有构建任何 Docker 镜像。"
echo "首次启动 Neovim 时会自动下载插件；本脚本没有启动 Neovim。"
