# macOS 安装脚本

`scripts/install.sh` 用于在新的 macOS 环境中安装开发软件和工具链，然后把仓库
明确管理的配置文件部署到标准位置。脚本仅支持 macOS。

## 使用前须知

在仓库根目录运行：

```bash
bash scripts/install.sh
```

脚本会访问 Homebrew、GitHub、Anaconda 等网络服务，并可能在以下情况请求交互：

- 没有 Xcode Command Line Tools 时，打开 macOS 安装界面并退出；安装完成后需要
  再运行一次脚本。
- 首次安装 Homebrew 时，运行官方安装器。
- 将 Fish 加入 `/etc/shells` 时请求 sudo。
- Homebrew cask 或 Anaconda 服务条款需要确认时，显示对应提示。

脚本启用了 `set -Eeuo pipefail`，任一步骤失败都会停止，并报告出错行号。

## 执行阶段

1. 检查 macOS 和 Xcode Command Line Tools。
2. 安装或加载 Homebrew，并更新软件索引。
3. 安装命令行工具和多语言开发工具链。
4. 用 rustup 安装 stable Rust，以及 rust-analyzer、rust-src、rustfmt、Clippy。
5. 安装 Kitty、AeroSpace、字体、Miniconda 和容器运行时。
6. 创建 Conda `py-base-env`（Python 3.12）。
7. 安装 Oh My Zsh、自动建议和语法高亮插件。
8. 备份并部署配置，然后安装 Fisher/TPM 插件。
9. 初始化 AstroNvim 模板（仅在不存在时）并合并个性化 Lua 配置。

## 安装的软件

### Homebrew formulae

```text
autoconf automake bat ccache cmake coreutils cppcheck fastfetch fd fish
fzf gcc git go htop jq lazygit libtool llvm lsd meson nasm neovim ninja
node openjdk@21 pkgconf pnpm python ripgrep rustup shellcheck tmux tree uv
wget xz yq
```

另外从 `FelixKratz/formulae` 安装 `borders`，供 AeroSpace 启动配置调用。

macOS 自带的 Bash、curl、make 和 Zsh 不重复安装。脚本不安装 GDB，因为 macOS
调试需要额外 codesign/Mach 权限，而当前 Neovim 使用 codelldb/LLDB；也不安装
不再支持 Mach-O 目标的 mold。

### Homebrew casks

```text
aerospace
font-mononoki-nerd-font
kitty
miniconda
```

容器运行时根据系统版本选择：

- macOS 14 及以上：OrbStack。
- 更旧版本：Docker Desktop。

脚本只安装容器程序，不启动程序、不创建容器，也不构建镜像。

## 工具链说明

| 范围 | 安装结果 |
|---|---|
| C/C++ | Apple Clang、Homebrew LLVM/LLDB、GCC、CMake、Ninja、Meson、ccache、cppcheck 等 |
| Go | `go`；gopls、Delve 和代码工具由 Neovim/Mason 管理 |
| Rust | rustup stable、Cargo、rust-analyzer、rust-src、rustfmt、Clippy |
| Python | Homebrew Python、uv、Miniconda、Python 3.12 Conda 环境 `py-base-env` |
| Java | OpenJDK 21；Fish/Zsh 配置会设置 `JAVA_HOME` 和 PATH |
| 前端 | Node.js、npm、npx、pnpm |
| Docker | OrbStack 或 Docker Desktop；Dockerfile 保持手动构建 |

Fish 和 Zsh 配置会动态读取 `brew --prefix`，因此同时支持 Apple Silicon 的
`/opt/homebrew` 和 Intel Mac 的 `/usr/local`。它们会加入 LLVM、rustup、
OpenJDK 和 `~/.cargo/bin`，并在 Conda 环境存在时自动加载 `py-base-env`。

## 配置文件与目标位置

| 仓库文件 | 部署目标 |
|---|---|
| `zsh/.zshrc` | `~/.zshrc` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/fish_plugins`（可选） | `~/.config/fish/fish_plugins` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `kitty/current-theme.conf` | `~/.config/kitty/current-theme.conf` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `aerospace/.aerospace.toml` | `~/.aerospace.toml` |
| `fastfetch/*.jsonc` | `~/.config/fastfetch/` |
| `nvim/lua/community.lua` | `~/.config/nvim/lua/community.lua` |
| `nvim/lua/plugins/*.lua` | `~/.config/nvim/lua/plugins/` |

`nvim/lua/readme.md` 是文档，不会复制进 Neovim 配置目录。`fish_variables` 包含
机器专属 universal variables，也不会被脚本覆盖。

## 备份与重复运行

部署文件前，脚本会比较仓库文件和目标文件：

- 内容相同：跳过，不创建无意义备份。
- 内容不同：把旧文件复制到
  `~/.dofiles-backup/YYYYMMDD-HHMMSS/` 下对应路径，再覆盖目标。
- 目标不存在：直接创建父目录并部署。

Neovim 使用覆盖层方式部署。如果 `~/.config/nvim` 已存在，脚本不会删除整个
目录、插件数据、缓存或用户的其他文件，只处理仓库 `nvim/lua` 中明确存在的 Lua
文件。

恢复某个旧配置时，从输出中记录的备份目录复制回来即可。例如：

```bash
cp -p ~/.dofiles-backup/YYYYMMDD-HHMMSS/.zshrc ~/.zshrc
```

## 明确排除的操作

安装脚本不会：

- 安装、复制或加载 WezTerm 配置。
- 执行 `docker build` 或 `docker/build_images.py`。
- 启动 OrbStack、Docker Desktop、容器或虚拟机。
- 启动 Neovim，或执行 `:Lazy sync`、`:MasonToolsInstallSync`。
- 删除现有 `~/.config/nvim`、`~/.local/share/nvim`、`~/.cache/nvim`。
- 自动把 Fish 改为默认 Shell。

## 安装完成后

1. 重新打开终端。
2. 可选：执行 `chsh -s "$(brew --prefix)/bin/fish"` 将 Fish 设为默认 Shell。
3. 手动打开 OrbStack 或 Docker Desktop，完成首次初始化。
4. 首次运行 `nvim` 并等待插件下载；需要时运行：

```vim
:Lazy sync
:MasonToolsInstallSync
:checkhealth
```

Neovim 的详细配置与快捷键见 [../nvim/lua/readme.md](../nvim/lua/readme.md)。

## LLVM 环境辅助脚本

需要在当前 Bash/Zsh 会话中显式使用 Homebrew LLVM 的头文件和库时：

```bash
source scripts/brew-llvm.sh
```

它会设置或扩展 `PATH`、`LDFLAGS`、`CPPFLAGS` 和 `PKG_CONFIG_PATH`，并保留已有
值。如果 Homebrew 或 LLVM 不存在，会返回错误而不是写入无效路径。

## 只做静态检查

检查脚本语法而不执行安装流程：

```bash
bash -n scripts/install.sh
bash -n scripts/brew-llvm.sh
shellcheck scripts/install.sh scripts/brew-llvm.sh
```

`bash -n` 和 ShellCheck 只解析脚本，不会安装软件或复制配置。
