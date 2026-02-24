FROM ubuntu:jammy

ARG ROS_APT_SOURCE_VERSION=1.1.0

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Set locale
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8

# Add Universe repository
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository universe \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl \
    && curl -L -o /tmp/ros2-apt-source.deb \
       "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
    && dpkg -i /tmp/ros2-apt-source.deb \
    && rm /tmp/ros2-apt-source.deb \
    && rm -rf /var/lib/apt/lists/*

# Update and upgrade system packages
RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Install ROS 2 Humble Desktop and development tools
RUN apt-get update && apt-get install -y \
    ros-humble-desktop \
    ros-dev-tools \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-cyclonedds \
    && rm -rf /var/lib/apt/lists/*

# Install Gazebo and ROS-Gazebo bridge packages
RUN apt-get update && apt-get install -y \
    ros-humble-ros-gz \
    ros-humble-ros-gz-sim \
    ros-humble-ros-gz-bridge \
    ros-humble-ros-gz-interfaces \
    && rm -rf /var/lib/apt/lists/*

# Install VNC, desktop environment, and utilities
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    xfce4 \
    xfce4-goodies \
    dbus-x11 \
    xterm \
    x11-xserver-utils \
    mesa-utils \
    autocutsel \
    xclip \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

RUN mkdir -p /root/.vnc \
    && echo "humble" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

RUN echo "#!/bin/bash" > /root/.vnc/xstartup \
    && echo "unset SESSION_MANAGER" >> /root/.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS" >> /root/.vnc/xstartup \
    && echo "autocutsel -fork" >> /root/.vnc/xstartup \
    && echo "autocutsel -selection PRIMARY -fork" >> /root/.vnc/xstartup \
    && echo "exec startxfce4" >> /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

EXPOSE 5901

WORKDIR /root

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
