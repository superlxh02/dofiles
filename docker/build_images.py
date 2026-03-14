#!/usr/bin/env python3
"""
构建 docker/ 下除 devcontainer 外的所有镜像。

命名规则：
  - 常规（无 sshd）：{fedora|ubuntu|rocky}-base-dev-mirror:1.0
  - 带 sshd：在同名基础上插入 -ssh，即 {fedora|ubuntu|rocky}-base-dev-ssh-mirror:1.0
  - minimal Fedora 基底：fedora-min-base-dev-mirror:1.0（避免与 fedora-demo 同 tag 覆盖）
  - Rawhide 常规：modern-cpp-dev-mirror:1.0；带 sshd：modern-cpp-dev-ssh-mirror:1.0（与 morden-cpp / morden-cpp-sshd 对应）

用法：
  python3 build_images.py
  python3 build_images.py --dry-run
  python3 build_images.py --only fedora-base-dev-mirror:1.0 ubuntu-base-dev-ssh-mirror:1.0 rocky-base-dev-ssh-mirror:1.0 modern-cpp-dev-ssh-mirror:1.0
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys

DOCKER_DIR = os.path.dirname(os.path.abspath(__file__))
TAG_VERSION = "1.0"

# (dockerfile 相对 docker/ 的路径) -> 镜像名:tag
# 不含 devcontainer/
IMAGE_MAP: dict[str, str] = {
    "base-dev.Dockerfile": f"fedora-min-base-dev-mirror:{TAG_VERSION}",
    "fedora-demo.Dockerfile": f"fedora-base-dev-mirror:{TAG_VERSION}",
    "ubuntu-demo.Dockerfile": f"ubuntu-base-dev-mirror:{TAG_VERSION}",
    "rocky-demo.Dockerfile": f"rocky-base-dev-mirror:{TAG_VERSION}",
    "morden-cpp.Dockerfile": f"modern-cpp-dev-mirror:{TAG_VERSION}",
    "morden-cpp-sshd.Dockerfile": f"modern-cpp-dev-ssh-mirror:{TAG_VERSION}",
    "fedora-sshd.Dockerfile": f"fedora-base-dev-ssh-mirror:{TAG_VERSION}",
    "ubuntu-sshd.Dockerfile": f"ubuntu-base-dev-ssh-mirror:{TAG_VERSION}",
    "rocky-sshd.Dockerfile": f"rocky-base-dev-ssh-mirror:{TAG_VERSION}",
}


def build_one(dockerfile: str, image: str, dry_run: bool) -> int:
    path = os.path.join(DOCKER_DIR, dockerfile)
    if not os.path.isfile(path):
        print(f"Skip (missing): {dockerfile}", file=sys.stderr)
        return 1
    cmd = ["docker", "build", "-f", path, "-t", image, DOCKER_DIR]
    print(" ".join(cmd))
    if dry_run:
        return 0
    return subprocess.call(cmd)


def main() -> int:
    ap = argparse.ArgumentParser(description="Build all docker images except devcontainer.")
    ap.add_argument("--dry-run", action="store_true", help="Print docker build commands only")
    ap.add_argument(
        "--only",
        nargs="*",
        metavar="IMAGE",
        help="Build only these image names or dockerfile basename",
    )
    args = ap.parse_args()

    only_set = set(args.only) if args.only else None
    rc = 0
    for dockerfile, image in sorted(IMAGE_MAP.items(), key=lambda x: x[0]):
        if only_set:
            if image not in only_set and dockerfile not in only_set:
                continue
        r = build_one(dockerfile, image, args.dry_run)
        if r != 0:
            rc = r
    return rc


if __name__ == "__main__":
    sys.exit(main())
