FROM ubuntu:noble

ARG GITHUB_TOKEN

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository universe \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl \
    && export ROS_APT_SOURCE_VERSION=$(curl -s $([ -n "$GITHUB_TOKEN" ] && echo "-H 'Authorization: token $GITHUB_TOKEN'") https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') \
    && echo "Downloading ros2-apt-source version: ${ROS_APT_SOURCE_VERSION}" \
    && curl -L $([ -n "$GITHUB_TOKEN" ] && echo "-H 'Authorization: token $GITHUB_TOKEN'") -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
    && dpkg -i /tmp/ros2-apt-source.deb \
    && rm /tmp/ros2-apt-source.deb \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    ros-rolling-desktop \
    ros-dev-tools \
    ros-rolling-ros-gz \
    ros-rolling-ros-gz-sim \
    ros-rolling-ros-gz-bridge \
    ros-rolling-ros-gz-interfaces \
    sudo \
    && rm -rf /var/lib/apt/lists/*

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

RUN useradd -m -s /bin/bash rolling \
    && echo "rolling:rolling" | chpasswd \
    && echo "rolling ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN rosdep init

COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

USER rolling
WORKDIR /home/rolling

RUN rosdep update

RUN mkdir -p /home/rolling/.vnc \
    && echo "rolling" | vncpasswd -f > /home/rolling/.vnc/passwd \
    && chmod 600 /home/rolling/.vnc/passwd

RUN echo "#!/bin/bash" > /home/rolling/.vnc/xstartup \
    && echo "unset SESSION_MANAGER" >> /home/rolling/.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/rolling/.vnc/xstartup \
    && echo "autocutsel -fork" >> /home/rolling/.vnc/xstartup \
    && echo "autocutsel -selection PRIMARY -fork" >> /home/rolling/.vnc/xstartup \
    && echo "exec startxfce4" >> /home/rolling/.vnc/xstartup \
    && chmod +x /home/rolling/.vnc/xstartup

RUN echo "source /opt/ros/rolling/setup.bash" >> /home/rolling/.bashrc

EXPOSE 5901

USER root
WORKDIR /home/rolling

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
