#!/bin/bash
set -e

if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    echo "Updating rolling user to UID:GID = $HOST_UID:$HOST_GID"

    CURRENT_UID=$(id -u rolling)
    CURRENT_GID=$(id -g rolling)

    if [ "$CURRENT_GID" != "$HOST_GID" ]; then
        groupmod -o -g "$HOST_GID" rolling 2>/dev/null || true
    fi
    if [ "$CURRENT_UID" != "$HOST_UID" ]; then
        usermod -o -u "$HOST_UID" rolling
    fi

    chown -R rolling:rolling /home/rolling/.vnc 2>/dev/null || true
fi

source /opt/ros/rolling/setup.bash

if [ -f /home/rolling/ros2_ws/install/setup.bash ]; then
    source /home/rolling/ros2_ws/install/setup.bash
fi

if [ "$VNC_ENABLE" = "1" ] || [ "$VNC_ENABLE" = "true" ]; then
    echo "Starting VNC server on display :1"
    runuser -u rolling -- vncserver :1 -localhost=0 -geometry ${VNC_RESOLUTION:-1920x1080} -depth ${VNC_DEPTH:-24}
    echo "VNC server started. Connect to port 5901"
    echo "Default password: rolling"
fi

exec "$@"
