# Workflow Guide

This guide covers common workflows and daily usage patterns for the
dotfiles environment, including development workflows, maintenance routines,
and optimization strategies.

## Navigation

**📖 Documentation:** [← Back to Main README](../README.md) |
**🚀 Setup:** [← Installation Guide](setup-guide.md) |
**🤖 Automation:** [Advanced Automation →](automation-guide.md)

**🔧 Tool References:** [Neovim](neovim-reference.md) |
[tmux](tmux-reference.md) | [Zsh](zsh-reference.md) |
[AeroSpace](aerospace-reference.md)

**🆘 Having Issues?** Check the [Troubleshooting Guide](troubleshooting.md)
for problem resolution

---

## Daily Development Workflow Overview

```text
🌅 Morning Routine          📊 Development Session       🌙 Evening Wrap-up
├── Health Check            ├── Project Setup            ├── Performance Review
├── Repository Sync         ├── tmux Session             ├── Automation Status  
├── tmux Session Start      ├── Multi-window Setup       ├── Backup Validation
└── Environment Verify      ├── Git Workflow             └── System Cleanup
                            └── Code Review Process
     ⬇️                           ⬇️                           ⬇️
🔧 Tool Integration         📝 Active Development        📋 Maintenance Tasks
├── Neovim + LazyVim        ├── LSP Features             ├── Weekly Health Check
├── AeroSpace Windows       ├── Git Integration          ├── Monthly Optimization
├── Shell Environment      ├── Performance Monitor      ├── Quarterly Review
└── Completion System      └── Real-time Feedback       └── System Updates
```

### Morning Routine

```bash
# 1. Start terminal and verify environment health
./bin/health-check.sh basic

# 2. Check for updates and sync repositories
./bin/auto-sync.sh status
./bin/auto-sync.sh sync --dry-run  # Preview changes first

# 3. Start tmux session for the day
tmux new-session -s work -d
tmux attach -t work

# 4. Open primary editor (Neovim with LazyVim)
nvim +Dashboard
```

### Development Session Setup

#### Project Initialization

```bash
# Navigate to project directory
cd ~/projects/project-name

# Create or attach to project-specific tmux session
tmux new-session -s project-name -c ~/projects/project-name

# Setup tmux windows for different tasks
tmux new-window -n editor -c ~/projects/project-name
tmux new-window -n server -c ~/projects/project-name  
tmux new-window -n logs -c ~/projects/project-name
tmux new-window -n git -c ~/projects/project-name

# Open editor in first window
tmux send-keys -t project-name:editor 'nvim .' Enter

# Start development server in second window
tmux send-keys -t project-name:server 'npm run dev' Enter

# Monitor logs in third window
tmux send-keys -t project-name:logs 'tail -f logs/development.log' Enter
```

#### Git Workflow Integration

```bash
# Enhanced git workflow with configured aliases
git st                    # Status with enhanced formatting
git co feature-branch     # Checkout or create branch
git add .                 # Stage changes
git cm "feat: new feature" # Commit with conventional format

# Review changes before pushing
git show --stat           # Show commit statistics
git lg                    # Beautiful log view with graph

# Push with upstream tracking
git push -u origin feature-branch

# Create pull request (using gh CLI)
gh pr create --title "Feature: New functionality" --body "Description"
```

### Code Review and Collaboration

#### Using gh-dash for PR Management

```bash
# Launch gh-dash for PR overview
gh dash

# Key workflows in gh-dash:
# - View all PRs across repositories
# - Review PR details and diff
# - Comment and approve/request changes
# - Merge PRs when ready
```

#### Delta Integration for Better Diffs

```bash
# Git is configured to use delta for enhanced diffs
git diff                  # Side-by-side diff with syntax highlighting
git show commit-hash      # Enhanced commit view
git log -p               # Patch view with better formatting

# Delta features automatically enabled:
# - Line numbers
# - Syntax highlighting  
# - Side-by-side view for wide terminals
# - Navigate mode for large diffs
```

## Window Management Workflow

### AeroSpace Tiling Manager

#### Workspace Organization

```bash
# Workspace layout (configured in AeroSpace):
# 1: Communication (Slack, Discord, Email)
# 2: Web browsing (Safari, Chrome)
# 3: Development (Terminal, Editor)
# 4: Documentation (Markdown, PDFs)
# 5: Design (Figma, Sketch)
# 6: Media (Music, Videos)
# 7-9: Project-specific workspaces
# 0: Monitoring (Activity Monitor, Logs)
```

#### Key Workflow Shortcuts

```bash
# Navigate between workspaces
Alt + 1-9, 0             # Switch to specific workspace
Alt + Shift + 1-9, 0     # Move window to specific workspace

# Window management
Alt + H/J/K/L            # Move focus between windows
Alt + Shift + H/J/K/L    # Move windows around
Alt + R                  # Resize mode
Alt + F                  # Toggle fullscreen

# Layout management
Alt + A                  # Accordion layout
Alt + T                  # Tabs layout
Alt + S                  # Tiles layout
```

#### Application Placement Strategy

```bash
# Automatic application workspace assignment
# Terminal applications → Workspace 3
# Browsers → Workspace 2  
# Communication apps → Workspace 1
# Design tools → Workspace 5
# Monitoring tools → Workspace 0
```

## Terminal and Shell Workflow

### Zsh Environment Features

#### Intelligent Environment Detection

```bash
# The shell automatically detects and adapts to:
# - Work environment (Zendesk-specific configurations)
# - Remote SSH sessions (minimal mode)
# - Container environments (lightweight setup)
# - Personal vs. development contexts
```

#### Enhanced Navigation and Search

```bash
# Directory navigation
z project-name           # Jump to frequently used directories (zoxide)
fzf-cd                   # Interactive directory selection
..                       # Parent directory (with intelligent multi-level)

# Command history
fzf-history              # Interactive command history search
Ctrl+R                   # Reverse history search with fzf
!!                       # Repeat last command
!git                     # Repeat last git command

# File operations
fzf-file                 # Interactive file selection
fd pattern               # Fast file finding
rg pattern               # Fast text search across files
```

#### Alias and Function Workflow

```bash
# Development shortcuts
dev                      # cd to development directory
work                     # cd to work projects directory
dots                     # cd to dotfiles directory

# Git shortcuts (beyond standard aliases)
gst                      # git status
gco                      # git checkout
gcb                      # git checkout -b (new branch)
gph                      # git push origin HEAD

# System management
brewup                   # Update all Homebrew packages
dotup                    # Update dotfiles and run health check
cleanup                  # System cleanup routine

# Docker shortcuts
dps                      # docker ps with better formatting
dex                      # docker exec -it
dlogs                    # docker logs -f
```

## Editor Workflow (Neovim + LazyVim)

### Daily Editor Usage

#### Session Management

```bash
# Start Neovim with session support
nvim                     # Opens dashboard with recent files
nvim .                   # Open current directory
nvim filename            # Open specific file

# Session commands within Neovim
:SessionSave project     # Save current session
:SessionLoad project     # Load saved session
:SessionDelete project   # Delete saved session
```

#### File Navigation and Management

```bash
# Key bindings for file operations
<leader>ff               # Find files (Telescope)
<leader>fg               # Live grep (search in files)
<leader>fb               # Browse buffers
<leader>fh               # Help tags

# Neo-tree file explorer
<leader>e                # Toggle file explorer
<leader>E                # Focus file explorer

# Buffer management
<S-h>                    # Previous buffer
<S-l>                    # Next buffer
<leader>bd               # Delete buffer
<leader>bD               # Delete buffer (force)
```

#### Development Features

```bash
# LSP features (Language Server Protocol)
gd                       # Go to definition
gr                       # Go to references
K                        # Hover documentation
<leader>ca               # Code actions
<leader>rn               # Rename symbol

# Git integration (gitsigns)
<leader>gd               # Git diff
<leader>gb               # Git blame
<leader>gs               # Git status
]c / [c                  # Next/previous git hunk

# Debugging
<F5>                     # Start debugging
<F10>                    # Step over
<F11>                    # Step into
<F12>                    # Step out
```

### Advanced Editor Workflows

#### Multi-file Editing

```bash
# Search and replace across files
<leader>sr               # Search and replace (Spectre)
:%s/old/new/gc          # Interactive replace in current file

# Multiple cursors and selection
Ctrl+n                   # Select next occurrence
Ctrl+p                   # Select previous occurrence
Ctrl+x                   # Skip current occurrence
```

## Performance Optimization Workflow

### Regular Performance Monitoring

#### Weekly Performance Review

```bash
# Sunday evening routine
./bin/performance-monitor.sh history     # Review week's performance
./bin/performance-monitor.sh recommendations # Get optimization suggestions

# If startup time > 2 seconds, investigate
./bin/performance-monitor.sh profile    # Detailed startup analysis
./bin/performance-monitor.sh plugins    # Plugin performance analysis
```

#### Monthly Deep Analysis

```bash
# First Sunday of each month
./bin/performance-monitor.sh benchmark --runs 20  # Comprehensive benchmark
./bin/performance-monitor.sh system              # System resource analysis
./bin/performance-monitor.sh optimize            # Apply optimizations
```

### Optimization Strategies

#### Shell Performance

```bash
# Lazy loading configuration (already implemented)
# - NVM loads only when needed
# - SDKMAN loads only when needed
# - Heavy plugins use lazy loading

# Monitor shell startup
time zsh -i -c exit      # Quick startup time check

# Profile with zprof (when enabled)
zsh -i -c 'zprof'       # Detailed startup profiling
```

#### Application Performance

```bash
# Neovim startup optimization
nvim --startuptime startup.log  # Profile Neovim startup
# Review startup.log for slow plugins

# tmux performance
tmux display-message -p '#{session_name}: #{window_name}' # Check session state
# Restart tmux server if sessions become sluggish: tmux kill-server
```

## Maintenance Workflow

### Daily Maintenance (Automated)

```bash
# These run automatically if automation is enabled:
# - Health monitoring every 5 minutes
# - Performance checks every hour  
# - Auto-sync daily at 2 AM
# - Repository cleanup weekly
```

### Weekly Manual Review

```bash
# Every Sunday morning routine
./bin/health-check.sh all                 # Comprehensive health check
./bin/auto-sync.sh report                 # Review sync operations
./bin/performance-monitor.sh history      # Review performance trends

# Package management
brew update && brew upgrade               # Update packages
brew bundle dump --describe --force      # Update Brewfile
./bin/optimize-repo.sh --analyze         # Check repository health
```

### Monthly Deep Maintenance

```bash
# First Sunday of each month
./bin/check-compatibility.sh --report    # Compatibility assessment
./bin/optimize-repo.sh --all             # Full repository optimization
./bin/performance-monitor.sh benchmark   # Performance baseline

# Clean up old data
brew cleanup                              # Remove old package versions
tmux kill-server                         # Restart tmux (clears old sessions)
rm -rf ~/.cache/nvim                     # Clear Neovim cache
```

### Quarterly System Review

```bash
# Every three months - comprehensive review
# 1. Backup current configuration
./bin/setup-profile.sh backup

# 2. Review and update profiles
./bin/setup-profile.sh list
./bin/setup-profile.sh status

# 3. Update external dependencies
git submodule update --remote --merge

# 4. Review and update documentation
# Check docs/ directory for outdated information

# 5. Performance benchmarking
./bin/performance-monitor.sh benchmark --runs 50
```

## Troubleshooting Workflow

### Standard Troubleshooting Process

1. **Identify the Issue**

   ```bash
   ./bin/health-check.sh all --verbose
   ```

2. **Check Recent Changes**

   ```bash
   git log --oneline -10                 # Recent commits
   ./bin/auto-sync.sh report             # Recent sync operations
   ```

3. **Review Logs**

   ```bash
   tail -f ~/.local/log/dotfiles/*.log   # Monitor live logs
   grep -i error ~/.local/log/dotfiles/* # Find error messages
   ```

4. **Test Components Individually**

   ```bash
   zsh -n ~/.zshrc                       # Test zsh config
   tmux -f ~/.tmux.conf new-session -d -s test # Test tmux config
   nvim --headless -c 'checkhealth' -c 'qa'    # Test Neovim config
   ```

5. **Apply Fixes**

   ```bash
   ./bin/health-check.sh component --fix # Automated fixes
   # Or manual fixes based on error messages
   ```

6. **Verify Resolution**

   ```bash
   ./bin/health-check.sh all             # Confirm fix
   ```

### Emergency Recovery Workflow

#### Quick Recovery

```bash
# If shell becomes unusable
export DOTFILES_MINIMAL=1               # Enable minimal mode
exec zsh                                 # Restart with minimal config

# If tmux becomes unresponsive
tmux kill-server                         # Nuclear option - kills all sessions
tmux new-session -s emergency            # Start fresh session
```

#### Full Reset (Last Resort)

```bash
# Create backup first
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)

# Reset to clean state
cd ~/.dotfiles
git reset --hard HEAD                    # Reset repository
./bin/setup-interactive.sh --backup     # Reinstall with backup
```

## Advanced Workflows

### Custom Automation Development

```bash
# Create custom automation script
mkdir -p ~/.dotfiles/bin/custom
cat > ~/.dotfiles/bin/custom/my-automation.sh << 'EOF'
#!/opt/homebrew/bin/bash
set -euo pipefail

# Your custom automation logic
echo "Running custom automation..."
EOF

chmod +x ~/.dotfiles/bin/custom/my-automation.sh

# Integrate with existing automation
# Add to health-monitor.sh or create LaunchAgent
```

### Environment-Specific Workflows

#### Work Environment

```bash
# Work-specific setup (detected automatically)
if [[ -n "$ZENDESK_ENV" ]]; then
    # Work-specific tmux session
    tmux new-session -s zendesk -d
    
    # Work-specific Neovim setup
    nvim --cmd "let g:work_mode = 1"
    
    # Work-specific git configuration
    git config user.email "work.email@company.com"
fi
```

#### Remote Development

```bash
# Remote development workflow
if [[ -n "$SSH_CONNECTION" ]]; then
    # Minimal configuration automatically enabled
    # Use tmux for persistent sessions
    tmux new-session -s remote -d
    
    # Use efficient editor settings
    export EDITOR="nvim --clean"
fi
```

This workflow guide provides comprehensive coverage of daily usage patterns
and optimization strategies for the dotfiles environment, enabling users to
work efficiently and maintain their development environment effectively.
