#!/bin/bash
set -e

export SIM_NAMESPACE=${SIM_NAMESPACE:-uav1}
export SIM_TGT_SYSTEM=${SIM_TGT_SYSTEM:-1}
export SIM_FCU_URL=${SIM_FCU_URL:-udp://:14550@}
export SIM_RVIZ=${SIM_RVIZ:-true}
export SIM_USE_GZ_TF=${SIM_USE_GZ_TF:-true}
export SIM_START_MAVROS=${SIM_START_MAVROS:-true}
export SIM_MAVROS_DELAY=${SIM_MAVROS_DELAY:-8.0}

exec ros2 launch sim_bringup single_drone_sim.launch.py \
  namespace:="${SIM_NAMESPACE}" \
  tgt_system:="${SIM_TGT_SYSTEM}" \
  fcu_url:="${SIM_FCU_URL}" \
  rviz:="${SIM_RVIZ}" \
  use_gz_tf:="${SIM_USE_GZ_TF}" \
  start_mavros:="${SIM_START_MAVROS}" \
  mavros_delay:="${SIM_MAVROS_DELAY}"

