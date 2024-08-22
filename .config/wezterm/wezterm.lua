
-- Pull in the wezterm API
local wezterm = require 'wezterm'
require 'colorscheme'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font('CaskaydiaCove Nerd Font Mono', { weight = 'Regular' })
config.font_size = 16.0
config.harfbuzz_features = { 'calt', 'clig', 'liga', 'zero' }
config.line_height = 1.1
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Translucent window effect
config.window_background_opacity = 0.7
config.macos_window_background_blur = 30

-- and finally, return the configuration to wezterm
return config

