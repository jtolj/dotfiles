local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local headphones = sbar.add("item", "widgets.headphones", {
	position = "right",
	drawing = false,
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 19.0,
		},
	},
	label = {
		font = {
			family = settings.font.numbers,
		},
	},
	popup = {
		align = "right",
	},
})

local audio_output = sbar.add("item", "widgets.audio.output", {
	position = "right",
	width = 0,
	y_offset = 5,
	padding_right = 25,
	scroll_texts = false,
	updates = "on",
	update_freq = 15,
	icon = { drawing = false },
	label = {
		string = "Output",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Regular"],
			size = 9.0,
		},
		color = colors.white,
	},
})

local audio_input = sbar.add("item", "widgets.audio.input", {
	position = "right",
	y_offset = -5,
	scroll_texts = false,
	icon = { drawing = false },
	label = {
		string = "Input",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Regular"],
			size = 9.0,
		},
		color = colors.white,
	},
})

local popup_left = sbar.add("item", {
	position = "popup." .. headphones.name,
	scroll_texts = true,
	icon = {
		string = "Left:",
		width = 100,
		align = "left",
	},
	label = {
		string = "?",
		width = 200,
		align = "right",
	},
})

local popup_right = sbar.add("item", {
	position = "popup." .. headphones.name,
	scroll_texts = true,
	icon = {
		string = "Right:",
		width = 100,
		align = "left",
	},
	label = {
		string = "?",
		width = 200,
		align = "right",
	},
})

local popup_case = sbar.add("item", {
	position = "popup." .. headphones.name,
	scroll_texts = true,
	icon = {
		string = "Case:",
		width = 100,
		align = "left",
	},
	label = {
		string = "?",
		width = 200,
		align = "right",
	},
})

local is_airpods = false

local function update_headphones(lines)
	if #lines == 0 or lines[1] == "none" or lines[1] == "error" then
		is_airpods = false
		headphones:set({ drawing = false })
		return
	end

	local name = lines[1]
	local device_type = lines[2]
	local main = lines[3] ~= "-" and tonumber(lines[3]) or nil
	local left = lines[4] ~= "-" and tonumber(lines[4]) or nil
	local right = lines[5] ~= "-" and tonumber(lines[5]) or nil
	local case = lines[6] ~= "-" and tonumber(lines[6]) or nil
	local vendor_id = lines[7] ~= "-" and lines[7] or ""

	local display_level
	if left and right then
		display_level = math.min(left, right)
	elseif main then
		display_level = main
	else
		headphones:set({ drawing = false })
		return
	end

	local color = colors.with_alpha(colors.white, 0.8)
	if display_level <= 20 then
		color = colors.red
	elseif display_level <= 40 then
		color = colors.with_alpha(colors.orange, 0.8)
	end

	is_airpods = vendor_id == "0x004C"
	headphones:set({
		drawing = true,
		icon = {
			string = is_airpods and icons.airpods or icons.headphones,
			color = color,
		},
		label = {
			string = display_level .. "%",
			color = color,
		},
	})

	if is_airpods then
		popup_left:set({
			drawing = true,
			icon = { string = "Left:" },
			label = { string = left and left .. "%" or "N/A" },
		})
		popup_right:set({
			drawing = true,
			icon = { string = "Right:" },
			label = { string = right and right .. "%" or "N/A" },
		})
		popup_case:set({
			drawing = case ~= nil,
			icon = { string = "Case:" },
			label = { string = case and case .. "%" or "N/A" },
		})
	else
		popup_left:set({ drawing = true, icon = { string = "Device:" }, label = { string = name } })
		popup_right:set({ drawing = true, icon = { string = "Type:" }, label = { string = device_type } })
		popup_case:set({
			drawing = main ~= nil,
			icon = { string = "Battery:" },
			label = { string = main and main .. "%" or "N/A" },
		})
	end
end

local function update_audio(lines)
	local output = lines[1] or "None"
	local input = lines[2] or "None"
	local input_label = input == output and "" or input
	local output_is_wider = #output >= #input_label

	audio_output:set({
		width = output_is_wider and -1 or 0,
		label = { string = output },
	})
	audio_input:set({
		width = output_is_wider and 0 or -1,
		label = { string = input_label },
	})
end

local function refresh_devices()
	sbar.exec("$CONFIG_DIR/helpers/devices.sh", function(result)
		local sections = { bluetooth = {}, audio = {} }
		local current
		for line in result:gmatch("[^\r\n]+") do
			if line == "bluetooth" or line == "audio" then
				current = line
			elseif current then
				table.insert(sections[current], line)
			end
		end

		update_headphones(sections.bluetooth)
		update_audio(sections.audio)
	end)
end

audio_output:subscribe({ "routine", "system_woke" }, refresh_devices)
refresh_devices()

local function open_audio_settings()
	sbar.exec('open "x-apple.systempreferences:com.apple.Sound-Settings.extension" || open /System/Library/PreferencePanes/Sound.prefpane')
end

audio_output:subscribe("mouse.clicked", open_audio_settings)
audio_input:subscribe("mouse.clicked", open_audio_settings)

headphones:subscribe("mouse.clicked", function(env)
	headphones:set({
		popup = {
			drawing = "toggle",
		},
	})
end)

sbar.add("item", "widgets.headphones.padding", {
	position = "right",
	width = settings.group_paddings,
})
