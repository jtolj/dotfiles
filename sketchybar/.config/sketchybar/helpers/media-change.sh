#!/bin/bash
CACHE_FILE="${TMPDIR:-/tmp}/media_change_cache"

IFS='' read -r -d '' osascript <<'EOL'
use framework "AppKit"

on run
	try
	set MediaRemote to current application's NSBundle's bundleWithPath:"/System/Library/PrivateFrameworks/MediaRemote.framework/"
	MediaRemote's load()
	
	set MRNowPlayingRequest to current application's NSClassFromString("MRNowPlayingRequest")
	
	set appName to MRNowPlayingRequest's localNowPlayingPlayerPath()'s client()'s displayName()
	set infoDict to MRNowPlayingRequest's localNowPlayingItem()'s nowPlayingInfo()

	set title to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoTitle") as text
	set album to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoAlbum") as text
	set artist to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoArtist") as text
	set isPlaying to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoPlaybackRate") as text
	return isPlaying & "~" & title & "~" & album & "~" & artist & "~" & appName
	end try
end run
EOL

output=$(osascript -e "$osascript")

# Read cached output
cached_output=""
if [[ -f "$CACHE_FILE" ]]; then
    cached_output=$(cat "$CACHE_FILE")
fi

# Compare current output with cached output
if [[ "$output" == "$cached_output" ]]; then
    exit 0 # No change, exit without triggering
fi

# Update cache with new output
echo "$output" >"$CACHE_FILE"
if [[ $output == "" ]]; then
    sketchybar --trigger media_change_custom \
        STATE="gone" \
        TITLE="" \
        ALBUM="" \
        ARTIST="" \
        APP_NAME=""
    exit 0
fi
# Split the output by ~~~ delimiter
IFS='~' read -r isPlaying title album artist appName <<<"$output"

if [[ "$isPlaying" == "1" ]]; then
    state="playing"
else
    state="stopped"
fi

# Pass all variables to sketchybar
sketchybar --trigger media_change_custom \
    STATE="$state" \
    TITLE="$title" \
    ALBUM="$album" \
    ARTIST="$artist" \
    APP_NAME="$appName"
