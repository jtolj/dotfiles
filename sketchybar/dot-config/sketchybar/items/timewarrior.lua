local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local timewarrior = sbar.add("item", {
	script = "$CONFIG_DIR/helpers/timew.sh",
	update_freq = 5,
	padding_left = 1,
	padding_right = 1,
	position = "right",
	background = {
		color = colors.bg2,
		border_color = colors.black,
		border_width = 1,
	},
	label = {
		padding_right = 8,
	},
	icon = {
		padding_left = 8,
		padding_right = 10,
		string = icons.clock,
		drawing = true,
		color = colors.grey,
	},
})
