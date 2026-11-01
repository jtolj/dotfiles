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

local function update_front_app()
	sbar.exec("/opt/homebrew/bin/rift-cli query windows", function(windows)
		if type(windows) ~= "table" then
			front_app:set({ label = { string = "" } })
			return
		end

		for _, window in ipairs(windows) do
			if window.is_focused then
				front_app:set({ label = { string = window.app_name or "" } })
				return
			end
		end

		front_app:set({ label = { string = "" } })
	end)
end

front_app:subscribe("rift_refresh", update_front_app)

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)
