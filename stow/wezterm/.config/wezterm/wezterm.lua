
-- Pull in the wezterm API
local wezterm = require 'wezterm'
require 'colorscheme'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font('CaskaydiaCove Nerd Font Mono', { weight = 'DemiLight' })
config.font_size = 16.0
config.harfbuzz_features = { 'calt', 'clig', 'liga', 'zero' }
config.line_height = 1.1
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Translucent window effect
config.window_background_opacity = 0.8
config.macos_window_background_blur = 30

-- Command palette
config.command_palette_fg_color = "#c6d0f5"
config.command_palette_bg_color = "#303446"
config.command_palette_font_size = 16.0

-- Window appearance
config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config

