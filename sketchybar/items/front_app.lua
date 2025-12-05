local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	icon = { drawing = false },
	label = {
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	updates = true,
})

front_app:subscribe("aerospace_workspace_change", function(env)
	sbar.exec('aerospace list-windows --focused --format "%{app-name}"', function(app_name, exit_code)
		if exit_code == 1 then
			front_app:set({ label = { string = "" } })
		else
			front_app:set({ label = { string = app_name or "" } })
		end
	end)
end)

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)
