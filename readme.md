# dofiles

个人 dotfiles / 配置文件仓库：shell、终端、编辑器、窗口管理等环境搭建说明与配置。克隆或同步本仓库后，可用一键脚本（macOS）或按各子目录 readme 手动配置。

---

## 快速开始（macOS）

在仓库根目录执行：

```bash
bash scripts/install.sh
```

脚本会：检测并提示安装 Xcode Command Line Tools、安装/配置 Homebrew、安装基础工具与多语言开发环境（C++/Java/Go/Rust/Python）、安装 Zsh + Oh My Zsh 并拷贝配置、安装 Fish / Neovim / Kitty / Fastfetch / Tmux / AeroSpace、将本仓库对应配置拷贝到 `~/.config` 等目录，最后克隆 AstroNvim 并合并本仓库的 Neovim 配置。**仅支持 macOS**，非 macOS 会直接退出。若未安装 Command Line Tools，会弹窗提示安装，完成后再重新执行本脚本。

安装完成后：重新打开终端或执行 `exec fish`；进入 tmux 后按 **Ctrl+b** 再按 **I** 安装 TPM 插件；首次运行 `nvim` 会拉取插件。

---

## 脚本说明

| 脚本 | 适用系统 | 说明 |
|------|----------|------|
| [scripts/install.sh](scripts/install.sh) | **macOS** | 一键安装 Homebrew、工具链、多语言环境、Zsh/Fish/Neovim/Kitty/Tmux/AeroSpace 等，并拷贝本仓库配置到对应目录 |
| [scripts/ubuntu_install.sh](scripts/ubuntu_install.sh) | Ubuntu | 开发环境安装（基础工具、C/C++、Qt、内核分析、多语言、Docker 等） |
| [scripts/fedora_install.sh](scripts/fedora_install.sh) | Fedora | 同上，基于 dnf |
| [scripts/brew-llvm.sh](scripts/brew-llvm.sh) | macOS | 供 source 使用，将 Homebrew LLVM 加入 PATH/LDFLAGS/CPPFLAGS（fish 配置中已含等效设置可略） |

---

## 目录结构

| 目录 | 说明 |
|------|------|
| [fish](fish/readme.md) | Fish shell 配置；Oh My Fish (OMF) 安装说明 |
| [zsh](zsh/readme.md) | Zsh / Oh My Zsh、语法高亮与自动建议插件、Powerlevel10k 主题 |
| [tmux](tmux/readme.md) | Tmux 配置与 TPM 插件管理器；安装插件：进入 tmux 后 **Ctrl+b** 再按 **I** |
| [kitty](kitty/readme.md) | Kitty 终端配置（含 Linux 安装与桌面集成） |
| [wezterm](wezterm/readme.md) | WezTerm 安装（Flatpak / Ubuntu / AppImage） |
| [spaceship](spaceship/readme.md) | Spaceship prompt 安装与使用 |
| [nvim/lua](nvim/lua/readme.md) | Neovim / AstroNvim：备份说明、克隆模板；本仓库提供 `lua/config` 等覆盖配置 |
| [aerospace](aerospace/.aerospace.toml) | AeroSpace 平铺窗口管理器配置（macOS）；拷贝 `.aerospace.toml` 到 `~/.aerospace.toml` |
| [fastfetch](fastfetch/) | Fastfetch 配置（多套 jsonc）；拷贝到 `~/.config/fastfetch/` |
| [docker](docker/readme.md) | C/C++ 开发 Docker 镜像（Fedora/Ubuntu/Rocky、SSH 版、Rawhide、Dev Container）与一键构建脚本 |

---

## 手动配置

若不使用 `scripts/install.sh`，可：

1. 将对应目录下的配置文件拷贝到系统约定路径（如 `~/.config/fish`、`~/.tmux.conf`、`~/.zshrc` 等）。
2. 按各子目录中的 **readme** 完成依赖安装（Oh My Zsh、TPM、AstroNvim、字体等）。

Neovim 需先按 [nvim/lua/readme.md](nvim/lua/readme.md) 备份并克隆 AstroNvim 模板，再将本仓库 `nvim/lua` 下内容合并到 `~/.config/nvim/lua/`。
