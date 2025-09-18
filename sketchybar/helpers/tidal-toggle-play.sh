#!/bin/bash
osascript <<EOF
tell application "System Events"
  try
  tell process "TIDAL"
    click menu item 0 of menu "Playback" of menu bar 1
  end tell
  on error
  end try
end tell
EOF
