if status is-interactive
    # Homebrew 工具链（兼容 Apple Silicon 和 Intel Mac）。
    if command -q brew
        set -l brew_prefix (brew --prefix)
        fish_add_path -g "$brew_prefix/opt/llvm/bin"
        fish_add_path -g "$brew_prefix/opt/rustup/bin"
        fish_add_path -g "$brew_prefix/opt/openjdk@21/bin"
        fish_add_path -g "$HOME/.cargo/bin"
        set -gx JAVA_HOME "$brew_prefix/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"

        # Conda：由 Homebrew Cask 提供时自动加载已有的基础开发环境。
        set -l conda_base "$brew_prefix/Caskroom/miniconda/base"
        if test -f "$conda_base/etc/fish/conf.d/conda.fish"
            source "$conda_base/etc/fish/conf.d/conda.fish"
            if test -d "$conda_base/envs/py-base-env"
                conda activate py-base-env
            end
        end
    end

    # 常用别名
    alias t tmux
    alias ls lsd
    alias cat bat
    alias apple-clang '/usr/bin/clang'
    alias apple-clang++ '/usr/bin/clang++'
    alias apple-clangd '/usr/bin/clangd'

    # 构建环境
    set -gx TERM xterm-256color
    set -x CMAKE_GENERATOR Ninja
end

if test -f ~/.orbstack/shell/init2.fish
    source ~/.orbstack/shell/init2.fish
end
