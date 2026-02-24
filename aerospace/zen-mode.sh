#!/bin/bash
STATE_FILE="/tmp/aerospace-zen-mode"

function hide_workspace_windows() {
    local workspace_id="$1"
    window_ids=$(aerospace list-windows --workspace "$workspace_id" --format '%{window-id}')
    if [ "$window_ids" = "" ]; then
        return 0
    fi
    while IFS= read -r window_id; do
        aerospace move-node-to-workspace --window-id "$window_id" 5
    done <<< "$window_ids"
}

function restore_workspace_windows() {
    workspace_id="$1"
    window_ids=$(aerospace list-windows --workspace 5 --format '%{window-id}')
    if [ "$window_ids" = "" ]; then
        return 0
    fi
    while IFS= read -r window_id; do
        aerospace move-node-to-workspace --window-id "$window_id" "$workspace_id"
    done <<< "$window_ids"
}

if [ -f "$STATE_FILE" ]; then
    # Exit zen mode: unminimize saved windows
    workspace_id=$(cat "$STATE_FILE")
    restore_workspace_windows "$workspace_id"
    rm "$STATE_FILE"
else
    # Enter zen mode: minimize windows on other monitors
    all_monitors=$(aerospace list-monitors --format '%{monitor-id}')
    focused_monitor=$(aerospace list-monitors --focused --format '%{monitor-id}')
    while IFS= read -r monitor; do
        if [ "$monitor" -ne "$focused_monitor" ]; then
            workspace=$(aerospace list-workspaces --monitor "$monitor" --visible)
            echo "$workspace" > "$STATE_FILE"
            hide_workspace_windows "$workspace"
        fi
    done <<< "$all_monitors"
fi
