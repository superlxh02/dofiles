# 嵌入式 Linux、驱动与内核开发

该镜像固定基于 Ubuntu 24.04，包含：

- AArch64、ARM hard-float 和 RISC-V 64 位交叉编译器；
- 内核构建依赖、内核源码包、设备树编译器、Sparse 和 Coccinelle；
- U-Boot、Buildroot 和 Yocto 常用构建依赖；
- QEMU system/user 模拟器和 `gdb-multiarch`。

默认环境是 AArch64：

```text
ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu-
```

构建其他架构时覆盖环境变量，例如：

```bash
docker run --rm -it \
  -e ARCH=riscv -e CROSS_COMPILE=riscv64-linux-gnu- \
  -v "$PWD:/workspace" dofiles/embedded-linux
```

容器适合编译和用户态模拟。加载内核模块、访问真实硬件或运行 eBPF 时，仍需
匹配宿主机内核，并按需添加 `--privileged` 或具体设备映射。
