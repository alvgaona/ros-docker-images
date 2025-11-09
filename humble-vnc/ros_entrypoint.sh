#!/bin/bash
set -e

# Update humble user's UID/GID if specified (for volume mounting)
if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    echo "Updating humble user to UID:GID = $HOST_UID:$HOST_GID"

    # Get current UID/GID
    CURRENT_UID=$(id -u humble)
    CURRENT_GID=$(id -g humble)

    # Update if different (use -o to avoid scanning filesystem)
    if [ "$CURRENT_GID" != "$HOST_GID" ]; then
        groupmod -o -g "$HOST_GID" humble 2>/dev/null || true
    fi
    if [ "$CURRENT_UID" != "$HOST_UID" ]; then
        usermod -o -u "$HOST_UID" humble
    fi

    # Fix ownership of VNC directory only
    chown -R humble:humble /home/humble/.vnc 2>/dev/null || true
fi

# Source ROS 2 setup
source /opt/ros/humble/setup.bash

# Source workspace setup if it exists
if [ -f /home/humble/ros2_ws/install/setup.bash ]; then
    source /home/humble/ros2_ws/install/setup.bash
fi

# Start VNC server if VNC_ENABLE is set
if [ "$VNC_ENABLE" = "1" ] || [ "$VNC_ENABLE" = "true" ]; then
    echo "Starting VNC server on display :1"
    # Run as humble user using runuser (doesn't require password)
    # -localhost=0 allows connections from outside the container
    runuser -u humble -- vncserver :1 -localhost=0 -geometry ${VNC_RESOLUTION:-1920x1080} -depth ${VNC_DEPTH:-24}
    echo "VNC server started. Connect to port 5901"
    echo "Default password: humble"
fi

exec "$@"
