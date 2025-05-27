if status --is-interactive
    alias ls lsd
    alias cat bat
    alias gcc gcc-14
    alias cc gcc-14
    alias g++ 'g++-14'
    alias c++ 'c++-14'
    alias apple-clang ' /usr/bin/clang'
    alias apple-clang++ ' /usr/bin/clang++'
    alias ps procs
    alias cman 'man -M /usr/local/share/man/zh_CN'
    alias code-remote 'code --remote ssh-remote+orb'
    alias t tmux
    set -U fish_user_paths /opt/homebrew/Cellar/llvm/19.1.7_1/bin $fish_user_paths
    set -U fish_user_paths /Users/liuxiaohua/.npm-global/bin $fish_user_paths
    set -U fish_user_paths /Users/liuxiaohua/workspace/.bin $fish_user_paths
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/liuxiaohua/.lmstudio/bin
