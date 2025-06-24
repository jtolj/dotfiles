local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

local keys = {
	{
		key = "Escape",
		mods = "LEADER",
		action = wezterm.action.Nop,
	},
	{
		key = "g",
		mods = "LEADER",
		action = act.PaneSelect,
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "S",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
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
		key = "P",
		mods = "CMD|SHIFT",
		action = act.ActivateCommandPalette,
	},
}

config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "1cell",
	bottom = "1cell",
}

config.leader = {
	key = "z",
	mods = "SUPER",
	timeout_milliseconds = 10000,
}

config.front_end = "WebGpu"
config.audible_bell = "Disabled"

config.font = wezterm.font("SauceCodePro Nerd Font", {
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
config.keys = keys
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
wezterm.on("update-right-status", function(window, _)
	local prefix = ""

	if window:leader_is_active() then
		prefix = "    L    "
	end

	window:set_right_status(wezterm.format({
		{
			Background = {
				Color = "red",
			},
		},
		{
			Text = prefix,
		},
	}))
end)

return config
