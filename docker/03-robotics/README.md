# ROS 2 开发镜像

## 无界面版

该镜像基于 `ros:jazzy-ros-base-noble`，对应 Ubuntu 24.04 和 ROS 2
Jazzy LTS。它只安装命令行开发工具，不安装 `desktop`、RViz、Gazebo、
RQt、Qt 或 X11 组件。

```bash
docker build -f Dockerfile.ros2-jazzy -t dofiles/ros2-jazzy-headless .
docker run --rm -it -v "$PWD:/ros2_ws" dofiles/ros2-jazzy-headless
```

ROS 官方镜像的 entrypoint 会自动加载 `/opt/ros/jazzy/setup.bash`。

## Desktop Full + VNC 版

`Dockerfile.ros2-jazzy-desktop-vnc` 同样基于 Ubuntu 24.04 与 ROS 2 Jazzy，
包含 `desktop-full`、RViz2、RQt、Qt、Gazebo (`ros_gz`)、完整 C++ 开发工具，
以及 XFCE + TigerVNC。容器中的图形程序使用 Mesa 软件渲染，不要求宿主机
提供 X11。

构建并启动：

```bash
docker build -f 03-robotics/Dockerfile.ros2-jazzy-desktop-vnc \
  -t dofiles/ros2-jazzy-desktop-vnc .

docker run --rm -it \
  -p 5901:5901 \
  -e VNC_PASSWORD='请替换为至少6位的密码' \
  -e VNC_GEOMETRY=1920x1080 \
  -v "$PWD/ros2_ws:/ros2_ws" \
  dofiles/ros2-jazzy-desktop-vnc
```

外部 VNC 客户端连接 `宿主机IP:5901`。镜像默认密码仅用于本机试用；对局域网
或公网开放时必须通过 `VNC_PASSWORD` 修改，并应同时使用防火墙、VPN 或 SSH
隧道限制访问。VNC 本身不加密桌面流量，不建议直接把 5901 暴露到公网。

进入桌面后可从终端直接运行 `rviz2`、`rqt` 或 `gz sim`。如果挂载的工作区已经
执行过 `colcon build`，VNC 会话也会自动加载 `/ros2_ws/install/setup.sh`。
