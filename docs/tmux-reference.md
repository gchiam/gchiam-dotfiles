# 📋 Tmux Keybindings Reference

A comprehensive guide to all tmux keybindings configured in this dotfiles setup.

## ⌨️ Prefix Key

**Prefix**: `Ctrl + Space` (changed from default `Ctrl + b`)

## 🎨 Theming

Tmux uses **Catppuccin** theme with automatic switching based on system
appearance:

- **Light mode**: Catppuccin Latte theme
- **Dark mode**: Catppuccin Frappe theme

### 🔄 Automatic Theme Switching

The configuration includes an automated service that monitors macOS system theme
changes and automatically reloads tmux configuration to switch themes:

**Setup the auto-switcher:**

```bash
./bin/setup-tmux-theme-watcher
```

This creates a launch agent that:

- Monitors system appearance changes
- Automatically runs `tmux source-file ~/.tmux.conf` when theme changes
- Uses `fswatch` for efficient monitoring (install with `brew install fswatch`)
- Falls back to polling method if `fswatch` is not available
- Logs activity to `~/.local/log/`

**Manual theme reload:**

```bash
tmux source-file ~/.tmux.conf
```

## ⚙️ Core Commands

| Keybinding              | Action               | Description                            |
| ----------------------- | -------------------- | -------------------------------------- |
| `Prefix + R`            | Reload configuration | Reloads ~/.tmux.conf and shows confirm |
| `Prefix + Ctrl + Space` | Send prefix          | Sends the prefix key to application    |

## 📋 Session Management

| Keybinding          | Action            | Description                             |
| ------------------- | ----------------- | --------------------------------------- |
| `Prefix + S`        | New named session | Prompts for session name and creates it |
| `Prefix + Ctrl + a` | Last window       | Switches to previously active window    |

## 🪟 Window Management

| Keybinding    | Action          | Description                                  |
| ------------- | --------------- | -------------------------------------------- |
| `Alt + Right` | Next window     | Navigate to next window                      |
| `Alt + Left`  | Previous window | Navigate to previous window                  |
| `Prefix + W`  | Select window   | Prompts for window name in 'default' session |

## 🖼️ Pane Management

### ➕ Pane Creation

| Keybinding    | Action           | Description                                 |
| ------------- | ---------------- | ------------------------------------------- |
| `Prefix + \|` | Split horizontal | Creates vertical pane (splits horiz)        |
| `Prefix + \\` | Split horizontal | Alternative horizontal split                |
| `Prefix + -`  | Split vertical   | Creates horizontal pane (splits vertically) |

### 🧭 Pane Navigation (Vim-aware)

These bindings work seamlessly with vim splits through vim-tmux-navigator:

| Keybinding  | Action     | Description                             |
| ----------- | ---------- | --------------------------------------- |
| `Ctrl + h`  | Move left  | Select pane to the left (or vim split)  |
| `Ctrl + j`  | Move down  | Select pane below (or vim split)        |
| `Ctrl + k`  | Move up    | Select pane above (or vim split)        |
| `Ctrl + l`  | Move right | Select pane to the right (or vim split) |
| `Ctrl + \\` | Last pane  | Toggle to previously active pane        |

### ⬅️ Alternative Arrow Key Navigation

| Keybinding     | Action     | Description              |
| -------------- | ---------- | ------------------------ |
| `Ctrl + Left`  | Move left  | Select pane to the left  |
| `Ctrl + Down`  | Move down  | Select pane below        |
| `Ctrl + Up`    | Move up    | Select pane above        |
| `Ctrl + Right` | Move right | Select pane to the right |

### 📊 Pane Resizing

| Keybinding   | Action       | Description              |
| ------------ | ------------ | ------------------------ |
| `Prefix + <` | Resize left  | Decrease pane width by 1 |
| `Prefix + >` | Resize right | Increase pane width by 1 |

### 🔄 Pane Synchronization

| Keybinding                | Action   | Description                            |
| ------------------------- | -------- | -------------------------------------- |
| `Prefix + Ctrl + y`       | Sync ON  | Enable synchronized input to all panes |
| `Prefix + Ctrl + Alt + y` | Sync OFF | Disable synchronized input             |

When synchronized:

- Active border becomes red
- Regular borders become yellow
- Input is sent to all panes simultaneously

## 📋 Copy Mode (Vi-style)

| Keybinding   | Action          | Description                            |
| ------------ | --------------- | -------------------------------------- |
| `Prefix + [` | Enter copy mode | Start scrolling/copying (default tmux) |
| `v`          | Start selection | Begin visual selection (in copy mode)  |
| `y`          | Copy selection  | Copy selected text to buffer           |
| `Prefix + P` | Paste           | Paste from buffer                      |
| `Prefix + b` | List buffers    | Show all copy buffers                  |

## 🔭 Mouse Support

| Action           | Description                 |
| ---------------- | --------------------------- |
| **Click**        | Select pane                 |
| **Drag**         | Resize panes                |
| **Wheel Up**     | Scroll up / Enter copy mode |
| **Wheel Down**   | Scroll down                 |
| **Double Click** | Select word                 |
| **Triple Click** | Select line                 |

## 🔌 Plugin-Specific Keybindings

### 📦 Tmux Plugin Manager (TPM)

| Keybinding         | Action            |
| ------------------ | ----------------- |
| `Prefix + I`       | Install plugins   |
| `Prefix + U`       | Update plugins    |
| `Prefix + Alt + u` | Uninstall plugins |

### 🕹️ Tmux Pain Control

| Keybinding         | Action                    |
| ------------------ | ------------------------- |
| `Prefix + h/j/k/l` | Select pane               |
| `Prefix + H/J/K/L` | Resize pane (large steps) |
| `Prefix + </>`     | Resize pane (small steps) |

### 🔍 Tmux Copycat (Search)

| Keybinding          | Action            |
| ------------------- | ----------------- |
| `Prefix + /`        | Search            |
| `Prefix + Ctrl + f` | File search       |
| `Prefix + Ctrl + g` | Git status search |
| `Prefix + Alt + h`  | SHA-1 hash search |
| `Prefix + Ctrl + u` | URL search        |
| `Prefix + Ctrl + d` | Number search     |
| `Prefix + Alt + i`  | IP address search |

### 📋 Tmux Yank (Copy to system clipboard)

| Keybinding | Action                                     |
| ---------- | ------------------------------------------ |
| `y`        | Copy selection to clipboard (in copy mode) |
| `Y`        | Copy current line to clipboard             |

### 🔗 Tmux Open

| Keybinding | Action                               |
| ---------- | ------------------------------------ |
| `o`        | Open highlighted text (in copy mode) |
| `Ctrl + o` | Open highlighted text with $EDITOR   |

### 🔍 Tmux FZF

| Keybinding   | Action               |
| ------------ | -------------------- |
| `Prefix + F` | Launch tmux-fzf menu |

## ⚙️ Configuration Details

### 🔑 Key Settings

- **Mouse support**: Enabled
- **Vi mode**: Enabled for copy mode
- **Base index**: Windows and panes start at 1 (not 0)
- **Escape delay**: Removed (set to 0)
- **Repeat time**: 1000ms
- **Display time**: 500ms for messages

### 👁️ Visual Indicators

- **Status bar**: Positioned at top
- **Activity monitoring**: Enabled with visual alerts
- **Window renumbering**: Automatic
- **Pane borders**: Green for active, themed colors for sync mode

### 🎨 Theme

- **Catppuccin Frappe**: Consistent with overall dotfiles theme
- **Custom icons**: For window states (current, last, zoom, activity, etc.)
- **Kubernetes integration**: Shows current context and namespace
- **Date/time format**: `%Y-%m-%d %H:%M:%S`

## 💡 Tips and Tricks

1. **Vim Integration**: The navigation keys work seamlessly between tmux panes
   and vim splits
2. **Mouse Wheel**: Automatically enters copy mode when scrolling up
3. **Pane Synchronization**: Useful for running commands on multiple servers
   simultaneously
4. **Session Persistence**: tmux-resurrect and tmux-continuum automatically
   save and restore sessions
5. **FZF Integration**: Quick fuzzy finding for sessions, windows, and panes

## 📦 Plugin List

- **tmux-sensible**: Sensible defaults
- **catppuccin/tmux**: Theme
- **tmux-resurrect**: Session persistence
- **tmux-continuum**: Automatic session saving
- **tmux-copycat**: Enhanced searching
- **tmux-yank**: System clipboard integration
- **tmux-open**: Open highlighted text
- **tmux-pain-control**: Enhanced pane navigation
- **tmux-prefix-highlight**: Show prefix key state
- **tmux-better-mouse-mode**: Improved mouse support
- **kube-tmux**: Kubernetes context display
- **tmux-fzf**: Fuzzy finder integration
