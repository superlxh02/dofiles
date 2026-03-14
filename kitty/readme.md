# Kitty（Linux）

以下步骤假设已安装 Kitty AppImage 到 `~/.local/kitty.app`，且 `~/.local/bin` 已在系统 `PATH` 中。

## 创建符号链接（加入 PATH）

```bash
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
```

## 桌面集成

```bash
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# 若需用文件管理器用 kitty 打开文本/图片，一并复制：
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
```

## 修正 desktop 中的路径与图标

```bash
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
```

## xdg-terminal-exec

使支持 xdg-terminal-exec 的桌面环境默认使用 kitty：

```bash
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
```
