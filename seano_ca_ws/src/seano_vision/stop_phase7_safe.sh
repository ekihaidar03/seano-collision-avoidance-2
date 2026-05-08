#!/usr/bin/env bash
set -u

# Safe release helper for the phase7 hardware path.
# This script only publishes disable/release/zero commands; it does not start
# MAVROS, launch files, or any autonomous behavior.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

if [ -f "${WS_DIR}/install/setup.bash" ]; then
  # shellcheck disable=SC1091
  source "${WS_DIR}/install/setup.bash"
fi

publish_once() {
  ros2 topic pub --once "$@" >/dev/null 2>&1 || true
}

publish_once /seano/auto_master_enable std_msgs/msg/Bool "{data: false}"
publish_once /seano/auto_enable std_msgs/msg/Bool "{data: false}"
publish_once /seano/rc_override_enable std_msgs/msg/Bool "{data: false}"

publish_once /seano/manual/left_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/manual/right_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/auto/left_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/auto/right_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/selected/left_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/selected/right_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/left_cmd std_msgs/msg/Float32 "{data: 0.0}"
publish_once /seano/right_cmd std_msgs/msg/Float32 "{data: 0.0}"

publish_once /mavros/rc/override mavros_msgs/msg/OverrideRCIn \
  "{channels: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]}"

echo "Phase7 safe release commands published."
