# Zsh / Oh My Zsh

## Oh My Zsh 安装

```bash
sh -c "$(curl -fsSL https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh)"
```

## 语法高亮与自动建议插件

**1. 自动建议**

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

**2. 语法高亮**

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Powerlevel10k 主题

```bash
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

## 修改 `~/.zshrc`

1. `vim ~/.zshrc`
2. 找到 `ZSH_THEME` 一行，改为：`ZSH_THEME="powerlevel10k/powerlevel10k"`
3. 找到 `plugins=(git)` 一行，改为：  
   `plugins=(git zsh-autosuggestions zsh-syntax-highlighting)`
4. 保存后执行：`source ~/.zshrc`

会进入 p10k 配置界面。若要重新配置主题，在终端执行：`p10k configure`
