ohmyzsh安装： sh -c "$(curl -fsSL https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh)"

下载语法高亮和提升插件
执行1.：git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
执行2： git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
（2）下载p10k主题：git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ~/powerlevel10k
（3）修改zsh配置文件
1 . vim ~/.zshrc 
2. 找到有ZSH_THEME 这一行，更改成ZSH_THEME="powerlevel10k/powerlevel10k"
3.找到这个:plugins=(git)一行
改成：plugins=(git zsh-autosuggestions  zsh-syntax-highlighting )
4.保存后  source ~/.zshrc 
不出意外的话，会进入到p10k的配置界面（如果需要更改p10k的配置 终端输入：p10k configure 