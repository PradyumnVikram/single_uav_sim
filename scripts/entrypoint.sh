#!/bin/bash
set -e

source /opt/ros/$ROS_DISTRO/setup.bash

# if [ -f /workspace/install/setup.bash ]; then
#   source /workspace/install/setup.bash
# fi

# if [ -n "${GZ_SIM_RESOURCE_PATH:-}" ] && [ -z "${SDF_PATH:-}" ]; then
#   export SDF_PATH="$GZ_SIM_RESOURCE_PATH"
# fi

exec "$@"

