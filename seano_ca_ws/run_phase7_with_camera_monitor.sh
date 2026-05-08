#!/usr/bin/env bash
set -eo pipefail

export ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-42}"

cd "$(dirname "$0")"
source install/setup.bash

echo "[RUN] Starting web_video_server on port 8080..."
ros2 run web_video_server web_video_server &
WEB_PID=$!

cleanup() {
  echo
  echo "[RUN] Stopping monitor and publishing safe stop..."
  kill "$WEB_PID" 2>/dev/null || true
  bash src/seano_vision/stop_phase7_safe.sh || true
}
trap cleanup INT TERM EXIT

echo "[RUN] Camera monitor:"
echo "  http://100.97.147.109:8080/stream?topic=/ca/debug_image"
echo "  fallback: /camera/image_annotated"
echo "  fallback: /seano/camera/image_raw_reliable"

ros2 launch seano_vision phase7_cuav_usb_hardware.launch.py \
  use_mavros:=true \
  use_ca_pipeline:=true \
  use_takeover_manager:=true \
  use_mode_manager:=true \
  master_enable_on_start:=true \
  ca_runtime_profile:=usb_watchdog \
  ca_det_publish_annotated:=true
