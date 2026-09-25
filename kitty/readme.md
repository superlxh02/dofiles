# Kitty 快捷键说明

仓库配置是 `kitty.conf`，macOS 实际配置是
`~/.config/kitty/kitty.conf`。以下只说明 Kitty 自身功能；tmux 的快捷键单独见
`../tmux/readme.md`。

## 当前自定义快捷键

| 快捷键 | Kitty 动作 |
| --- | --- |
| `Cmd+C` | 复制选中的终端文本到系统剪贴板 |
| `Cmd+V` | 从系统剪贴板粘贴 |
| `Ctrl+Shift+C` | 复制选中的终端文本（备用键） |
| `Ctrl+Shift+V` | 从系统剪贴板粘贴（备用键） |
| `Cmd+S` | 向前台程序发送 `Esc :w Enter`，供 Vim/Neovim 保存 |
| `Cmd+Shift+F` | 向前台程序发送 `:Telescope live_grep` |
| `Cmd+B` | 向前台程序发送 `:Neotree toggle` |

复制和粘贴由 Kitty 直接处理，在普通 Fish、tmux 和 Neovim 中行为一致；这两个
Command 按键不会再通过 Kitty keyboard protocol 转发给 Neovim。

`Cmd+P` 在配置中出现两次，后面的映射覆盖前面的 Telescope 映射，因此不要把
它当作 Kitty/Vim 的文件查找快捷键。配置中还有一组把按键转发给终端内程序的
映射，它们不属于 Kitty 窗口管理；具体功能以对应程序的 README 为准。

## 仍可使用的 Kitty 原生快捷键（macOS）

| 快捷键 | 功能 |
| --- | --- |
| `Cmd+T` | 新建标签页 |
| `Cmd+Shift+]` / `Cmd+Shift+[` | 下一个 / 上一个标签页 |
| `Cmd+Enter` | 在当前标签页中新建 Kitty 窗口（pane） |
| `Cmd+Shift+D` | 关闭当前 Kitty 窗口（pane） |
| `Cmd+R` | 进入调整 Kitty 窗口大小模式 |
| `Cmd+F` | 搜索回滚缓冲区 |
| `Ctrl+Shift+H` | 在分页器中打开回滚历史 |
| `Cmd++` / `Cmd+-` / `Cmd+0` | 放大 / 缩小 / 重置字体 |
| `Ctrl+Cmd+F` | 切换全屏 |
| `Ctrl+Cmd+Space` | 输入 Unicode 字符 |
| `Ctrl+Cmd+,` | 重新加载 Kitty 配置 |
| `Ctrl+Shift+F1` | 显示 Kitty 快捷键帮助 |

注意：Kitty 的若干 macOS 默认键（例如 `Cmd+N`、`Cmd+W`、`Cmd+1`～`9`、
`Cmd+方向键` 和 `Cmd+,`）已被当前 `kitty.conf` 覆盖，不再执行默认动作。

### Neovim 搜索

| Kitty 快捷键 | 发送给 Neovim | 功能 |
|---|---|---|
| `Cmd+F` | `F2` | 当前文件搜索与批量替换 |
| `Cmd+Shift+F` | `F3` | 工作区搜索与批量替换 |
| `Cmd+P` | `F4` | 居中悬浮文件查找 |

这里使用功能键转发，是为了让快捷键经过 tmux 后仍然可靠。原来的 tmux“上一个
窗口”改为 `Cmd+Shift+P`。

## Linux 桌面集成

以下步骤假设 Kitty AppImage 位于 `~/.local/kitty.app`，且
`~/.local/bin` 已加入 `PATH`：

```bash
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

echo 'kitty.desktop' > ~/.config/xdg-terminals.list
```
