local colors = require("colors")

sbar.bar("main", {
	color = colors.with_alpha(colors.bg1, 0.6),
})

require("items.apple")
require("items.aerospace")
require("items.front_app")
require("items.calendar")
require("items.widgets")
require("items.timewarrior")
require("items.media")
