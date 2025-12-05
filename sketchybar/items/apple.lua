local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local apple = sbar.add("item", {
	icon = {
		font = {
			size = 18.0,
		},
		string = icons.apple,
		padding_left = 8,
	},
	label = {
		drawing = false,
	},
	padding_left = 1,
	padding_right = 10,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})
