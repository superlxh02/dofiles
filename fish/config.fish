if status is-interactive

	#conda配置
	source /opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish
	conda activate py-base-env

	#重命名
	alias t tmux
	alias ls lsd
    alias cat bat
    alias apple-clang ' /usr/bin/clang'
    alias apple-clang++ ' /usr/bin/clang++'
    alias apple-clangd '/usr/bin/clangd'
    alias t tmux
	

	#环境变量
	set -x TERM xterm-256color
    set -U fish_user_paths /opt/homebrew/opt/llvm/bin  $fish_user_paths    
    set -x CMAKE_GENERATOR Ninja
    #set -U fish_user_paths /Users/lxh/.vcpkg-clion/vcpkg $fish_user_paths
    #set -x CMAKE_TOOLCHAIN_FILE /Users/lxh/.vcpkg-clion/vcpkg/scripts/buildsystems/vcpkg.cmake
end

source ~/.orbstack/shell/init2.fish 2>/dev/null || :
