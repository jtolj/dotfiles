sbar.exec(
	"killall system_stats >/dev/null; $HOME/.local/bin/stats_provider -m ram_usage memory_pressure -c usage -n en0 --no-units"
)
require("items.widgets.battery")
require("items.widgets.wifi")
require("items.widgets.cpu")
require("items.widgets.memory")
