local log = hs.logger.new('mystuff','debug')


function toggle_output(name)

    if name ==  nil then
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
        title='Hammerspoon',
        informativeText='Set output device: '.. device:name()
    }):send()
  end

-- Set default output to headphones
toggle_output("CalDigit Thunderbolt 3 Audio")

hs.hotkey.bind({"ctrl"}, 50, function()
    local app = hs.application.get("kitty")
    if app then
        if not app:mainWindow() then
            app:selectMenuItem({"kitty", "New OS window"})
        elseif app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
       hs.application.launchOrFocus("kitty")
       app = hs.application.get("kitty")
    end
    if app then
        app:mainWindow():moveToUnit'[100,100,0,0]'
    end
  end)

  hs.hotkey.bind({"shift", "cmd"}, "i", function()
    local app = hs.application.get("Notes")
    if app then
        if app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
      hs.application.launchOrFocus("Notes")
    end
    if app then
        app:mainWindow():moveToUnit'[50,100,0,0]'
    end
  end)

  hs.hotkey.bind({"shift", "cmd"}, "b", function()
    local app = hs.application.get("Boop")
    if app then
        if app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
       hs.application.launchOrFocus("Boop")
    end
    if app then
        app:mainWindow():moveToUnit'[50,100,0,0]'
    end
  end)
