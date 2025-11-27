FROM ubuntu:noble

# GitHub token for API access (optional, improves rate limits)
ARG GITHUB_TOKEN

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

# Add ROS 2 apt repository using official method
RUN apt-get update && apt-get install -y curl \
    && export ROS_APT_SOURCE_VERSION=$(curl -s $([ -n "$GITHUB_TOKEN" ] && echo "-H 'Authorization: token $GITHUB_TOKEN'") https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') \
    && echo "Downloading ros2-apt-source version: ${ROS_APT_SOURCE_VERSION}" \
    && curl -L $([ -n "$GITHUB_TOKEN" ] && echo "-H 'Authorization: token $GITHUB_TOKEN'") -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
    && dpkg -i /tmp/ros2-apt-source.deb \
    && rm /tmp/ros2-apt-source.deb \
    && rm -rf /var/lib/apt/lists/*

# Update and upgrade system packages
RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Install ROS 2 Jazzy Desktop and development tools
RUN apt-get update && apt-get install -y \
    ros-jazzy-desktop \
    ros-dev-tools \
    ros-jazzy-ros-gz \
    ros-jazzy-ros-gz-sim \
    ros-jazzy-ros-gz-bridge \
    ros-jazzy-ros-gz-interfaces \
    sudo \
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

# Create jazzy user with sudo privileges and set password
RUN useradd -m -s /bin/bash jazzy \
    && echo "jazzy:jazzy" | chpasswd \
    && echo "jazzy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Initialize rosdep (must be done as root)
RUN rosdep init

# Set entrypoint (must be done as root)
COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

# Temporarily switch to jazzy user for setup
USER jazzy
WORKDIR /home/jazzy

# Update rosdep as jazzy user
RUN rosdep update

# Create VNC directory and set default password
RUN mkdir -p /home/jazzy/.vnc \
    && echo "jazzy" | vncpasswd -f > /home/jazzy/.vnc/passwd \
    && chmod 600 /home/jazzy/.vnc/passwd

# Configure VNC to use XFCE
RUN echo "#!/bin/bash" > /home/jazzy/.vnc/xstartup \
    && echo "unset SESSION_MANAGER" >> /home/jazzy/.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/jazzy/.vnc/xstartup \
    && echo "autocutsel -fork" >> /home/jazzy/.vnc/xstartup \
    && echo "autocutsel -selection PRIMARY -fork" >> /home/jazzy/.vnc/xstartup \
    && echo "exec startxfce4" >> /home/jazzy/.vnc/xstartup \
    && chmod +x /home/jazzy/.vnc/xstartup

# Source ROS 2 setup in bashrc
RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/jazzy/.bashrc

# Expose VNC port
EXPOSE 5901

# Switch back to root for entrypoint (which handles user switching)
USER root
WORKDIR /home/jazzy

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
