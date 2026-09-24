#!/usr/bin/env python3
"""构建七类开发环境中的 Docker 镜像，不处理 devcontainer。"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys

DOCKER_DIR = os.path.dirname(os.path.abspath(__file__))
TAG_VERSION = "1.0"

# (Dockerfile 相对 docker/ 的路径) -> 镜像名:tag
IMAGE_MAP: dict[str, str] = {
    "01-minimal-cpp/Dockerfile.ubuntu-latest": f"cpp-min-ubuntu-latest:{TAG_VERSION}",
    "01-minimal-cpp/Dockerfile.fedora-latest": f"cpp-min-fedora-latest:{TAG_VERSION}",
    "01-minimal-cpp/Dockerfile.ubuntu-24.04": f"cpp-min-ubuntu-24.04:{TAG_VERSION}",
    "02-full-cpp/Dockerfile.ubuntu-latest": f"cpp-full-ubuntu-latest:{TAG_VERSION}",
    "02-full-cpp/Dockerfile.fedora-latest": f"cpp-full-fedora-latest:{TAG_VERSION}",
    "02-full-cpp/Dockerfile.ubuntu-24.04": f"cpp-full-ubuntu-24.04:{TAG_VERSION}",
    "03-robotics/Dockerfile.ros2-jazzy": f"ros2-jazzy-headless:{TAG_VERSION}",
    "03-robotics/Dockerfile.ros2-jazzy-desktop-vnc": f"ros2-jazzy-desktop-vnc:{TAG_VERSION}",
    "04-autonomous-driving/Dockerfile.apollo-full": f"apollo-full-dev:{TAG_VERSION}",
    "04-autonomous-driving/Dockerfile.cyberrt": f"apollo-cyberrt-dev:{TAG_VERSION}",
    "05-modern-cpp/Dockerfile": f"modern-cpp-rawhide:{TAG_VERSION}",
    "06-embedded-linux/Dockerfile": f"embedded-linux-dev:{TAG_VERSION}",
    "07-automotive-communication/Dockerfile": f"automotive-communication-dev:{TAG_VERSION}",
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
    ap = argparse.ArgumentParser(description="Build the seven categorized image families.")
    ap.add_argument("--dry-run", action="store_true", help="Print docker build commands only")
    ap.add_argument(
        "--only",
        nargs="*",
        metavar="IMAGE",
        help="Build only these image names, Dockerfile paths, or Dockerfile basenames",
    )
    args = ap.parse_args()

    only_set = set(args.only) if args.only else None
    rc = 0
    for dockerfile, image in sorted(IMAGE_MAP.items(), key=lambda x: x[0]):
        if only_set:
            if (
                image not in only_set
                and dockerfile not in only_set
                and os.path.basename(dockerfile) not in only_set
            ):
                continue
        r = build_one(dockerfile, image, args.dry_run)
        if r != 0:
            rc = r
    return rc


if __name__ == "__main__":
    sys.exit(main())
