local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

sbar.add("event", "rift_refresh")

-- Sketchybar doesn't support asynchronously adding items to a bracket, so pre-rendering these to
-- have control of the order of where this element is added to the bar.
local rift_watcher = sbar.add("item", "rift_watcher", {
	width = 0,
	drawing = true,
	label = {
		drawing = false,
	},
	icon = {
		drawing = false,
	},
})

-- Shows which display's workspaces are currently in the bar: a monitor for
-- external displays, a laptop for the built-in one.
local display_icon = sbar.add("item", "rift_display", {
	icon = {
		font = {
			size = 14.0,
		},
		string = icons.display,
		color = colors.grey,
		padding_left = 4,
		padding_right = 7,
	},
	label = {
		drawing = false,
	},
})

local workspace_count = 3
local spaces_table = {}
for i = 1, workspace_count do
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
		click_script = "/opt/homebrew/bin/rift-cli execute workspace switch " .. (i - 1),
	})
end

local function highlight_space(active_index)
	for i, space in ipairs(spaces_table) do
		local is_active = i == active_index
		space:set({
			label = {
				highlight = is_active,
			},
			background = {
				border_color = is_active and colors.white or colors.transparent,
			},
		})
	end
end

local function is_builtin_display(name)
	if not name then
		return false
	end

	local lowered = name:lower()
	return lowered:find("built%-in") ~= nil or lowered:find("color lcd") ~= nil or lowered:find("internal") ~= nil
end

local refresh_generation = 0

local function refresh_workspaces()
	refresh_generation = refresh_generation + 1
	local generation = refresh_generation

	sbar.exec("/opt/homebrew/bin/rift-cli query displays", function(displays)
		-- Drop responses that arrived after a newer refresh was requested.
		if generation ~= refresh_generation or type(displays) ~= "table" then
			return
		end

		local display = nil
		for _, candidate in ipairs(displays) do
			if candidate.is_active_context then
				display = candidate
				break
			end
		end

		if display then
			display_icon:set({
				icon = {
					string = is_builtin_display(display.name) and icons.laptop or icons.display,
				},
			})
		end

		-- Resolve the workspaces against the display we just identified, so the
		-- icon and the highlighted workspace can never disagree.
		local query = "/opt/homebrew/bin/rift-cli query workspaces"
		if display then
			query = query .. " --display " .. display.uuid
		end

		sbar.exec(query, function(workspaces)
			if generation ~= refresh_generation or type(workspaces) ~= "table" then
				return
			end

			local active_index = nil
			for _, workspace in ipairs(workspaces) do
				local space = spaces_table[workspace.index + 1]
				if space then
					local label = workspace.name
					if label == nil or label == "" then
						label = tostring(workspace.index + 1)
					end

					space:set({
						drawing = true,
						label = {
							string = label,
						},
					})
					if workspace.is_active then
						active_index = workspace.index + 1
					end
				end
			end

			-- Leave the highlight alone if no workspace reported itself active, so a
			-- transient query never blanks the indicator.
			if active_index then
				highlight_space(active_index)
			end
		end)
	end)
end

-- Subscribe to refreshes from our dummy item so we only need one watcher.
rift_watcher:subscribe("rift_refresh", refresh_workspaces)

-- Rift has no "main display" gap key, so reapply its per-display top gap when
-- macOS changes the display arrangement or main display. SketchyBar fires this
-- after screen parameters settle; a short delay lets Rift observe the new list.
rift_watcher:subscribe("display_change", function()
	sbar.exec("/bin/sh -c 'sleep 0.5; /bin/sh /Users/jesse/.config/rift/rift-helper.sh sync-main-gap'")
	refresh_workspaces()
end)

refresh_workspaces()
