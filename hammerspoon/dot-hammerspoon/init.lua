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
function wezterm()
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
end
hs.hotkey.bind({ "ctrl" }, 50, function()
	wezterm()
end)
