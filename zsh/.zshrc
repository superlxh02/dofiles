[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# Path to your oh-my-zsh installation.
export ZSH="/Users/liuxiaohua/.oh-my-zsh"
ZSH_THEME="spaceship"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

alias ls='lsd'
alias cat='bat'
alias gcc='gcc-14'
alias cc='gcc-14'
alias g++='g++-14'
alias apple-clang='/usr/bin/clang'
alias apple-clang++='/usr/bin/clang++'
alias llf='ll $(fzf)'
alias ps='procs'
alias cman='man -M /usr/local/share/man/zh_CN'
alias t='tmux'
alias vcpkg='/Users/liuxiaohua/vcpkg/vcpkg'

export PATH=$PATH:/opt/vcpkg
export PATH="$PATH: /opt/homebrew/Cellar/llvm/19.1.7_1/bin/"
export PATH="$PATH:/Users/liuxiaohua/apache-maven-3.9.5/bin:"
export PATH="$PATH:/opt/homebrew/anaconda3/condabin"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '( cat {}) 2> /dev/null | head -500'"


export HOMEBREW_NO_AUTO_UPDATE=true
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


#startship 
eval "$(starship init zsh)"

# >>> nvm >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export OPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3

# Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles


