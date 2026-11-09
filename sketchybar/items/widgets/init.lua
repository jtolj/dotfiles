sbar.exec(
	"killall system_stats >/dev/null; $CONFIG_DIR/helpers/event_providers/sketchybar-system-stats/target/release/stats_provider -m ram_usage -c usage -n en0 --no-units"
)

require("items.widgets.battery")
require("items.widgets.wifi")
require("items.widgets.cpu")
require("items.widgets.memory")
