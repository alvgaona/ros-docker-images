FROM ubuntu:noble

ARG ROS_APT_SOURCE_VERSION=1.1.0

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
    && curl -L -o /tmp/ros2-apt-source.deb \
       "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
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

RUN rosdep init && rosdep update

COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

RUN mkdir -p /root/.vnc \
    && echo "rolling" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

RUN echo "#!/bin/bash" > /root/.vnc/xstartup \
    && echo "unset SESSION_MANAGER" >> /root/.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS" >> /root/.vnc/xstartup \
    && echo "autocutsel -fork" >> /root/.vnc/xstartup \
    && echo "autocutsel -selection PRIMARY -fork" >> /root/.vnc/xstartup \
    && echo "exec startxfce4" >> /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

RUN echo "source /opt/ros/rolling/setup.bash" >> /root/.bashrc

EXPOSE 5901

WORKDIR /root

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
