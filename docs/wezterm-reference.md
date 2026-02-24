# 🖥️ WezTerm Reference

WezTerm is a GPU-accelerated cross-platform terminal emulator written in
Rust. This reference covers the configuration and usage within this dotfiles
setup.

## ⚙️ Configuration Overview

**Location**: `stow/wezterm/.config/wezterm/`
**Main Config**: `wezterm.lua`
**Color Scheme**: `colorscheme.lua`

The WezTerm configuration is designed for optimal development experience on
macOS with:

- Automatic tmux session management
- Catppuccin theme integration
- High DPI display optimization
- Translucent window effects

## 🔧 Core Configuration

### 💻 Default Program and Session Management

```lua
local default_session = os.getenv("TMUX_DEFAULT_SESSION") or "default"
config.default_prog = { 'zsh', '-l', '-c', 'tmux new-session -A -s ' .. default_session }
```

- **Auto-launches tmux**: Every new WezTerm instance automatically starts or
  attaches to a tmux session
- **Session naming**: Uses `TMUX_DEFAULT_SESSION` environment variable or
  defaults to "default"
- **Session persistence**: `tmux new-session -A -s` creates new session or
  attaches to existing one

### 🔤 Font Configuration

```lua
config.font = wezterm.font('Departure Mono')
config.font_size = 16.0
config.harfbuzz_features = { 'calt', 'clig', 'liga', 'zero' }
config.line_height = 1.1
```

- **Primary Font**: Departure Mono (modern programming font)
- **Alternative**: CaskaydiaCove Nerd Font Mono DemiLight (commented out)
- **Font Features**: Contextual alternates, ligatures, stylistic zero
- **Optimized spacing**: 1.1 line height for readability

### 🎨 Visual Appearance

#### 🌆 Window Effects

```lua
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"
```

- **Transparency**: 90% opacity with 30px blur radius
- **Native macOS integration**: Proper shadows and window controls
- **Resizable**: Standard window resize functionality

#### 📋 Tab Bar Configuration

```lua
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
```

- **Minimal tab bar**: Clean, unfancy appearance
- **Auto-hide**: Tab bar hidden when only one tab is open
- **Reduces visual clutter**: Focus on terminal content

### 🎨 Color Scheme Management

**File**: `colorscheme.lua`

```lua
function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Frappe"
  else
    return "Catppuccin Latte"
  end
end
```

- **Automatic theme switching**: Based on macOS system appearance
- **Dark mode**: Catppuccin Frappe (dark blue-tinted theme)
- **Light mode**: Catppuccin Latte (warm light theme)
- **System integration**: Follows macOS Dark/Light mode settings

### 🖐️ Text Selection and Interaction

```lua
config.selection_word_boundary = ' \t\n{}[]()"\'|│'
```

- **Smart word selection**: Double-click respects programming syntax
- **Includes common delimiters**: Brackets, quotes, pipes, box drawing characters
- **Optimized for code**: Works well with various programming languages

### 🎨 Command Palette

```lua
config.command_palette_fg_color = "#c6d0f5"
config.command_palette_bg_color = "#303446"
config.command_palette_font_size = 16.0
```

- **Catppuccin colors**: Matches overall theme
- **Accessible contrast**: Light text on dark background
- **Consistent sizing**: Matches main font size

### 🔔 Visual Bell Configuration

```lua
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 200,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 200,
}
config.colors = {
  visual_bell = '#414559',
}
config.audible_bell = "Disabled"
```

- **Visual feedback**: Subtle screen flash instead of system beep
- **Smooth animation**: 200ms fade in/out with easing
- **Subtle color**: Dark gray that doesn't jar the eyes
- **Silent operation**: Audio bell completely disabled

## ⌨️ Default Keybindings

WezTerm uses both standard macOS keybindings (⌘/Cmd) and its own
terminal-specific shortcuts (Ctrl+Shift). Note that when running tmux, some
keybindings may be handled by tmux instead.

### 🧭 Basic Navigation

- **⌘ + T**: New tab
- **⌘ + W**: Close tab (with confirmation)
- **⌘ + ⇧ + [/]**: Switch between tabs
- **⌘ + 1-9**: Jump to specific tab (⌘ + 9 goes to last tab)
- **Ctrl + Alt + "**: Split pane vertically
- **Ctrl + Alt + %**: Split pane horizontally
- **Ctrl + ⇧ + ↑/↓/←/→**: Navigate between panes
- **Ctrl + ⇧ + Alt + ↑/↓/←/→**: Resize panes

### 📝 Text Operations

- **⌘ + C/V**: Copy/paste
- **⌘ + F**: Find/search
- **⌘ + K**: Clear scrollback
- **⌘ + +/-**: Increase/decrease font size
- **⌘ + 0**: Reset font size
- **Ctrl + ⇧ + X**: Activate copy mode (vim-like navigation)
- **Ctrl + ⇧ + Space**: Quick select mode
- **Ctrl + ⇧ + U**: Character select (emoji picker)

### 🎦 Window Management

- **⌘ + N**: New window
- **⌘ + M**: Minimize window
- **Alt + Enter**: Toggle fullscreen
- **Ctrl + ⇧ + P**: Command palette
- **Ctrl + ⇧ + R**: Reload configuration
- **Ctrl + ⇧ + L**: Debug overlay
- **Ctrl + ⇧ + Z**: Toggle pane zoom

## 🔗 Integration with Dotfiles Setup

### 💾 Installation

WezTerm is installed via Homebrew as defined in `.Brewfile`:

```ruby
cask 'wezterm'
```

### 📦 Stow Management

Configuration is deployed using GNU Stow from the dotfiles directory:

```bash
# Deploy WezTerm configuration
cd ~/.dotfiles
stow -d stow -t ~ wezterm

# Remove WezTerm configuration
stow -d stow -t ~ -D wezterm
```

### 📂 Directory Structure

```text
stow/wezterm/
└── .config/
    └── wezterm/
        ├── wezterm.lua       # Main configuration
        └── colorscheme.lua   # Theme management
```

## 🖥️ Tmux Integration

The configuration is designed to work seamlessly with tmux:

### 🤖 Automatic Session Management

- **New WezTerm window**: Automatically creates or joins tmux session
- **Session naming**: Controlled via `TMUX_DEFAULT_SESSION` environment variable
- **Persistent sessions**: Sessions survive WezTerm restarts

### ⌨️ Key Coordination

- **WezTerm**: Handles window-level operations (new windows, font sizing)
- **Tmux**: Handles session/pane management within terminal
- **Clear separation**: Minimal overlap in functionality

## 🐛 Troubleshooting

### ⚠️ Common Issues

#### 🔤 Font Not Found

If Departure Mono is not installed:

1. Install the font system-wide
2. Or uncomment the CaskaydiaCove alternative in `wezterm.lua:15`

#### 🖥️ Tmux Not Starting

If tmux fails to launch:

1. Ensure tmux is installed: `brew install tmux`
2. Check tmux configuration is valid: `tmux source ~/.config/tmux/tmux.conf`
3. Test tmux separately: `tmux new-session -A -s test`
4. Temporarily comment out `default_prog` line in wezterm.lua for debugging

#### 🎨 Color Scheme Issues

If colors appear incorrect:

1. Verify Catppuccin themes are available in WezTerm
2. Check system appearance settings (Dark/Light mode)
3. Test with fixed color scheme instead of automatic switching

#### 🚀 Performance Issues

If experiencing lag or high CPU usage:

1. Disable transparency: Set `window_background_opacity = 1.0`
2. Reduce blur: Set `macos_window_background_blur = 0`
3. Check for background processes consuming GPU

### ✅ Configuration Validation

Test configuration changes:

```bash
# Check syntax (load config without opening terminal)
wezterm show-keys --lua > /dev/null

# Launch with specific config for testing
wezterm start --config-file /path/to/test/config.lua

# Show current keybindings
wezterm show-keys --lua
```

### 🔍 Debugging

Enable debug logging:

```lua
-- Add to wezterm.lua for debugging
config.debug_key_events = true
```

## 🎆 Advanced Customization

### ⌨️ Custom Key Bindings

To add custom keybindings, extend the configuration:

```lua
local act = wezterm.action

config.keys = {
  -- Example: Disable default key
  { key = 'Enter', mods = 'ALT', action = act.DisableDefaultAssignment },

  -- Example: Custom pane splitting (more intuitive)
  { key = '|', mods = 'CMD|SHIFT', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CMD|SHIFT', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },

  -- Example: Quick tab switching
  { key = 'LeftArrow', mods = 'CMD', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD', action = act.ActivateTabRelative(1) },
}
```

### 🔤 Alternative Fonts

Popular programming fonts that work well:

- **JetBrains Mono**: `wezterm.font('JetBrains Mono')`
- **Fira Code**: `wezterm.font('Fira Code')`
- **Source Code Pro**: `wezterm.font('Source Code Pro')`
- **SF Mono**: `wezterm.font('SF Mono')` (system font)

### 🚀 Performance Tuning

For high-refresh displays or performance optimization:

```lua
-- Reduce frame rate for better battery life
config.max_fps = 60

-- Optimize scrollback
config.scrollback_lines = 10000

-- Reduce memory usage
config.alternate_buffer_wheel_scroll_speed = 3
```

## 📚 References

- **Official Documentation**: <https://wezfurlong.org/wezterm/>
- **Configuration Reference**: <https://wezfurlong.org/wezterm/config/files.html>
- **Key Bindings**: <https://wezfurlong.org/wezterm/config/default-keys.html>
- **Color Schemes**: <https://wezfurlong.org/wezterm/colorschemes/index.html>
- **Catppuccin Theme**: <https://github.com/catppuccin/wezterm>

## 🔗 Related Documentation

- **[Tmux Reference](tmux-reference.md)** - Terminal multiplexer configuration
- **[Architecture](architecture.md)** - Overall dotfiles structure
- **[Setup Guide](setup-guide.md)** - Installation and deployment
