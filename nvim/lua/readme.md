# Neovim / AstroNvim

## 备份现有配置（可选）

```bash
mv ~/.config/nvim ~/.config/nvim.bak

mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

## 克隆 AstroNvim 模板

```bash
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
# 去掉模板自带 git，方便之后接自己的仓库
rm -rf ~/.config/nvim/.git
nvim
```
