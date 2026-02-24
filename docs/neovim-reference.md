# 🚀 Neovim (LazyVim) Reference Guide

A comprehensive guide to the Neovim configuration using LazyVim framework with
custom plugins and theming.

## 📖 Overview

This Neovim setup is built on [LazyVim](https://lazyvim.github.io/), a modern
Neovim configuration framework that provides sensible defaults, lazy loading,
and extensive plugin management. The configuration emphasizes productivity,
consistency with the dotfiles theme (Catppuccin), and seamless integration
with development workflows.

## ✨ Core Features

### 🏰 LazyVim Foundation

- **Lazy Loading**: Plugins load only when needed for optimal startup time
- **Modular Configuration**: Organized plugin structure with clear separation
- **Sensible Defaults**: Pre-configured keybindings and settings
- **Easy Customization**: Simple override system for personal preferences

### 🎨 Theme Integration

- **Catppuccin Theme**: Consistent with overall dotfiles theming
- **Automatic Theme Switching**: Matches system appearance (light/dark)
- **Light Mode**: Catppuccin Latte
- **Dark Mode**: Catppuccin Frappe

## ⌨️ Default LazyVim Keybindings

LazyVim provides extensive default keybindings. For the complete reference, see:
[LazyVim Keymaps Documentation](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)

### ✨ Essential Default Keybindings

#### 🗝️ Leader Key

- **Leader**: `<Space>` (spacebar)

#### 📁 File Operations

| Keybinding   | Action       | Description                 |
| ------------ | ------------ | --------------------------- |
| `<leader>ff` | Find files   | Telescope file finder       |
| `<leader>fr` | Recent files | Recently opened files       |
| `<leader>fg` | Live grep    | Search text in files        |
| `<leader>fb` | Find buffers | Switch between open buffers |
| `<leader>fn` | New file     | Create new file             |
| `<C-s>`      | Save file    | Save current file           |

#### 📋 Buffer Management

| Keybinding   | Action               | Description                      |
| ------------ | -------------------- | -------------------------------- |
| `<S-h>`      | Previous buffer      | Navigate to previous buffer      |
| `<S-l>`      | Next buffer          | Navigate to next buffer          |
| `<leader>bd` | Delete buffer        | Close current buffer             |
| `<leader>bo` | Delete other buffers | Close all buffers except current |
| `<leader>bb` | Switch buffer        | Switch to other buffer           |

#### 🎦 Window Management

| Keybinding   | Action           | Description               |
| ------------ | ---------------- | ------------------------- |
| `<C-h>`      | Move left        | Focus window to the left  |
| `<C-j>`      | Move down        | Focus window below        |
| `<C-k>`      | Move up          | Focus window above        |
| `<C-l>`      | Move right       | Focus window to the right |
| `<C-Up>`     | Increase height  | Resize window height      |
| `<C-Down>`   | Decrease height  | Resize window height      |
| `<C-Left>`   | Decrease width   | Resize window width       |
| `<C-Right>`  | Increase width   | Resize window width       |
| `<leader>-`  | Split horizontal | Create horizontal split   |
| `<leader>\|` | Split vertical   | Create vertical split     |

### 🧭 Code Navigation

| Keybinding | Action                | Description                   |
| ---------- | --------------------- | ----------------------------- |
| `gd`       | Go to definition      | Jump to symbol definition     |
| `gr`       | Go to references      | Find symbol references        |
| `gI`       | Go to implementation  | Jump to implementation        |
| `gy`       | Go to type definition | Jump to type definition       |
| `K`        | Hover                 | Show documentation/hover info |
| `gK`       | Signature help        | Show function signature       |

#### 🔍 LSP Operations

| Keybinding   | Action              | Description                 |
| ------------ | ------------------- | --------------------------- |
| `<leader>ca` | Code actions        | Show available code actions |
| `<leader>cr` | Rename              | Rename symbol               |
| `<leader>cf` | Format              | Format document             |
| `]d`         | Next diagnostic     | Jump to next diagnostic     |
| `[d`         | Previous diagnostic | Jump to previous diagnostic |
| `<leader>cd` | Line diagnostics    | Show line diagnostics       |
| `]e`         | Next error          | Jump to next error          |
| `[e`         | Previous error      | Jump to previous error      |

#### 🔍 Search and Replace

| Keybinding   | Action             | Description               |
| ------------ | ------------------ | ------------------------- |
| `<leader>sr` | Search and replace | Find and replace in files |
| `<leader>sg` | Grep               | Search text in project    |
| `<leader>sw` | Search word        | Search word under cursor  |

#### 🌳 Git Integration

| Keybinding   | Action        | Description            |
| ------------ | ------------- | ---------------------- |
| `<leader>gg` | Lazygit       | Open Lazygit interface |
| `<leader>gb` | Git blame     | Show git blame         |
| `<leader>gB` | Git browse    | Browse git repository  |
| `]h`         | Next hunk     | Next git change        |
| `[h`         | Previous hunk | Previous git change    |

#### 💻 Terminal

| Keybinding   | Action          | Description                   |
| ------------ | --------------- | ----------------------------- |
| `<leader>tt` | Terminal        | Open terminal                 |
| `<leader>tT` | Terminal (root) | Open terminal in project root |
| `<C-/>`      | Terminal        | Toggle floating terminal      |

## 🎆 Enabled LazyVim Extras

The configuration includes these LazyVim extras (from `lazyvim.json`):

### 🤖 AI Integration

- **`lazyvim.plugins.extras.ai.copilot`** - GitHub Copilot integration
- **`lazyvim.plugins.extras.ai.copilot-chat`** - Copilot chat interface

### ✨ Code Enhancement

- **`lazyvim.plugins.extras.coding.mini-surround`** - Surround text objects
- **`lazyvim.plugins.extras.editor.leap`** - Quick navigation with leap.nvim
- **`lazyvim.plugins.extras.editor.navic`** - Breadcrumb navigation

### 🌍 Language Support

- **`lazyvim.plugins.extras.lang.docker`** - Docker file support
- **`lazyvim.plugins.extras.lang.java`** - Java development
- **`lazyvim.plugins.extras.lang.json`** - JSON support
- **`lazyvim.plugins.extras.lang.markdown`** - Markdown editing
- **`lazyvim.plugins.extras.lang.python`** - Python development
- **`lazyvim.plugins.extras.lang.sql`** - SQL support
- **`lazyvim.plugins.extras.lang.toml`** - TOML configuration files
- **`lazyvim.plugins.extras.lang.yaml`** - YAML support

### 🔧 Formatting and Testing

- **`lazyvim.plugins.extras.formatting.black`** - Python Black formatter
- **`lazyvim.plugins.extras.test.core`** - Testing framework integration

### 🎨 UI Enhancements

- **`lazyvim.plugins.extras.ui.mini-indentscope`** - Indent scope visualization
- **`lazyvim.plugins.extras.vscode`** - VS Code integration

## ⚙️ Custom Configuration

### 📝 Custom Options (`lua/config/options.lua`)

The configuration includes minimal custom options:

- **`vim.g.autoformat = false`** - Disables automatic formatting on save
- **`vim.opt.swapfile = false`** - Disables swap file creation

### ⌨️ Custom Keymaps and Autocommands

- **`lua/config/keymaps.lua`** - Currently uses LazyVim defaults (no custom keybindings)
- **`lua/config/autocmds.lua`** - Currently uses LazyVim defaults (no custom autocommands)

## 🔌 Custom Plugins

### 🎨 Theme and Appearance

#### 🐱 Catppuccin Theme (`catppuccin.lua`)

```lua
-- Automatic theme switching based on system appearance
flavour = "auto"
background = {
  light = "latte",  -- Light mode theme
  dark = "frappe",  -- Dark mode theme
}
```

**Key Features**:

- Automatic light/dark mode switching
- Extensive plugin integrations (LSP, Telescope, Git, etc.)
- Consistent with dotfiles theme across all applications

#### 🌃 Auto Dark Mode (`auto-dark-mode.lua`)

- Monitors system appearance changes
- Automatically switches Neovim theme
- Seamless integration with macOS dark mode

#### 🎨 Custom Colorscheme (`colorscheme.lua`)

- Sets Catppuccin as default colorscheme
- Ensures theme persistence across sessions

#### 📋 Lualine Statusline (`lualine.lua`)

- Themed statusline with Catppuccin colors
- Shows current mode, file info, git status, diagnostics
- Consistent with overall aesthetic

### 🛠️ Development Tools

#### ⚡ Flash Navigation (`flash-nvim.lua`)

- Enhanced search and navigation
- Quick jump to any location in visible text
- Integrates with LazyVim's leap functionality

#### 👗 Dressing (`dressing.lua`)

- Enhanced UI for vim.ui.select and vim.ui.input
- Better-looking input dialogs and selection menus

#### 🧪 Testing (`neotest.lua`)

- Test runner integration
- Supports multiple testing frameworks
- Visual test results and debugging

### 🌍 Language-Specific

#### 🛠️ Gradle Support (`vim-gradle.lua`)

- Gradle build file syntax highlighting
- Integration with Java development workflow

#### 📜 Jsonnet Support (`vim-jsonnet.lua`)

- Jsonnet templating language support
- Syntax highlighting and basic tooling

## 📂 File Structure

```text
~/.config/nvim/
├── .gitignore                 # Git ignore patterns
├── .neoconf.json             # Neoconf configuration
├── init.lua                  # Main entry point
├── lazy-lock.json           # Plugin version lockfile
├── lazyvim.json            # LazyVim extras configuration
├── LICENSE                 # License file
├── README.md              # LazyVim starter template info
├── stylua.toml           # Lua code formatter configuration
└── lua/
    ├── config/
    │   ├── autocmds.lua  # Custom autocommands
    │   ├── keymaps.lua   # Custom keybindings
    │   ├── lazy.lua      # Lazy.nvim bootstrap
    │   └── options.lua   # Neovim options
    └── plugins/
        ├── auto-dark-mode.lua # Automatic theme switching
        ├── catppuccin.lua     # Theme configuration
        ├── colorscheme.lua    # Default colorscheme
        ├── dressing.lua       # UI improvements
        ├── flash-nvim.lua     # Navigation enhancement
        ├── lualine.lua        # Statusline configuration
        ├── neotest.lua        # Testing framework
        ├── vim-gradle.lua     # Gradle support
        └── vim-jsonnet.lua    # Jsonnet support
```

## ⚙️ Configuration Management

### 🔌 Plugin Management

- **Lazy.nvim**: Fast and modern plugin manager
- **Automatic Updates**: Plugins managed through lazy-lock.json
- **Lazy Loading**: Plugins load only when needed

### 🎨 Theme Management

- **Automatic Switching**: Follows system appearance
- **Consistent Theming**: Matches tmux, terminal, and other tools
- **Customizable**: Easy to override theme settings

### 🔍 Language Server Protocol (LSP)

- **Multiple Languages**: Java, Python, Docker, JSON, YAML, SQL, etc.
- **Auto-completion**: Intelligent code completion
- **Diagnostics**: Real-time error and warning detection
- **Formatting**: Automatic code formatting (Black for Python)

## 🔗 Integration with Dotfiles Ecosystem

### 💻 Terminal Integration

- **Seamless Navigation**: Works with tmux pane navigation (`Ctrl+h/j/k/l`)
- **Terminal Multiplexing**: Complements tmux workflow
- **Theme Consistency**: Matches terminal and tmux themes

### 🚀 Development Workflow

- **AeroSpace Integration**: Assigned to workspace V or I
- **Git Integration**: Works with dotfiles git workflow
- **Project Management**: Supports project-specific configurations

### 🐚 Shell Integration

- **Zsh Compatibility**: Works with zsh environment
- **Path Management**: Respects dotfiles PATH configuration
- **Environment Variables**: Uses dotfiles environment setup

## 💡 Tips and Best Practices

### 🚀 Productivity Workflows

1. **File Navigation**:
   - Use `<leader>ff` for quick file finding
   - `<leader>fr` for recently opened files
   - `<leader>fg` for project-wide text search

2. **Code Navigation**:
   - `gd` to jump to definitions
   - `gr` to find all references
   - `K` for documentation

3. **Multi-file Editing**:
   - Use buffers instead of tabs
   - `<S-h>` and `<S-l>` to switch between files
   - `<leader>bd` to close unwanted buffers

### ⚙️ Customization

1. **Adding Plugins**:
   - Create new `.lua` files in `lua/plugins/`
   - Follow LazyVim plugin specification format
   - Use lazy loading for better performance

2. **Custom Keybindings**:
   - Add to `lua/config/keymaps.lua`
   - Use LazyVim's keymap utilities
   - Avoid conflicts with default bindings

3. **Theme Customization**:
   - Modify `lua/plugins/catppuccin.lua`
   - Adjust integration settings for specific plugins
   - Override colors if needed

### 🚀 Performance Optimization

1. **Startup Time**:
   - LazyVim provides excellent lazy loading
   - Avoid loading plugins in `init.lua`
   - Use appropriate plugin events

2. **Memory Usage**:
   - Close unused buffers regularly
   - Use `:checkhealth` to diagnose issues
   - Monitor with `:Lazy profile`

## 🐛 Troubleshooting

### ⚠️ Common Issues

1. **Theme Not Switching**:
   - Check `auto-dark-mode.lua` configuration
   - Verify system appearance detection
   - Manually run `:colorscheme catppuccin`

2. **LSP Issues**:
   - Run `:checkhealth lsp` for diagnostics
   - Ensure language servers are installed
   - Check Mason installation status

3. **Plugin Conflicts**:
   - Use `:Lazy` to manage plugins
   - Check plugin loading order
   - Review error messages in `:messages`

### 🛠️ Maintenance

1. **Plugin Updates**:
   - Run `:Lazy update` regularly
   - Review breaking changes in plugin changelogs
   - Test configuration after updates

2. **Configuration Backup**:
   - All configs are version controlled in dotfiles
   - `lazy-lock.json` ensures reproducible setups
   - Test changes in separate branch

## 🔗 Integration Commands

### 🚀 LazyVim Commands

| Command       | Description                   |
| ------------- | ----------------------------- |
| `:Lazy`       | Open Lazy.nvim plugin manager |
| `:LazyExtras` | Manage LazyVim extras         |
| `:LazyHealth` | Check LazyVim health          |
| `:LazyLog`    | View plugin update logs       |

### ⚙️ Custom Commands

| Command      | Description                    |
| ------------ | ------------------------------ |
| `:Mason`     | Manage LSP servers and tools   |
| `:Telescope` | Access all Telescope functions |
| `:Copilot`   | GitHub Copilot commands        |

This configuration provides a powerful, modern Neovim setup that integrates
seamlessly with the broader dotfiles ecosystem while maintaining consistency in
theming and workflow patterns.
