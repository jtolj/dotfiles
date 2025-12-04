local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_started")

sbar.exec(
	"aerospace list-workspaces --all --json --format %{workspace}%{workspace-is-focused}%{monitor-id}%{monitor-name}",
	function(workspaces)
		local last_monitor = nil
		for _, workspace in ipairs(workspaces) do
			local sid = workspace["workspace"]
			local isFocused = workspace["workspace-is-focused"]
			local monitor_id = workspace["monitor-id"]
			local monitor_name = workspace["monitor-name"]

			local space = sbar.add("item", "space." .. sid, {
				icon = {
					font = {
						family = settings.font.numbers,
					},
					highlight = isFocused,
					string = sid,
					padding_left = 15,
					padding_right = 8,
					color = colors.grey,
					highlight_color = colors.white,
				},
				padding_right = 1,
				padding_left = 1,
				background = {
					color = colors.with_alpha(colors.bg1, 0.8),
					border_width = 1,
					height = 26,
					border_color = isFocused and colors.white or colors.bg2,
					padding_right = 3,
					padding_left = 3,
				},
				click_script = "aerospace workspace " .. sid,
			})

			if last_monitor ~= monitor_id then
				space:set({
					padding_left = 10,
				})
				last_monitor = monitor_id
			end

			-- Subscribe to workspace changes
			space:subscribe("aerospace_workspace_change", function(env)
				local selected = (sid == env.FOCUSED_WORKSPACE)

				space:set({
					icon = {
						highlight = selected,
					},
					label = {
						highlight = selected,
					},
					background = {
						border_color = selected and colors.white or colors.bg2,
					},
				})
			end)
		end
	end
)
