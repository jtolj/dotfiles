local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

sbar.add("event", "timewarrior_updated")

local timewarrior = sbar.add("item", {
	padding_left = 6,
	padding_right = 1,
	position = "right",
	background = {
		color = colors.bg2,
		border_color = colors.black,
		border_width = 1,
	},
	label = {
		drawing = false,
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

timewarrior:subscribe("timewarrior_updated", function(env)
	if env.ACTIVE == "0" then
		timewarrior:set({
			label = { drawing = false },
			icon = {
				padding_left = 8,
				padding_right = 10,
				color = colors.grey,
			},
		})
	else
		timewarrior:set({
			label = {
				string = env.LABEL,
				drawing = true,
			},
			icon = {
				padding_left = 8,
				padding_right = 10,
				color = colors.yellow,
			},
		})
	end
end)
