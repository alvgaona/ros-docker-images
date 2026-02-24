#!/bin/bash
set -e

source /opt/ros/jazzy/setup.bash

if [ "$VNC_ENABLE" = "1" ] || [ "$VNC_ENABLE" = "true" ]; then
    echo "Starting VNC server on display :1"
    vncserver :1 -localhost=0 -geometry ${VNC_RESOLUTION:-1920x1080} -depth ${VNC_DEPTH:-24}
    echo "VNC server started. Connect to port 5901"
fi

exec "$@"
