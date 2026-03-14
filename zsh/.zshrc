# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export TERM=xterm-256color

source /opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh
conda activate py-base-env

alias ls='lsd'
alias cat='bat'
alias t='tmux'
alias apple-clang='/usr/bin/clang'
alias apple-clang++='/usr/bin/clang++'

export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources