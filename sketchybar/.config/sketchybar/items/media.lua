local icons = require("icons")
local colors = require("colors")

sbar.add("event", "media_change_custom")
-- sbar.exec(
-- 	"killall media_change >/dev/null; $CONFIG_DIR/helpers/event_providers/media_change/bin/media_change media_change_custom 2.0"
-- )

local media_icon = sbar.add("item", "media_icon", {
	updates = true,
	drawing = false,
	position = "right",
	scroll_texts = false,
	padding_left = 0,
	padding_right = 0,
	width = 16,
	icon = {
		padding_right = 16,
		string = icons.media.play,
		drawing = true,
		color = colors.white,
	},
	label = {
		drawing = false,
	},
})

local media_artist = sbar.add("item", "media_artist", {
	updates = true,
	drawing = false,
	script = "$CONFIG_DIR/helpers/media-change.sh",
	update_freq = 3,
	y_offset = -6,
	position = "right",
	scroll_texts = false,
	padding_left = 14,
	padding_right = 30,
	width = 0,
	label = {
		drawing = true,
		font = {
			size = 9,
		},
		max_chars = 32,
	},
})

local media_title = sbar.add("item", "media_title", {
	y_offset = 6,
	position = "right",
	scroll_texts = false,
	drawing = false,
	padding_left = 14,
	padding_right = 30,
	updates = true,
	width = 0,
	icon = {
		drawing = false,
	},
	label = {
		drawing = true,
		font = {
			size = 9,
		},
		max_chars = 32,
	},
})
local media_bracket = sbar.add("bracket", "widgets.media.bracket", {
	media_title.name,
	media_artist.name,
	media_icon.name,
}, {
	background = { color = colors.bg1 },
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

	if env.APP_NAME == "TIDAL" then
	else
	end

	local icon = icons.media.play

	if env.STATE == "playing" then
		icon = icons.media.pause
	end

	media_icon:set({
		icon = {
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
