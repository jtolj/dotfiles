local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local cpu = sbar.add("graph", "widgets.cpu", 42, {
	position = "right",
	graph = {
		color = colors.blue,
	},
	background = {
		height = 22,
		color = {
			alpha = 0,
		},
		border_color = {
			alpha = 0,
		},
		drawing = true,
	},
	icon = {
		string = "c",
		color = {
			alpha = 0.7,
		},
	},
	label = {
		string = "??%",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 10.0,
		},
		align = "right",
		padding_right = 0,
		width = 0,
		-- y_offset = 4,
	},
	padding_right = settings.paddings + 6,
})

cpu:subscribe("system_stats", function(env)
	local load = math.min(tonumber(env.CPU_USAGE), 100)
	cpu:push({ load / 100. })

	local color = colors.blue
	if load > 30 then
		if load < 60 then
			color = colors.yellow
		elseif load < 80 then
			color = colors.orange
		else
			color = colors.red
		end
	end

	cpu:set({
		graph = {
			color = color,
		},
		label = env.CPU_USAGE .. "%",
	})
end)

cpu:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Activity Monitor'")
end)
