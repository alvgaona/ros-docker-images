#!/bin/bash
set -e

# Update humble user's UID/GID if specified (for volume mounting)
if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    echo "Updating humble user to UID:GID = $HOST_UID:$HOST_GID"

    # Get current UID/GID
    CURRENT_UID=$(id -u humble)
    CURRENT_GID=$(id -g humble)

    # Update if different
    if [ "$CURRENT_GID" != "$HOST_GID" ]; then
        groupmod -g "$HOST_GID" humble
    fi
    if [ "$CURRENT_UID" != "$HOST_UID" ]; then
        usermod -u "$HOST_UID" humble
    fi

    # Fix ownership of home directory
    chown -R humble:humble /home/humble
fi

# Source ROS 2 setup
source /opt/ros/humble/setup.bash

# Source workspace setup if it exists
if [ -f /home/humble/ros2_ws/install/setup.bash ]; then
    source /home/humble/ros2_ws/install/setup.bash
fi

exec "$@"
