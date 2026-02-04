# ROS Docker Images

Docker Hub Repository: https://hub.docker.com/r/alvgaona/ros

## Available Images

- `alvgaona/ros:humble-desktop` - ROS 2 Humble with Desktop and Gazebo
- `alvgaona/ros:humble-desktop-vnc` - ROS 2 Humble with Desktop, Gazebo, and VNC support
- `alvgaona/ros:jazzy-desktop` - ROS 2 Jazzy with Desktop and Gazebo
- `alvgaona/ros:jazzy-desktop-vnc` - ROS 2 Jazzy with Desktop, Gazebo, and VNC support
- `alvgaona/ros:rolling-desktop` - ROS 2 Rolling with Desktop and Gazebo
- `alvgaona/ros:rolling-desktop-vnc` - ROS 2 Rolling with Desktop, Gazebo, and VNC support

## Usage

### Standard Desktop Images (X Server Forwarding)

These images are designed for **Linux hosts** where you can forward the X server directly from the host.

```bash
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /your/local/path:/workspace \
    alvgaona/ros:humble-desktop \
    bash
```

You may need to allow X server connections from Docker:

```bash
xhost +local:docker
```

This allows the container's user to match your host user, avoiding permission issues with mounted files.

### VNC Desktop Images

The VNC variant includes a full desktop environment (XFCE) accessible via VNC. Use these images on
**macOS**, **Windows**, or **headless environments** where X server forwarding is not available.

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

## Docker Compose

A `docker-compose.yaml` is provided for convenience. Run any service with:

```bash
# Linux with X server forwarding
docker compose run --rm humble-desktop

# macOS/Windows/headless with VNC
docker compose run --rm humble-desktop-vnc
```

Available services: `humble-desktop`, `humble-desktop-vnc`, `jazzy-desktop`, `jazzy-desktop-vnc`

You can customize settings via environment variables:

```bash
HOST_UID=$(id -u) HOST_GID=$(id -g) VNC_RESOLUTION=1280x720 docker compose run --rm humble-desktop-vnc
```
