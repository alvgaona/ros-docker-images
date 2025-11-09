# ROS Docker Images

Docker Hub Repository: https://hub.docker.com/r/alvgaona/ros

## Available Images

- `alvgaona/ros:humble-desktop` - ROS 2 Humble with Desktop and Gazebo
- `alvgaona/ros:humble-desktop-vnc` - ROS 2 Humble with Desktop, Gazebo, and VNC support
- `alvgaona/ros:jazzy-desktop` - ROS 2 Jazzy with Desktop

## Usage

### Standard Desktop Images

When mounting volumes, pass your host UID and GID to ensure proper file permissions:

```bash
docker run -it --rm \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -v /your/local/path:/workspace \
    alvgaona/ros:humble-desktop \
    bash
```

This allows the container's user to match your host user, avoiding permission issues with mounted files.

### VNC Desktop Images

The VNC variant includes a full desktop environment (XFCE) accessible via VNC:

```bash
docker run -it --rm \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -e VNC_ENABLE=1 \
    -p 5901:5901 \
    -v /your/local/path:/workspace \
    alvgaona/ros:humble-desktop-vnc \
    bash
```

Connect to the VNC server at `localhost:5901` with password `humble`. You can customize the VNC settings:

- `VNC_RESOLUTION` - Set display resolution (default: 1920x1080)
- `VNC_DEPTH` - Set color depth (default: 24)

Example with custom resolution:

```bash
docker run -it --rm \
    -e VNC_ENABLE=1 \
    -e VNC_RESOLUTION=1280x720 \
    -p 5901:5901 \
    alvgaona/ros:humble-desktop-vnc \
    bash
```
