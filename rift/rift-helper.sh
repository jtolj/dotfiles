#!/bin/sh

set -eu

RIFT_CLI=/opt/homebrew/bin/rift-cli
JQ=/opt/homebrew/bin/jq
SKETCHYBAR=/opt/homebrew/bin/sketchybar

case "${1:-}" in
	toggle-layout)
		next=$("$RIFT_CLI" query workspace-layout | "$JQ" -er '
(first(.[] | select(.is_active)) // {}) | (.layout_mode // "stack")
| if . == "stack" then "master_stack" else "stack" end
')
		"$RIFT_CLI" execute workspace set-layout "$next"
		;;

	focus-next-display|move-window-next-display)
		# AeroSpace: focus-monitor / move-node-to-monitor --wrap-around next
		#
		# rift-cli's --index selector uses physical left-to-right order, while
		# `query displays` puts the main display first. Sort by frame origin to
		# match Rift's order, then target the next display by UUID.
		uuid=$("$RIFT_CLI" query displays | "$JQ" -r '
sort_by([(.frame.origin.x // 0), (.frame.origin.y // 0)]) as $ordered
| (($ordered | map(.is_active_context) | index(true)) // 0) as $current
| if ($ordered | length) <= 1 then empty
  else $ordered[(($current + 1) % ($ordered | length))].uuid // empty
  end
')
		# A single display wraps onto itself; there is nothing to do.
		[ -n "$uuid" ] || exit 0
		if [ "$1" = "focus-next-display" ]; then
			# `display focus` falls back to the lowest-(pid,idx) window when the
			# target display's remembered focus is stale, which is not the stack's
			# front window. That happens right after `display move-window` clears
			# the source display's focus while focus follows the moved window.
			# Capture the layout selection (the front window) before focusing,
			# then correct focus afterwards. The query must come first because
			# `display focus` itself rewrites the selection.
			selected=$("$RIFT_CLI" query layout --display "$uuid" 2>/dev/null \
				| "$JQ" -c '.selected_window // empty' 2>/dev/null || true)
			"$RIFT_CLI" execute display focus --uuid "$uuid"
			[ -n "$selected" ] \
				&& "$RIFT_CLI" execute window focus --window-id "$selected" >/dev/null 2>&1 \
				|| true
		else
			"$RIFT_CLI" execute display move-window --uuid "$uuid"
		fi

		# Refresh explicitly so the icon and workspace highlight always update.
		"$SKETCHYBAR" --trigger rift_refresh >/dev/null 2>&1 || true
		;;

	sync-main-gap)
		# Rift only supports per-display gap overrides keyed by display UUID;
		# there is no "main display" key. In macOS's global display coordinates
		# the main display (the one with SketchyBar) is at (0, 0).

		# every other connected display.
		displays=$("$RIFT_CLI" query displays)
		main_uuid=$(printf '%s' "$displays" | "$JQ" -r '
first(.[] | select((.frame.origin.x // 0) == 0 and (.frame.origin.y // 0) == 0)) | .uuid // empty
')
		[ -n "$main_uuid" ] || exit 0

		# A per-display override replaces the whole outer group, so start from
		# that display's existing override (or the global gaps) and change only
		# `top`. This preserves any non-top per-display values already set.
		config=$("$RIFT_CLI" execute config get)
		printf '%s' "$displays" | "$JQ" -r --arg main "$main_uuid" --argjson config "$config" '
.[] | .uuid as $uuid
| ($config.settings.layout.gaps.per_display[$uuid].outer
	// $config.settings.layout.gaps.outer) as $outer
| [$uuid, ($outer | .top = (if $uuid == $main then 50 else 16 end) | tojson)]
| @tsv
' | while IFS="$(printf '\t')" read -r uuid value; do
			"$RIFT_CLI" execute config set \
				"settings.layout.gaps.per_display.$uuid.outer" "$value" >/dev/null
		done
		;;

	service-exit)
		"$RIFT_CLI" execute config reload
		"$RIFT_CLI" execute binding-mode default
		;;

	service-unjoin)
		"$RIFT_CLI" execute layout unjoin
		"$RIFT_CLI" execute binding-mode default
		;;

	service-join)
		# Equivalent to Aerospace ['join-with <dir>', 'mode main']
		"$RIFT_CLI" execute layout join-window "$2"
		"$RIFT_CLI" execute binding-mode default
		;;

	*)
		echo "usage: $0 toggle-layout|focus-next-display|move-window-next-display|sync-main-gap|service-exit|service-unjoin|service-join <direction>" >&2
		exit 2
		;;
esac
