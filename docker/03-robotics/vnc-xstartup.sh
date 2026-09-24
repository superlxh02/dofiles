#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

. /opt/ros/jazzy/setup.sh
if [ -f /ros2_ws/install/setup.sh ]; then
    . /ros2_ws/install/setup.sh
fi

export LIBGL_ALWAYS_SOFTWARE="${LIBGL_ALWAYS_SOFTWARE:-1}"
export QT_X11_NO_MITSHM="${QT_X11_NO_MITSHM:-1}"

exec dbus-launch --exit-with-session startxfce4
