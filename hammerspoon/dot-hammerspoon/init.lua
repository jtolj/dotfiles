require("hs.ipc")
hs.ipc.cliInstall("/opt/homebrew")
local log = hs.logger.new("debug:", "debug")

function slowAlert(message)
	hs.alert.closeAll()
	hs.alert.show(message, 6)
end

function toggle_output(name)
	if name == nil then
		return
	end

	local current = hs.audiodevice.defaultOutputDevice()
	local device = hs.audiodevice.findOutputByName(name)

	if device == nil then
		return
	end

	if current:uid() == device:uid() then
		return
	end

	device:setDefaultOutputDevice()
	hs.notify
		.new({
			title = "Hammerspoon",
			informativeText = "Set output device: " .. device:name(),
		})
		:send()
end

-- Set default output to headphones
toggle_output("CalDigit Thunderbolt 3 Audio")

-- Quake-ish mode for WezTerm
hs.hotkey.bind({ "ctrl" }, 50, function()
	local wez = hs.application.get("com.github.wez.wezterm")
	if wez then
		if wez:isFrontmost() then
			hs.eventtap.keyStroke({ "cmd" }, "TAB")
		elseif not wez:mainWindow() then
			wez:activate()
		-- wez:selectMenuItem({ "Shell", "New OS Window" })
		else
			wez:activate()
		end
	else
		hs.application.launchOrFocus("WezTerm")
	end
end)

-- Hyper Mode
-- A global variable for the Hyper Mode
local k = hs.hotkey.modal.new({}, nil)

-- list all alphanumeric and directional keys in a table
local keyMap = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	";",
	",",
	".",
	"/",
	"-",
	"=",
	"'",
	"[",
	"up",
	"down",
	"left",
	"right",
}

-- Look through the keyMap table and bind each key to Hyper+Key
for i, key in ipairs(keyMap) do
	k:bind({}, key, nil, function()
		hs.eventtap.keyStroke({ "cmd", "alt", "ctrl", "shift" }, key)
		k.triggered = true
	end)
end

-- Enter Hyper Mode when F17 (Hyper/Capslock) is pressed
pressedF17 = function()
	k.triggered = false
	k:enter()
end

-- Leave Hyper Mode when F17 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF17 = function()
	k:exit()
	if not k.triggered then
		hs.eventtap.keyStroke({}, "ESCAPE")
	end
end

f17 = hs.hotkey.bind({}, "F17", pressedF17, releasedF17)
