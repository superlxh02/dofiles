if status --is-interactive
    alias ls lsd
    alias cat bat
    alias apple-clang ' /usr/bin/clang'
    alias apple-clang++ ' /usr/bin/clang++'
    alias ps procs
    alias code-remote 'code --remote ssh-remote+orb'
    alias t tmux
    set -U fish_user_paths /Users/liuxiaohua/.vcpkg-clion/vcpkg $fish_user_paths
    set -x CMAKE_TOOLCHAIN_FILE /Users/liuxiaohua/.vcpkg-clion/vcpkg/scripts/buildsystems/vcpkg.cmake
    set -x CMAKE_GENERATOR Ninja
    set -x PATH /opt/homebrew/bin $PATH
    set -x PATH /usr/local/bin $PATH
    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x PYENV_ROOT $HOME/.pyenv
    set -x PATH $PYENV_ROOT/bin $PATH
    pyenv init --path | source
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
