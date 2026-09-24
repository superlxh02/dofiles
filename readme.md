# dofiles

个人 macOS 开发环境与 dotfiles 仓库，覆盖 Shell、终端、Tmux、Neovim、窗口管理、
常用命令行工具，以及 C/C++、CMake、Go、Rust、Python、Java、前端和 Docker
开发环境。

## 快速开始

安装脚本仅支持 macOS。克隆仓库后，在仓库根目录执行：

```bash
bash scripts/install.sh
```

执行前建议先阅读 [scripts/readme.md](scripts/readme.md)，了解将安装的软件、配置
目标、备份位置和明确不会执行的操作。脚本需要网络连接；安装 Xcode Command
Line Tools、Homebrew 或把 Fish 加入 `/etc/shells` 时，macOS 可能弹窗或要求 sudo。

## 安装内容

| 范围 | 主要组件 |
|---|---|
| C/C++ 与构建 | Apple Command Line Tools、LLVM/LLDB、GCC、CMake、Ninja、Meson、ccache、cppcheck、autoconf、automake、libtool、pkgconf、nasm |
| Go | Go 工具链；gopls、Delve 等由 Neovim/Mason 管理 |
| Rust | rustup、stable toolchain、rust-analyzer、rust-src、rustfmt、Clippy |
| Python | Homebrew Python、uv、Miniconda、`py-base-env`（Python 3.12） |
| Java | OpenJDK 21 |
| 前端 | Node.js、npm/npx、pnpm |
| 容器 | macOS 14 及以上安装 OrbStack；旧版 macOS安装 Docker Desktop |
| 编辑与终端 | Neovim、AstroNvim 配置、Kitty、Fish、Zsh/Oh My Zsh、Tmux |
| 桌面工具 | AeroSpace、borders、Mononoki Nerd Font、Fastfetch |

另外会安装 Git、ripgrep、fd、fzf、bat、lsd、jq、yq、lazygit、ShellCheck 等常用
命令行工具。

## 脚本明确不会做什么

- 不安装或部署 WezTerm；`wezterm/` 只保留为手动参考配置。
- 不运行 `docker build`，不调用 `docker/build_images.py`，不构建任何 Dockerfile。
- 不启动 OrbStack、Docker Desktop、容器或虚拟机。
- 不自动启动 Neovim，也不执行 Lazy/Mason 的安装命令。
- 不删除现有 Neovim 配置；只覆盖仓库明确管理的 Lua 文件。
- 不复制 Fish 的 `fish_variables`，避免覆盖机器专属 universal variables。

## 配置部署位置

已有目标文件内容不同时，会先备份到
`~/.dofiles-backup/YYYYMMDD-HHMMSS/`，再部署新配置。

| 仓库内容 | 实际位置 |
|---|---|
| `zsh/.zshrc` | `~/.zshrc` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/fish_plugins`（存在时） | `~/.config/fish/fish_plugins` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `kitty/current-theme.conf` | `~/.config/kitty/current-theme.conf` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `aerospace/.aerospace.toml` | `~/.aerospace.toml` |
| `fastfetch/*.jsonc` | `~/.config/fastfetch/` |
| `nvim/lua/` 中除 README 外的文件 | `~/.config/nvim/lua/` 对应路径 |

如果 `~/.config/nvim` 不存在，脚本会先克隆 AstroNvim 模板；如果已经存在，则只
合并本仓库的个性化配置，不清空原目录。

## 安装完成后

1. 重新打开终端，让 Homebrew 和工具链 PATH 生效。
2. 如需把 Fish 设为默认 Shell，执行 `chsh -s "$(brew --prefix)/bin/fish"`。
3. 手动打开 OrbStack 或 Docker Desktop，完成其首次初始化。
4. 第一次打开 `nvim`，等待插件下载完成；需要时执行
   `:Lazy sync`、`:MasonToolsInstallSync` 和 `:checkhealth`。

Neovim 的语言支持、调试方法和完整快捷键见
[nvim/lua/readme.md](nvim/lua/readme.md)。

## 脚本

| 脚本 | 说明 |
|---|---|
| [scripts/install.sh](scripts/install.sh) | macOS 软件安装、工具链初始化、旧配置备份和新配置部署 |
| [scripts/brew-llvm.sh](scripts/brew-llvm.sh) | 按需 `source`，把 Homebrew LLVM 的 bin、lib、include 和 pkg-config 路径加入当前 Shell |

详细说明见 [scripts/readme.md](scripts/readme.md)。

## 目录

| 目录 | 说明 |
|---|---|
| [scripts](scripts/readme.md) | macOS 安装脚本、执行阶段、软件清单和安全边界 |
| [nvim/lua](nvim/lua/readme.md) | AstroNvim 个性化覆盖、语言工具、调试和完整快捷键 |
| [fish](fish/readme.md) | Fish 配置；安装脚本使用 Fisher 管理插件 |
| [zsh](zsh/readme.md) | Zsh、Oh My Zsh、自动建议和语法高亮 |
| [tmux](tmux/readme.md) | Tmux、TPM、Catppuccin 和跨 Neovim 面板导航 |
| [kitty](kitty/readme.md) | Kitty 终端与快捷键配置 |
| [aerospace](aerospace/.aerospace.toml) | AeroSpace 平铺窗口管理器配置 |
| [fastfetch](fastfetch/) | Fastfetch 的多套 JSONC 配置 |
| [docker](docker/readme.md) | Docker 开发镜像和手动构建说明；安装脚本不会自动构建 |
| [wezterm](wezterm/readme.md) | 可选的手动参考配置；安装脚本不会处理 |
| [spaceship](spaceship/readme.md) | 可选的 Spaceship prompt 使用说明 |

## 手动部署

不使用一键脚本时，可以按“配置部署位置”表手动复制文件。Neovim 建议先备份
`~/.config/nvim`，再按照 [Neovim 说明](nvim/lua/readme.md)初始化 AstroNvim 并
合并本仓库的 `nvim/lua` 覆盖层。

Docker 镜像只按 [Docker 说明](docker/readme.md)手动构建，不属于 dotfiles
安装流程。
