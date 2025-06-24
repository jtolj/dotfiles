local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_started")

sbar.exec("aerospace list-workspaces --focused", function(focused_sid)
    sbar.exec("aerospace list-workspaces --all", function(all_sids)
        for sid in string.gmatch(all_sids, '[^\r\n]+') do
            local isFocused = (sid == focused_sid:sub(1, -2))
            local space = sbar.add("item", "space." .. sid, {
                icon = {
                    font = {
                        family = settings.font.numbers
                    },
                    highlight = isFocused,
                    string = sid,
                    padding_left = 15,
                    padding_right = 8,
                    color = colors.grey,
                    highlight_color = colors.white
                },
                padding_right = 1,
                padding_left = 1,
                background = {
                    color = colors.bg1,
                    border_width = 1,
                    height = 26,
                    border_color = isFocused and colors.white or colors.bg2,
                    padding_right = 3,
                    padding_left = 3
                },
                click_script = "aerospace workspace " .. sid
            })

            -- Subscribe to workspace changes
            space:subscribe("aerospace_workspace_change", function(env)
                local selected = (sid == env.FOCUSED_WORKSPACE)

                space:set({
                    icon = {
                        highlight = selected
                    },
                    label = {
                        highlight = selected
                    },
                    background = {
                        border_color = selected and colors.white or colors.bg2
                    }
                })
            end)
        end
    end)
end)
