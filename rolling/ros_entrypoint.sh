#!/bin/bash
set -e

if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    echo "Updating rolling user to UID:GID = $HOST_UID:$HOST_GID"

    CURRENT_UID=$(id -u rolling)
    CURRENT_GID=$(id -g rolling)

    if [ "$CURRENT_GID" != "$HOST_GID" ]; then
        groupmod -g "$HOST_GID" rolling
    fi
    if [ "$CURRENT_UID" != "$HOST_UID" ]; then
        usermod -u "$HOST_UID" rolling
    fi

    chown -R rolling:rolling /home/rolling
fi

echo "rolling:rolling" | chpasswd

source /opt/ros/rolling/setup.bash

if [ -f /home/rolling/ros2_ws/install/setup.bash ]; then
    source /home/rolling/ros2_ws/install/setup.bash
fi

exec "$@"
