#!/bin/bash
set -euo pipefail

IMG=${1:?usage: run_gui_podman.sh <image> <command...>}
shift

WORKSPACE_DIR=${WORKSPACE_DIR:-$(pwd)/workspace}

args=(
  run
  -it
  --net
  host
  --security-opt
  label=disable
  --device=/dev/dri
  --userns=keep-id
)

if [ "${KEEP_CONTAINER:-0}" != "1" ]; then
  args+=(--rm)
elif [ -n "${CONT_NAME:-}" ]; then
  args+=(--name "$CONT_NAME")
fi

if [ -n "${DISPLAY:-}" ]; then
  args+=(-e "DISPLAY=$DISPLAY")
fi

if [ -d /tmp/.X11-unix ]; then
  args+=(-v /tmp/.X11-unix:/tmp/.X11-unix)
fi

if [ -n "${XAUTHORITY:-}" ] && [ -f "${XAUTHORITY}" ]; then
  args+=(-e "XAUTHORITY=$XAUTHORITY" -v "${XAUTHORITY}:${XAUTHORITY}:ro")
fi

if [ -n "${WAYLAND_DISPLAY:-}" ] && [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
  args+=(
    -e "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
    -e XDG_RUNTIME_DIR=/tmp
    -v "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}:/tmp/${WAYLAND_DISPLAY}:ro"
  )
fi

if [ -d "${WORKSPACE_DIR}" ]; then
  args+=(-v "${WORKSPACE_DIR}:/workspace")
fi

exec podman "${args[@]}" "$IMG" "$@"

