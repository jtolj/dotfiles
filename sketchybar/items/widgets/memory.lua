local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
-- sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local mem = sbar.add("graph", "widgets.memory", 42, {
	position = "right",
	graph = {
		color = colors.green,
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
		string = "m",
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
	},
	padding_right = settings.paddings + 6,
})

mem:subscribe("system_stats", function(env)
	local usage = math.min(tonumber(env.RAM_USAGE), 100)
	local pressure = tonumber(env.MEMORY_PRESSURE)

	mem:push({ usage / 100. })

	local level_color = {
		[1] = colors.green,
		[2] = colors.yellow,
		[4] = colors.red,
	}

	mem:set({
		graph = {
			color = level_color[pressure] or colors.grey,
		},

		label = {
			string = usage .. "%",
			color = pressure == 4 and colors.red or colors.white,
		},
	})
end)

mem:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Activity Monitor'")
end)
