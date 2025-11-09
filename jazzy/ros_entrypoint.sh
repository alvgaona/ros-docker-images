#!/bin/bash
set -e

# Update jazzy user's UID/GID if specified (for volume mounting)
if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    echo "Updating jazzy user to UID:GID = $HOST_UID:$HOST_GID"

    # Get current UID/GID
    CURRENT_UID=$(id -u jazzy)
    CURRENT_GID=$(id -g jazzy)

    # Update if different
    if [ "$CURRENT_GID" != "$HOST_GID" ]; then
        groupmod -g "$HOST_GID" jazzy
    fi
    if [ "$CURRENT_UID" != "$HOST_UID" ]; then
        usermod -u "$HOST_UID" jazzy
    fi

    # Fix ownership of home directory
    chown -R jazzy:jazzy /home/jazzy
fi

# Source ROS 2 setup
source /opt/ros/jazzy/setup.bash

# Source workspace setup if it exists
if [ -f /home/jazzy/ros2_ws/install/setup.bash ]; then
    source /home/jazzy/ros2_ws/install/setup.bash
fi

exec "$@"
