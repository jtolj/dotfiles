local log = hs.logger.new('mystuff', 'debug')

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
  hs.notify.new({
    title = 'Hammerspoon',
    informativeText = 'Set output device: ' .. device:name()
  }):send()
end

-- Set default output to headphones
toggle_output("CalDigit Thunderbolt 3 Audio")

-- Watch for space changes
local last_focused_space = nil
local currently_focused_space =  hs.spaces.activeSpaceOnScreen(hs.screen.mainScreen())
local space_watcher = hs.spaces.watcher.new(function ()
  last_focused_space = currently_focused_space
  currently_focused_space = hs.spaces.activeSpaceOnScreen(hs.screen.mainScreen())
  -- log.d("Space changed from " .. last_focused_space .. " to " .. currently_focused_space)
end)
space_watcher:start()

hs.hotkey.bind({ "ctrl" }, 50, function()
  local app = hs.application.get("kitty")
  if app then
    if app:isFrontmost() then
      app:hide()
      if (last_focused_space and last_focused_space ~= hs.spaces.activeSpaceOnScreen(hs.screen.mainScreen())) then
        hs.spaces.gotoSpace(last_focused_space)
      end
    elseif not app:mainWindow() then
      app:activate()
      app:selectMenuItem({ "Shell", "New OS Window" })
    else
      app:activate()
    end
  else
    hs.application.launchOrFocus("kitty")
    app = hs.application.get("kitty")
  end
  if app then
    app:mainWindow():moveToUnit '[100,100,0,0]'
  end
end)