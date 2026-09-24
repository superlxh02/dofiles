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

if command -v brew >/dev/null 2>&1; then
	BREW_PREFIX="$(brew --prefix)"
	export PATH="${BREW_PREFIX}/opt/llvm/bin:${BREW_PREFIX}/opt/rustup/bin:${BREW_PREFIX}/opt/openjdk@21/bin:${HOME}/.cargo/bin:${PATH}"
	export JAVA_HOME="${BREW_PREFIX}/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"

	CONDA_SH="${BREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh"
	if [[ -f "${CONDA_SH}" ]]; then
		source "${CONDA_SH}"
		if [[ -d "${BREW_PREFIX}/Caskroom/miniconda/base/envs/py-base-env" ]]; then
			conda activate py-base-env
		fi
	fi
fi

alias ls='lsd'
alias cat='bat'
alias t='tmux'
alias apple-clang='/usr/bin/clang'
alias apple-clang++='/usr/bin/clang++'

export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
