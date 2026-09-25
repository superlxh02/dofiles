# Neovim / AstroNvim 开发环境

这套覆盖配置面向 AstroNvim v5，提供 C/C++（含 CMake）、Go、Rust、Python、
Docker，以及 TypeScript/JavaScript、React/TSX、Vue、HTML/CSS、Tailwind 前端开发。

AstroNvim 自带 Neo-tree、Aerial、ToggleTerm、nvim-dap 和 DAP UI；这里通过
AstroCommunity 语言包补齐 LSP、格式化、代码检查和各语言调试适配器，并增加
调试变量的行内显示。界面使用 Catppuccin Mocha，图标使用 AstroNvim v5 原生的
`mini.icons` Nerd Font 图标提供器。

## 安装到现有 AstroNvim

先备份，再把本仓库的覆盖文件合并进去：

```bash
cp -R ~/.config/nvim ~/.config/nvim.bak
mkdir -p ~/.config/nvim/lua/plugins
cp nvim/lua/community.lua ~/.config/nvim/lua/community.lua
cp nvim/lua/plugins/development.lua ~/.config/nvim/lua/plugins/development.lua
cp nvim/lua/plugins/theme.lua ~/.config/nvim/lua/plugins/theme.lua
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp tmux/.tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
```

如果使用 WezTerm，再执行：

```bash
mkdir -p ~/.config/wezterm
cp -R wezterm/. ~/.config/wezterm/
```

重启终端（或在 Kitty 中按 `Cmd+Ctrl+,` 重载配置），启动 Neovim 后执行：

```vim
:Lazy sync
:MasonToolsInstallSync
:checkhealth
```

然后完全退出并重新打开 Neovim。首次安装工具会花几分钟。

如果还没有 AstroNvim，可先初始化模板：

```bash
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

仓库根目录的 `bash scripts/install.sh` 也会初始化模板并复制整个 `nvim/lua`
覆盖层。

## 提供的语言工具

| 范围 | 主要组件 |
|---|---|
| C/C++ / CMake | clangd、clangd-extensions、cmake-tools、codelldb |
| Go | gopls、goimports、Delve、nvim-dap-go |
| Rust | rustaceanvim、rust-analyzer、codelldb、crates.nvim |
| Python | basedpyright、Black、isort、debugpy、虚拟环境选择器 |
| 前端 | vtsls、Vue/HTML/CSS/Tailwind LSP、ESLint、Prettierd、js-debug-adapter |
| Docker | Docker/YAML LSP、Hadolint、Treesitter |

Rust 的 `rust-analyzer` 不由社区包自动安装。如果使用 rustup：

```bash
rustup component add rust-analyzer rustfmt clippy
```

如果使用 Homebrew 安装的 Rust：

```bash
brew install rust-analyzer
```

Docker 文件的编辑、补全和检查不要求守护进程；真正构建/运行容器仍需安装
Docker Desktop，或 `docker` CLI + Colima。

## 快捷键完整说明

本文中的 `Space` 是 Leader 键，`Cmd` 是 macOS Command 键。除非单独标注，
快捷键都在普通模式中使用。按下 `Space` 后稍等片刻，which-key 会显示当前可用
的后续按键；插件尚未加载或当前语言服务器不支持的操作不会出现在菜单中。

这里列出的是这套配置、AstroNvim 和已启用插件定义的快捷键。Vim 自带的
移动、操作符、文本对象和 Ex 命令数量很多，不在这里重复列出。

### 最常用快捷键

| 快捷键 | 功能 |
|---|---|
| `Space e` | 打开/关闭文件树（Neo-tree） |
| `Space a` / `Space l S` | 打开/关闭代码结构树（Aerial） |
| `Ctrl+h/j/k/l` | 切换到左/下/上/右窗口，包括终端窗口 |
| `Ctrl+方向键` | 向对应方向调整分屏大小 |
| `Ctrl+Shift+反引号` / `F7` | 打开/关闭底部终端 |
| `Ctrl+Shift+/` / `F8` | 打开/关闭悬浮终端 |
| `Space f f` | 查找文件 |
| `Space f w` | 全项目搜索文本 |
| `Cmd+F` / `F2` | 当前文件搜索与批量替换 |
| `Cmd+Shift+F` / `F3` | 工作区搜索与批量替换 |
| `Cmd+P` / `F4` | 打开居中悬浮文件查找 |
| `Space l f` | 格式化当前文件或选区 |
| `Space /` | 注释/取消注释当前行或选区 |
| `F5` | 启动或继续调试 |
| `F9` | 切换断点 |
| `F10` / `F11` / `Shift+F11` | 单步跳过/进入/跳出 |

### macOS 编辑键

| 模式 | 快捷键 | 功能 |
|---|---|---|
| 普通 | `Cmd+C` | 复制当前行到系统剪贴板 |
| 可视 | `Cmd+C` | 复制选区到系统剪贴板 |
| 普通、插入、终端、命令行 | `Cmd+V` | 从系统剪贴板粘贴 |
| 可视 | `Cmd+V` | 用系统剪贴板内容替换选区 |
| 普通、插入 | `Cmd+Z` | 撤销 |
| 普通、插入 | `Cmd+Shift+Z` | 重做 |
| 普通、插入 | `Cmd+S` | 保存当前文件 |

Kitty 的 `Ctrl+Shift+C/V` 仍用于复制/粘贴终端选区；`Cmd+Ctrl+Z` 用于
最大化 tmux 面板，因此 `Cmd+Z` 可以交给 Neovim 撤销。

### 文件、窗口、标签页和 Buffer

| 快捷键 | 功能 |
|---|---|
| `Space w` / `Ctrl+s` | 保存 / 强制保存 |
| `Space q` / `Ctrl+q` | 退出当前窗口 / 强制退出当前窗口 |
| `Space Q` | 退出全部 Neovim 窗口 |
| `Space n` | 新建空文件 |
| `Space R` | 重命名当前文件 |
| 竖线键 / 反斜杠键 | 垂直分屏 / 水平分屏 |
| `Ctrl+h/j/k/l` | 切换到左/下/上/右分屏 |
| `Ctrl+Up/Down/Left/Right` | 调整分屏大小 |
| `]b` / `[b` | 下一个 / 上一个 Buffer |
| `>b` / `<b` | 当前 Buffer 标签右移 / 左移 |
| `Space c` / `Space C` | 关闭 / 强制关闭当前 Buffer |
| `Space b b` | 从标签栏选择 Buffer |
| `Space b` 后接反斜杠键 / 竖线键 | 在水平 / 垂直分屏打开选中的 Buffer |
| `Space b d` | 从标签栏选择并关闭 Buffer |
| `Space b c` | 关闭除当前以外的 Buffer |
| `Space b C` | 关闭所有 Buffer |
| `Space b l` / `Space b r` | 关闭当前 Buffer 左侧 / 右侧的 Buffer |
| `Space b p` | 回到上一个 Buffer |
| `Space b s e/r/p/i/m` | 按扩展名/相对路径/完整路径/编号/修改状态排序 |
| `]t` / `[t` | 下一个 / 上一个标签页 |
| `Space h` | 返回 AstroNvim 首页 |

普通和可视模式中的 `j`、`k` 已调整为：没有数字前缀时按屏幕显示行移动，
有数字前缀时仍按实际文件行移动。

### 查找与搜索

| 快捷键 | 功能 |
|---|---|
| `Cmd+F` / `F2` | 用 Spectre 搜索/替换当前文件 |
| `Cmd+Shift+F` / `F3` | 用 Spectre 搜索/替换整个工作区 |
| `Cmd+P` / `F4` | 打开无预览分区的居中悬浮文件查找窗口 |
| `Space s s` | 打开工作区搜索/替换 |
| `Space s f` | 打开当前文件搜索/替换 |
| 可视模式 `Space s w` | 使用选中的文字开始搜索/替换 |
| `Space f f` | 在当前目录查找文件 |
| `Space f F` | 查找所有文件，包括通常被忽略的文件 |
| `Space f g` | 查找 Git 跟踪的文件 |
| `Space f w` | 在当前目录搜索文本 |
| `Space f W` | 在所有文件中搜索文本 |
| `Space f c` | 搜索光标下的单词 |
| `Space f b` | 查找已打开的 Buffer |
| `Space f s` | 综合搜索 Buffer、最近文件和文件 |
| `Space f l` | 搜索当前 Buffer 的行 |
| `Space f o` / `Space f O` | 最近文件 / 当前目录内的最近文件 |
| `Space f p` | 查找项目 |
| `Space f r` | 查找寄存器 |
| `Space f '` | 查找标记（marks） |
| `Space f u` | 查找撤销历史 |
| `Space f T` | 查找 TODO/FIXME 等注释 |
| `Space f C` | 查找命令 |
| `Space f k` | 查找快捷键 |
| `Space f h` | 查找帮助文档 |
| `Space f m` | 查找 man 手册 |
| `Space f n` | 查找通知历史 |
| `Space f t` | 预览并选择主题 |
| `Space f a` | 查找 AstroNvim 配置文件 |
| `Space f Enter` | 恢复上一次搜索界面 |

`Cmd` 组合键由 Kitty 转发为 `F2`、`F3`、`F4`，因此在 tmux 内也能稳定工作；
直接使用相应功能键可以获得完全相同的效果。

Spectre 界面中先填写搜索词和替换词。普通模式按 `o` 打开选项菜单，可切换
大小写敏感、忽略大小写、隐藏文件等参数；`R` 执行全部替换，`C` 替换当前项，
`v` 切换结果显示方式，`q` 把结果发送到 Quickfix。正则搜索默认可用；若要按
普通文本匹配，可在选项中启用 literal/fixed-string 方式。执行批量替换前会先
显示 diff 结果，建议确认无误后再按 `R`。

### Markdown 渲染与预览

打开 `.md` 或 `.mdx` 文件后，render-markdown 会在普通模式中渲染标题、代码块、
表格、列表、复选框、引用、链接和公式等元素；进入插入模式时显示便于编辑的原始
Markdown。Marksman 同时提供 Markdown LSP 补全和跳转。

| 快捷键 | 功能 |
|---|---|
| `Space M r` | 打开/关闭当前 Neovim 内的 Markdown 渲染 |
| `Space M v` | 在 Neovim 侧边打开完整渲染预览 |
| `Space M p` | 在浏览器启动实时 Markdown 预览 |
| `Space M t` | 打开/关闭浏览器实时预览 |
| `Space M s` | 停止浏览器预览服务 |

对应命令是 `:RenderMarkdown toggle`、`:RenderMarkdown preview`、
`:MarkdownPreview`、`:MarkdownPreviewToggle` 和 `:MarkdownPreviewStop`。

### LSP、代码与诊断

以下 LSP 键只在语言服务器成功附加到当前文件后有效。

| 快捷键 | 功能 |
|---|---|
| `K` | 显示光标下符号的文档 |
| `gd` / `gD` | 跳转到定义 / 声明 |
| `gri` | 跳转到实现 |
| `grr` / `Space l R` | 查找引用 |
| `grn` / `Space l r` | 重命名符号 |
| `grt` / `gy` | 跳转到类型定义 |
| `gra` / `Space l a` | 执行代码操作；可视模式下作用于选区 |
| `Space l A` | 执行 source 级代码操作，例如整理 import |
| `gK` / `Space l h` | 显示函数签名帮助 |
| `gO` | 显示当前文档符号 |
| `Space l s` | 搜索当前文件符号 |
| `Space l G` | 搜索工作区符号 |
| `Space l l` / `Space l L` | 刷新 / 运行 CodeLens |
| `Space l f` | 格式化当前 Buffer；可视模式下格式化选区 |
| `Space l d` / `gl` | 悬浮显示当前行诊断信息 |
| `Space l D` | 搜索全部诊断信息 |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `[D` / `]D` | 第一个 / 最后一个诊断 |
| `[e` / `]e` | 上一个 / 下一个错误 |
| `[w` / `]w` | 上一个 / 下一个警告 |
| `[r` / `]r` | 上一个 / 下一个引用 |
| `Ctrl+w d` | 显示光标处诊断信息 |
| `Space l S` / `Space a` | 打开/关闭符号结构树 |
| `[y` / `]y` | 上一个 / 下一个代码符号 |
| `[Y` / `]Y` | 上一个 / 下一个上层代码符号 |
| `Space l w` | C/C++ 源文件与头文件互相切换 |
| `Space l v` | Python 选择虚拟环境 |

插入模式下 `Ctrl+s` 显示函数签名帮助。`Space l w` 只在 clangd 附加后出现，
`Space l v` 只在 Python 开发组件可用时出现。

### 自动补全和编辑

| 模式 | 快捷键 | 功能 |
|---|---|---|
| 插入 | `Ctrl+Space` | 打开补全菜单或切换补全文档 |
| 插入 | `Down` / `Ctrl+n` / `Ctrl+j` | 选择下一条补全候选 |
| 插入 | `Up` / `Ctrl+p` / `Ctrl+k` | 选择上一条补全候选 |
| 插入 | `Enter` | 接受补全候选 |
| 插入 | `Ctrl+e` | 关闭补全菜单 |
| 插入 | `Ctrl+u` / `Ctrl+d` | 向上 / 向下滚动补全文档 |
| 插入 | `Tab` / `Shift+Tab` | 下一/上一候选，或向前/向后跳转代码片段占位符 |
| 普通 | `Space /` / `gcc` | 注释/取消注释当前行 |
| 可视 | `Space /` / `gc` | 注释/取消注释选区 |
| 普通 | `gco` / `gcO` | 在下方 / 上方新增注释行 |
| 可视 | `Tab` / `Shift+Tab` | 增加 / 减少缩进并保持选区 |
| 普通/可视 | `gx` | 使用系统程序打开光标下的路径或网址 |

### 调试（DAP，VS Code 风格）

| 快捷键 | 功能 |
|---|---|
| `F5` / `Space d c` | 启动或继续 |
| `Ctrl+F5` / `Space d r` | 重新开始当前栈帧 |
| `Shift+F5` / `Space d Q` | 停止并终止调试会话 |
| `F6` / `Space d p` | 暂停 |
| `F9` / `Space d b` | 切换普通断点 |
| `Shift+F9` / `Space d C` | 添加条件断点 |
| `Space d B` | 清除所有断点 |
| `F10` / `Space d o` | Step Over，单步跳过 |
| `F11` / `Space d i` | Step Into，单步进入 |
| `Shift+F11` / `Space d O` | Step Out，单步跳出 |
| `Space d s` | 运行到光标位置 |
| `Space d q` | 关闭当前调试会话 |
| `Space d R` | 打开/关闭调试 REPL |
| `Space d u` | 打开/关闭调试 UI |
| `Space d h` | 查看光标下变量 |
| `Space d E` | 计算表达式；可视模式下计算选中内容 |

### 终端

| 快捷键 | 功能 |
|---|---|
| `Ctrl+Shift+反引号` / `F7` | 打开/关闭编号 1 的底部终端 |
| `Ctrl+Shift+/` / `F8` | 打开/关闭编号 2 的悬浮终端 |
| `Ctrl+'` | 打开/关闭当前 ToggleTerm 终端 |
| `Space t f` | 悬浮终端 |
| `Space t h` | 水平终端 |
| `Space t v` | 垂直终端 |
| `Space t p` | Python REPL |
| `Space t n` | Node.js REPL |
| `Space t l` | 悬浮 lazygit |
| 终端内 `Ctrl+h/j/k/l` | 从终端切换到左/下/上/右窗口 |

部分终端无法把 `Ctrl+Shift` 组合直接传给 Neovim，所以同时保留了始终可靠的
`F7`、`F8` 备用键。当前仓库中的 Kitty 和 WezTerm 配置已经负责转发这些组合键。

### Git

| 快捷键 | 功能 |
|---|---|
| `Space g g` | 打开/关闭 lazygit |
| `Space g t` | 搜索 Git 状态 |
| `Space g b` | 搜索 Git 分支 |
| `Space g c` | 搜索仓库提交记录 |
| `Space g C` | 搜索当前文件提交记录 |
| `Space g T` | 搜索 stash |
| `Space g o` | 在浏览器打开当前文件或选区对应的远端地址 |

### UI 开关

| 快捷键 | 功能 |
|---|---|
| `Space u b` | 切换明暗背景 |
| `Space u n` | 切换行号显示方式 |
| `Space u g` / `Space u >` | 切换 signcolumn / foldcolumn |
| `Space u w` | 切换自动换行 |
| `Space u s` | 切换拼写检查 |
| `Space u S` | 切换 conceal 隐藏文本 |
| `Space u p` | 切换粘贴模式 |
| `Space u i` | 修改缩进设置 |
| `Space u l` / `Space u t` | 切换状态栏 / Buffer 标签栏 |
| `Space u d` | 切换诊断显示 |
| `Space u v` / `Space u V` | 切换诊断虚拟文本 / 虚拟行 |
| `Space u c` / `Space u C` | 切换当前 Buffer / 全局自动补全 |
| `Space u f` / `Space u F` | 切换当前 Buffer / 全局保存时自动格式化 |
| `Space u h` / `Space u H` | 切换当前 Buffer / 全局 LSP 内联提示 |
| `Space u r` / `Space u R` | 切换当前 Buffer / 全局引用高亮 |
| `Space u L` | 切换 CodeLens |
| `Space u Y` | 切换当前 Buffer 的 LSP 语义高亮 |
| `Space u ?` | 切换自动签名帮助 |
| `Space u y` | 切换当前 Buffer 的语法高亮 |
| `Space u z` | 切换颜色值高亮 |
| `Space u` 后接竖线键 | 切换缩进引导线 |
| `Space u u` | 切换 URL 高亮 |
| `Space u A` | 切换自动项目根目录 |
| `Space u N` / `Space u D` | 切换通知界面 / 清除通知 |
| `Space u Z` | 切换专注模式（Zen Mode） |
| `Space u a` | 切换自动括号 |

### 插件、会话和列表

| 快捷键 | 功能 |
|---|---|
| `Space p s` | 打开 Lazy 插件状态页 |
| `Space p i` / `Space p S` | 安装缺失插件 / 同步插件 |
| `Space p u` / `Space p U` | 检查插件更新 / 更新插件 |
| `Space p a` | 同时更新 Lazy 插件和 Mason 工具 |
| `Space p m` / `Space p M` | 打开 Mason / 更新 Mason 注册表 |
| `Space S s` / `Space S f` | 保存 / 加载会话 |
| `Space S l` | 加载上一次会话 |
| `Space S d` | 删除会话 |
| `Space S S` / `Space S F` | 保存 / 加载当前目录会话 |
| `Space S D` | 删除当前目录会话 |
| `Space S t` | 保存当前标签页会话 |
| `Space x q` / `Space x l` | 打开 Quickfix / Location List |
| `]q` / `[q` | Quickfix 下一项 / 上一项 |
| `]Q` / `[Q` | Quickfix 最后一项 / 第一项 |
| `]l` / `[l` | Location List 下一项 / 上一项 |
| `]L` / `[L` | Location List 最后一项 / 第一项 |

### Neo-tree 文件管理器内部

用 `Space e` 打开/关闭文件树，`Space o` 在编辑窗口和已打开的文件树之间切换
焦点。下面的按键只在 Neo-tree 窗口内生效；随时按 `?` 可以查看完整帮助。

| 快捷键 | 功能 |
|---|---|
| `Enter` / `l` | 打开文件，或展开目录 |
| `O` / `Shift+Enter` | 使用系统默认程序打开文件 |
| `h` | 收起目录，或回到父目录 |
| `Space` | 展开/收起当前节点 |
| `Tab` | 选择节点 |
| `Ctrl+s` | 显示快速跳转标签并跳转 |
| `Ctrl+Shift+i` / `Ctrl+;` | 反选 / 清空选择 |
| `s` / `S` / `t` | 在垂直分屏 / 水平分屏 / 新标签页打开 |
| `w` | 选择目标窗口后打开 |
| `P` | 打开/关闭浮动预览 |
| `Ctrl+f` / `Ctrl+b` | 向下 / 向上滚动预览 |
| `a` / `A` | 新建文件 / 目录 |
| `r` / `b` | 重命名完整文件名 / 仅基础名称 |
| `d` / `T` | 删除 / 移到废纸篓 |
| `u` / `U` | 撤销移到废纸篓 / 从废纸篓恢复 |
| `y` / `x` / `p` | 复制 / 剪切 / 粘贴节点 |
| `c` / `m` | 复制到指定路径 / 移动到指定路径 |
| `Y` | 选择并复制节点名称、路径等信息 |
| `i` | 显示文件详细信息 |
| `e` | 切换文件树自动宽度 |
| `Ctrl+r` | 清空 Neo-tree 内部剪贴板 |
| `R` | 刷新文件树 |
| `H` | 显示/隐藏被过滤项目和隐藏文件 |
| `/` / `D` / `#` | 模糊查找文件 / 目录 / 模糊排序 |
| `f` / `Ctrl+x` | 输入过滤条件 / 清除过滤 |
| `Backspace` / `.` | 返回上级目录 / 将当前目录设为根目录 |
| `[g` / `]g` | 上一个 / 下一个 Git 修改项 |
| `[b` / `]b` | 上一个 / 下一个 Neo-tree 数据源 |
| `<` / `>` | 上一个 / 下一个 Neo-tree 数据源 |
| `o` 后接 `c/d/g/m/n/s/t` | 按创建时间/诊断/Git/修改时间/名称/大小/类型排序 |
| `T f` / `T h` / `T v` | 在当前节点目录打开悬浮/水平/垂直终端 |
| `C` / `z` | 收起当前节点 / 收起所有节点 |
| `q` | 关闭 Neo-tree 窗口 |

切换到 Neo-tree 的 Git Status 数据源后，还可以使用：`ga` 暂存文件、`gu` 取消
暂存、`gt` 切换暂存状态、`gr` 丢弃文件修改、`gc` 提交、`gp` 推送、`gl` 拉取、
`gg` 提交并推送、`A` 暂存全部文件。

### Aerial 代码结构树内部

先用 `Space a` 打开结构树。下面的按键只在 Aerial 窗口内生效；按 `?` 查看
面板内帮助。

| 快捷键 | 功能 |
|---|---|
| `Enter` | 跳转到当前符号 |
| `Ctrl+v` / `Ctrl+s` | 在垂直 / 水平分屏跳转 |
| `p` | 预览当前符号但保持焦点在结构树 |
| `Ctrl+j` / `Ctrl+k` | 下移 / 上移并同步预览 |
| `[y` / `]y` | 上一个 / 下一个符号 |
| `[Y` / `]Y` | 上一个 / 下一个上层符号 |
| `o` / `za` | 展开/收起当前节点 |
| `O` / `zA` | 递归展开/收起当前节点 |
| `l` / `zo` | 展开当前节点 |
| `L` / `zO` | 递归展开当前节点 |
| `h` / `zc` | 收起当前节点 |
| `H` / `zC` | 递归收起当前节点 |
| `zR` / `zM` | 展开全部 / 收起全部 |
| `zr` / `zm` | 增加 / 减少展开层级 |
| `zx` / `zX` | 根据当前结构同步折叠状态 |
| `q` | 关闭 Aerial |

## 开始调试

1. 在需要暂停的位置按 `F9`。
2. 按 `F5`，首次会让你选择启动配置；C/C++ 会要求选择已编译的可执行文件。
3. CMake 项目可以先运行 `:CMakeBuild`，再按 `F5`；也可以用
   `:CMakeDebug` 让 cmake-tools 直接启动当前目标。
4. 如果项目已有 VS Code 的 `.vscode/launch.json`，nvim-dap 会直接读取它。

检查问题时常用：

```vim
:LspInfo
:Mason
:DapShowLog
:checkhealth
```
