#!/usr/bin/env bash

set -euo pipefail

clean_battery() {
    local value="${1:-}"
    if [[ -z "$value" || "$value" == "null" ]]; then
        printf '-'
    else
        printf '%s' "$value" | tr -d '%' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    fi
}

profile_json=$(system_profiler SPBluetoothDataType SPAudioDataType -json 2>/dev/null)

devices_json=$(printf '%s' "$profile_json" | jq -c '.SPBluetoothDataType[0].device_connected // [] | .[]?')

printf 'bluetooth\n'
found=0
while IFS= read -r device; do
    [[ -z "$device" ]] && continue

    name=$(printf '%s' "$device" | jq -r 'to_entries[0].key')
    info=$(printf '%s' "$device" | jq -r 'to_entries[0].value | @json')
    minor_type=$(printf '%s' "$info" | jq -r '.device_minorType // empty')

    if [[ "$minor_type" == "Headset" || "$minor_type" == "Headphones" ]]; then
        main=$(clean_battery "$(printf '%s' "$info" | jq -r '.device_batteryLevelMain // empty')")
        left=$(clean_battery "$(printf '%s' "$info" | jq -r '.device_batteryLevelLeft // empty')")
        right=$(clean_battery "$(printf '%s' "$info" | jq -r '.device_batteryLevelRight // empty')")
        case=$(clean_battery "$(printf '%s' "$info" | jq -r '.device_batteryLevelCase // empty')")
        vendor_id=$(printf '%s' "$info" | jq -r '.device_vendorID // "-"')

        printf '%s\n' "$name" "$minor_type" "$main" "$left" "$right" "$case" "$vendor_id"
        found=1
        break
    fi
done <<< "$devices_json"

if [[ $found -eq 0 ]]; then
    printf 'none\n'
fi

printf 'audio\n'
printf '%s' "$profile_json" | jq -r '
  (.SPAudioDataType[0]._items // []) as $devices
  | ($devices | map(select(.["coreaudio_default_audio_output_device"] == "spaudio_yes")) | .[0]._name // "None"),
    ($devices | map(select(.["coreaudio_default_audio_input_device"] == "spaudio_yes")) | .[0]._name // "None")
'
