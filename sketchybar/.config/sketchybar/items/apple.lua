local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", {
	width = 5,
})

local apple = sbar.add("item", {
	icon = {
		font = {
			size = 18.0,
		},
		string = icons.apple,
		padding_right = 8,
		padding_left = 8,
	},
	label = {
		drawing = false,
	},
	background = {
		color = colors.bg2,
		border_color = colors.black,
		border_width = 1,
	},
	padding_left = 1,
	padding_right = 10,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})
