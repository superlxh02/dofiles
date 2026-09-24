# 现代 C++ 前沿测试线

该镜像基于 `fedora:rawhide`，用于提前验证最新 GCC、Clang、LLVM、
libstdc++、libc++、CMake 和系统库。默认选择 Clang + Ninja，同时保留 GCC。

Rawhide 是滚动开发分支，可能出现暂时性的仓库或 ABI 问题，不应作为唯一的
CI 或发布基线。稳定验证请使用 `../01-minimal-cpp` 或 `../02-full-cpp`。

```bash
docker build -t dofiles/modern-cpp .
docker run --rm -it -v "$PWD:/workspace" dofiles/modern-cpp
```
