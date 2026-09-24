#!/usr/bin/env bash

if ! command -v brew >/dev/null 2>&1; then
    echo "brew-llvm.sh: 未找到 Homebrew。" >&2
    return 1 2>/dev/null || exit 1
fi

LLVM_PREFIX="$(brew --prefix llvm)" || {
    echo "brew-llvm.sh: 未安装 Homebrew LLVM。" >&2
    return 1 2>/dev/null || exit 1
}

export PATH="${LLVM_PREFIX}/bin:${PATH}"
export LDFLAGS="-L${LLVM_PREFIX}/lib${LDFLAGS:+ ${LDFLAGS}}"
export CPPFLAGS="-I${LLVM_PREFIX}/include${CPPFLAGS:+ ${CPPFLAGS}}"
export PKG_CONFIG_PATH="${LLVM_PREFIX}/lib/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
