FROM docker.io/ros:jazzy

ENV DEBIAN_FRONTEND=noninteractive
ENV GZ_VERSION=harmonic

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    python3-geopy \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-scipy \
    python3-vcstool \
    socat\
    tmux \
    wget \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-ros-gz \
    ros-${ROS_DISTRO}-mavros \
    ros-${ROS_DISTRO}-mavros-extras && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/mavlink/mavros/ros2/mavros/scripts/install_geographiclib_datasets.sh && \
    chmod +x install_geographiclib_datasets.sh && \
    ./install_geographiclib_datasets.sh && \
    rm -f install_geographiclib_datasets.sh

WORKDIR /opt/
# RUN git clone --recursive https://github.com/ArduPilot/ardupilot.git
# RUN ./ardupilot/Tools/environment_install/install-prereqs-ubuntu.sh -y
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

RUN apt-get update && apt-get install -y libgz-sim8-dev rapidjson-dev libopencv-dev libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl

RUN mkdir -p /ardupilot_gazebo
WORKDIR /ardupilot_gazebo
COPY ./ardupilot_gazebo .
RUN chmod +x /ardupilot_gazebo/build.sh
RUN ./build.sh

ENV GZ_SIM_SYSTEM_PLUGIN_PATH=/ardupilot_gazebo/build
ENV GZ_SIM_RESOURCE_PATH=/ardupilot_gazebo/models:/ardupilot_gazebo/worlds

RUN mkdir -p /workspace/src
WORKDIR /workspace
COPY scripts/entrypoint.sh /scripts/entrypoint.sh
COPY scripts/run_bringup.sh /scripts/run_bringup.sh
COPY scripts/start_tmux.sh /scripts/start_tmux.sh
RUN chmod +x /scripts/entrypoint.sh /scripts/run_bringup.sh /scripts/start_tmux.sh

# ENTRYPOINT ["/scripts/entrypoint.sh"]
# CMD ["/scripts/start_tmux.sh"]
