#!/bin/bash
set -e

SESSION_NAME=${TMUX_SESSION_NAME:-sim}
BRINGUP_CMD=${SIM_BRINGUP_CMD:-/scripts/run_bringup.sh}
SHELL_CMD=${SIM_SHELL_CMD:-bash}

tmux start-server
tmux set-option -g mouse on
tmux set-option -g remain-on-exit on

if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
  exec tmux attach -t "${SESSION_NAME}"
fi

tmux new-session -d -s "${SESSION_NAME}" -n sim
tmux send-keys -t "${SESSION_NAME}:sim.0" "${BRINGUP_CMD}" C-m
tmux split-window -h -t "${SESSION_NAME}:sim.0" "${SHELL_CMD}"
tmux select-pane -t "${SESSION_NAME}:sim.1"
tmux select-layout -t "${SESSION_NAME}:sim" tiled

exec tmux attach -t "${SESSION_NAME}"
