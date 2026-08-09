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

devices_json=$(system_profiler SPBluetoothDataType -json | jq -c '.SPBluetoothDataType[0].device_connected // [] | .[]?')

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
        exit 0
    fi
done <<< "$devices_json"

printf '%s\n' "none"
