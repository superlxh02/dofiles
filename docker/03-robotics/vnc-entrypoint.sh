#!/usr/bin/env bash
set -Eeuo pipefail

: "${DISPLAY:=:1}"
: "${VNC_GEOMETRY:=1920x1080}"
: "${VNC_DEPTH:=24}"
: "${VNC_PASSWORD:=ros2vnc}"

if [[ ! "${DISPLAY}" =~ ^:([1-9][0-9]*)$ ]]; then
    echo "DISPLAY 必须是 :1、:2 这类正整数显示编号，当前值: ${DISPLAY}" >&2
    exit 2
fi
if (( ${#VNC_PASSWORD} < 6 )); then
    echo "VNC_PASSWORD 至少需要 6 个字符。" >&2
    exit 2
fi

display_number="${BASH_REMATCH[1]}"
mkdir -p "${HOME}/.vnc"
printf '%s\n' "${VNC_PASSWORD}" | tigervncpasswd -f >"${HOME}/.vnc/passwd"
chmod 0600 "${HOME}/.vnc/passwd"

# 容器被强制停止后可能留下陈旧的 X 锁；仅清理本 DISPLAY 对应文件。
rm -f "/tmp/.X${display_number}-lock" "/tmp/.X11-unix/X${display_number}"

exec tigervncserver "${DISPLAY}" \
    -fg \
    -localhost no \
    -SecurityTypes VncAuth \
    -PasswordFile "${HOME}/.vnc/passwd" \
    -geometry "${VNC_GEOMETRY}" \
    -depth "${VNC_DEPTH}" \
    -xstartup /usr/local/bin/vnc-xstartup
