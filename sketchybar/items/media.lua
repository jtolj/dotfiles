local icons = require("icons")
local app_icons = require("helpers/app_icons")
local colors = require("colors")

sbar.add("event", "media_change_custom")
sbar.exec("$CONFIG_DIR/helpers/event_providers/media_change_custom/media_change")

local media_icon = sbar.add("item", "media_icon", {
	click_script = "media-control toggle-play-pause",
	updates = true,
	drawing = false,
	position = "right",
	scroll_texts = false,
	label = {
		width = 32,
		string = icons.media.play,
		drawing = true,
		color = colors.white,
		padding_left = 12,
		padding_right = 12,
	},
	icon = {
		width = 16,
		font = { family = "sketchybar-app-font", style = "Regular", size = 16 },
		drawing = false,
	},
})

local media_artist = sbar.add("item", "media_artist", {
	updates = true,
	drawing = false,
	y_offset = -6,
	position = "right",
	scroll_texts = false,
	width = 0,
	label = {
		drawing = true,
		font = {
			size = 9,
		},
		max_chars = 16,
	},
})

local media_title = sbar.add("item", "media_title", {
	y_offset = 6,
	position = "right",
	scroll_texts = false,
	drawing = false,
	updates = true,
	width = 0,
	label = {
		drawing = true,
		font = {
			size = 9,
		},
		max_chars = 16,
	},
})

local media_bracket = sbar.add("bracket", "widgets.media.bracket", {
	media_title.name,
	media_artist.name,
	media_icon.name,
}, {
	background = { color = colors.bg1, padding_left = 10, padding_right = 10 },
})

media_title:subscribe("mouse.entered", function()
	media_artist:set({
		scroll_texts = true,
	})
	media_title:set({
		scroll_texts = true,
	})
end)

media_title:subscribe("mouse.exited", function()
	media_artist:set({
		scroll_texts = false,
	})
	media_title:set({
		scroll_texts = false,
	})
end)

media_title:subscribe("media_change_custom", function(env)
	local drawing = (env.STATE ~= "gone")

	local icon = icons.media.play

	if (env.APP_NAME == nil) or (env.APP_NAME == "") then
		media_icon:set({
			icon = {
				string = "",
				drawing = false,
			},
		})
	else
		sbar.exec("lsappinfo info -only bundlename " .. env.APP_NAME, function(result)
			local app_name = result:match('"CFBundleName"="([^"]+)"')
			local app_icon_str = app_icons[app_name] or ":music:"

			media_icon:set({
				icon = {
					string = app_icon_str,
					drawing = drawing,
				},
			})
		end)
	end

	if env.STATE == "playing" then
		icon = icons.media.pause
	end

	media_icon:set({
		label = {
			string = icon,
		},
		drawing = drawing,
	})

	media_artist:set({
		drawing = drawing,
		label = env.ARTIST,
	})

	media_title:set({
		drawing = drawing,
		label = env.TITLE,
	})
end)
