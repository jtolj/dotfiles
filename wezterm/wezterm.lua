local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local keys = {
	{
		key = "Escape",
		mods = "LEADER",
		action = act.Nop,
	},
	{
		key = "g",
		mods = "LEADER",
		action = act.PaneSelect,
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "S",
		mods = "LEADER",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "\\",
		mods = "LEADER",
		action = wezterm.action_callback(function(window)
			local overrides = window:get_config_overrides() or {}
			if overrides.font_size then
				overrides.font_size = nil
			else
				overrides.font_size = 20.0
			end
			window:set_config_overrides(overrides)
		end),
	},
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "p",
		mods = "CMD",
		action = act.ShowTabNavigator,
	},
	{
		key = "s",
		mods = "CMD",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "P",
		mods = "CMD|SHIFT",
		action = act.ActivateCommandPalette,
	},
	{
		key = "o",
		mods = "CTRL",
		action = wezterm.action({
			QuickSelectArgs = {
				action = wezterm.action_callback(function(window, pane)
					local selection = window:get_selection_text_for_pane(pane)
					if selection and selection:match("^https?://") then
						wezterm.open_with(selection)
					elseif selection then
						window:copy_to_clipboard(selection, "Clipboard")
					end
				end),
			},
		}),
	},
	-- Workspaces
	{
		key = "q",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			name = "podminer",
			spawn = {
				cwd = os.getenv("HOME") .. "/Projects/native/podminer",
				args = { os.getenv("SHELL"), "-lc", "nvim" },
			},
		}),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			name = "dotfiles",
			spawn = {
				cwd = os.getenv("HOME") .. "/Projects/dotfiles",
				args = { os.getenv("SHELL"), "-lc", "nvim" },
			},
		}),
	},
}

-- neovim integration

local function is_nvim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name

	return process_name == "nvim"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_nvim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local nav_keys = {
	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

for _, v in pairs(nav_keys) do
	table.insert(keys, v)
end

config.keys = keys

config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "1cell",
	bottom = "1cell",
}

config.leader = {
	key = "F18",
	mods = "SUPER",
	timeout_milliseconds = 10000,
}

config.front_end = "WebGpu"
config.audible_bell = "Disabled"

config.font = wezterm.font("Hasklug Nerd Font Mono", {
	weight = "Regular",
	italic = false,
})

config.font_size = 16.0
config.color_scheme = "Tokyo Night (Gogh)"
config.colors = {
	background = "#1C1E26",
}

config.window_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.disable_default_key_bindings = false
config.use_dead_keys = false
config.scrollback_lines = 10000
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.send_composed_key_when_right_alt_is_pressed = false

config.window_frame = {
	font = wezterm.font({
		family = "Noto Sans",
		weight = "Regular",
	}),
	font_size = 14.0,
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- https://github.com/MariaSolOs/dotfiles/blob/daeff7d07e82186a75854ea44b9fd66c3ab50689/.config/wezterm/wezterm.lua#L136
wezterm.on("format-tab-title", function(tab)
	-- Get the process name.
	local process = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

	-- Current working directory.
	local cwd = tab.active_pane.current_working_dir
	cwd = cwd and string.format("%s ", cwd.file_path:gsub(os.getenv("HOME"), "~")) or ""

	-- Zoomed state
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "+"
	end

	-- Format and return the title.
	return string.format("(%s%d %s) %s", zoomed, tab.tab_index + 1, process, cwd)
end)

wezterm.on("update-right-status", function(window, _)
	local items = {}

	if window:active_workspace() ~= "default" then
		table.insert(items, { Background = { Color = "#1C1E26" } })
		table.insert(items, { Text = "  " .. window:active_workspace() .. "   " })
	end

	if window:leader_is_active() then
		table.insert(items, { Foreground = { Color = "red" } })
		table.insert(items, { Text = "  L  " })
	end

	window:set_right_status(wezterm.format(items))
end)

return config
