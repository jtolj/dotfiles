local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local headphones = sbar.add("item", "widgets.headphones", {
	position = "right",
	drawing = false,
	updates = "on",
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
	update_freq = 15,
	popup = {
		align = "right",
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

local function parse_output(result)
	local lines = {}
	for line in result:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	return lines
end

local function update_headphones()
	sbar.exec("$CONFIG_DIR/helpers/headphones.sh", function(result)
		local lines = parse_output(result)
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
			popup_left:set({ drawing = true, icon = { string = "Left:" }, label = { string = left .. "%" } })
			popup_right:set({ drawing = true, icon = { string = "Right:" }, label = { string = right .. "%" } })
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
	end)
end

headphones:subscribe({ "routine", "system_woke" }, update_headphones)
update_headphones()

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
