# Tmux 配置说明

仓库配置文件为 `.tmux.conf`，实际使用的配置文件为 `~/.tmux.conf`。
tmux 保留默认前缀键 `Ctrl+B`。下文中的 `Prefix` 均表示：先按
`Ctrl+B`，松开后再按后续按键。

## Kitty 快捷键

这些快捷键配置在 `../kitty/kitty.conf` 中。Kitty 会自动向 tmux
发送前缀键，因此不需要再手动按 `Ctrl+B`。

| Kitty 快捷键 | 发送给 tmux | 功能 |
| --- | --- | --- |
| `Cmd+1`～`Cmd+9` | `Prefix 1`～`Prefix 9` | 切换到编号 1～9 的窗口 |
| `Cmd+Shift+H` | `Prefix "` | 将当前面板上下分屏 |
| `Cmd+Shift+V` | `Prefix %` | 将当前面板左右分屏 |
| `Cmd+X` | `Prefix x` | 关闭当前面板，需要确认 |
| `Cmd+↑` | `Prefix ↑` | 切换到上方面板 |
| `Cmd+↓` | `Prefix ↓` | 切换到下方面板 |
| `Cmd+←` | `Prefix ←` | 切换到左侧面板 |
| `Cmd+→` | `Prefix →` | 切换到右侧面板 |
| `Cmd+Ctrl+↑` | `Prefix Ctrl+↑` | 向上调整面板大小 |
| `Cmd+Ctrl+↓` | `Prefix Ctrl+↓` | 向下调整面板大小 |
| `Cmd+Ctrl+←` | `Prefix Ctrl+←` | 向左调整面板大小 |
| `Cmd+Ctrl+→` | `Prefix Ctrl+→` | 向右调整面板大小 |
| `Cmd+N` | `Prefix c` | 新建窗口 |
| `Cmd+W` | `Prefix &` | 关闭当前窗口，需要确认 |
| `Cmd+P` | `Prefix p` | 切换到上一个窗口 |
| `Cmd+Shift+N` | `Prefix n` | 切换到下一个窗口 |
| `Cmd+Z` | `Prefix z` | 最大化或恢复当前面板 |
| `Cmd+,` | `Prefix ,` | 重命名当前窗口 |
| `Cmd+L` | `Prefix w` | 打开窗口和面板选择列表 |

这些按键应在 tmux 会话内使用。在普通 Shell 中按下时，Kitty 仍会发送
`Ctrl+B` 和后续按键。

## tmux 原生按键

不使用 Kitty 映射时，可以手动按对应的 tmux 按键：

| tmux 按键 | 功能 |
| --- | --- |
| `Prefix c` | 新建窗口 |
| `Prefix 1`～`Prefix 9` | 切换到指定编号的窗口 |
| `Prefix p` | 上一个窗口 |
| `Prefix n` | 下一个窗口 |
| `Prefix &` | 关闭当前窗口 |
| `Prefix "` | 上下分屏 |
| `Prefix %` | 左右分屏 |
| `Prefix ↑/↓/←/→` | 在面板之间切换 |
| `Prefix Ctrl+↑/↓/←/→` | 调整当前面板大小 |
| `Prefix x` | 关闭当前面板 |
| `Prefix z` | 最大化或恢复当前面板 |
| `Prefix ,` | 重命名当前窗口 |
| `Prefix w` | 打开窗口和面板选择列表 |
| `Prefix [` | 进入复制模式 |
| `Prefix d` | 从当前会话分离 |
| `Prefix ?` | 显示全部有效 tmux 按键 |

## 复制模式

配置使用 Vi 风格复制模式。先按 `Prefix [` 进入复制模式：

| 按键 | 功能 |
| --- | --- |
| `v` | 开始选择文本 |
| `Ctrl+V` | 切换矩形选择 |
| `y` | 复制选中内容并退出复制模式 |

`tmux-yank` 会把复制内容同步到系统剪贴板。配置同时开启了鼠标支持，
可以使用鼠标选择面板、调整边界和滚动。

## Vim/Neovim 面板导航

`vim-tmux-navigator` 提供无需 tmux 前缀的跨 Vim 和 tmux 面板导航：

| 快捷键 | 功能 |
| --- | --- |
| `Ctrl+H` | 切换到左侧 Vim 窗口或 tmux 面板 |
| `Ctrl+J` | 切换到下方 Vim 窗口或 tmux 面板 |
| `Ctrl+K` | 切换到上方 Vim 窗口或 tmux 面板 |
| `Ctrl+L` | 切换到右侧 Vim 窗口或 tmux 面板 |
| `Ctrl+\\` | 切换到上一次使用的面板 |

## TPM 插件管理

首次安装 TPM：

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

| 快捷键 | 功能 |
| --- | --- |
| `Prefix I` | 安装配置中声明的插件并刷新环境 |
| `Prefix U` | 更新插件 |
| `Prefix Alt+U` | 删除配置中已不再使用的插件 |

## 配置生效

修改 `.tmux.conf` 后，可在 tmux 中执行：

```text
Prefix :
source-file ~/.tmux.conf
```

也可以退出并重新创建 tmux 会话。
