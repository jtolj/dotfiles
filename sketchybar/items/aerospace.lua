local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_started")

-- Sketchybar doesn't support asynchronously adding items to a bracket, so pre-rendering these to
-- have control of the order of where this element is added to the bar.
local aerospace_watcher = sbar.add("item", "aerospace_watcher", {
	drawing = true,
	label = {
		drawing = false,
	},
	icon = {
		drawing = false,
	},
})

local spaces_table = {}
for i = 1, 6 do
	spaces_table[i] = sbar.add("item", "space." .. i, {
		drawing = false,
		label = {
			font = {
				family = settings.font.numbers,
			},
			highlight = false,
			string = i,
			padding_left = 1,
			padding_right = 1,
			color = colors.grey,
			highlight_color = colors.white,
		},
		click_script = "aerospace workspace " .. i,
	})
end

-- Subscribe to workspace changes from our dummy item so we only need one watcher
local current_workspace = nil
aerospace_watcher:subscribe("aerospace_workspace_change", function(env)
	local space = env.FOCUSED_WORKSPACE and spaces_table[tonumber(env.FOCUSED_WORKSPACE)]
	local prev_space = current_workspace and spaces_table[tonumber(current_workspace)]

	if space then
		current_workspace = env.FOCUSED_WORKSPACE
		space:set({
			icon = {
				highlight = true,
			},
			label = {
				highlight = true,
			},
			background = {
				border_color = colors.white,
			},
		})
	end

	if prev_space then
		prev_space:set({
			label = {
				highlight = false,
			},
			background = {
				border_color = colors.transparent,
			},
		})
	end
end)

sbar.exec(
	"aerospace list-workspaces --all --json --format %{workspace}%{workspace-is-focused}%{monitor-id}%{monitor-name}",
	function(workspaces)
		local last_monitor = nil
		for _, workspace in ipairs(workspaces) do
			local sid = workspace["workspace"]
			local isFocused = workspace["workspace-is-focused"]
			local monitor_id = workspace["monitor-id"]
			local monitor_name = workspace["monitor-name"]

			local space = spaces_table[tonumber(sid)]

			space:set({
				drawing = true,
			})

			if last_monitor ~= monitor_id and monitor_id > 1 then
				space:set({
					icon = {
						string = "|",
						padding_right = 16,
						color = colors.grey,
						highlight_color = colors.white,
					},
					padding_left = 8,
				})
				last_monitor = monitor_id
			end

			if isFocused then
				current_workspace = sid
				space:set({
					label = {
						highlight = true,
					},
					background = {
						border_color = colors.white,
					},
				})
			end
		end
	end
)
