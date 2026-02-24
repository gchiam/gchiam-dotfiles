# 💼 Workflow Guide

This guide covers common workflows and daily usage patterns for the
dotfiles environment, including development workflows, maintenance routines,
and optimization strategies.

## 🧭 Navigation

**📖 Documentation:** [← Back to Main README](../README.md) |
**🚀 Setup:** [← Installation Guide](setup-guide.md) |
**🤖 Automation:** [Advanced Automation →](automation-guide.md) |
**⚡ Performance:** [Performance Tuning →](performance-tuning.md)

**🔧 Tool References:** [Neovim](neovim-reference.md) |
[tmux](tmux-reference.md) | [Zsh](zsh-reference.md) |
[AeroSpace](aerospace-reference.md)

**🆘 Having Issues?** Check the [Troubleshooting Guide](troubleshooting.md)
for problem resolution

---

## 📅 Daily Development Workflow Overview

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

### 🌅 Morning Routine

```bash
# 1. Start terminal and verify environment health
./bin/health-check.sh basic

# 2. Check for updates and sync repositories
./bin/auto-sync.sh status
./bin/auto-sync.sh sync --dry-run  # Preview changes first

# 3. Start tmux session for the day
tmux new-session -s work -d
tmux send-keys -t work:0 'cd ~/projects' Enter
tmux new-window -t work -n 'dotfiles' 'cd ~/.dotfiles'
tmux new-window -t work -n 'monitor' 'htop'

# 4. Performance check (optional, weekly)
if [[ $(date +%u) -eq 1 ]]; then  # Monday
    ./bin/measure-shell-performance.sh 5
fi
tmux attach -t work

# 4. Open primary editor (Neovim with LazyVim)
nvim +Dashboard
```

### 🚀 Development Session Setup

#### 🎩 Project Initialization

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

#### 🔀 Git Workflow Integration

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

### 🔍 Code Review and Collaboration

#### 📋 Using gh-dash for PR Management

```bash
# Launch gh-dash for PR overview
gh dash

# Key workflows in gh-dash:
# - View all PRs across repositories
# - Review PR details and diff
# - Comment and approve/request changes
# - Merge PRs when ready
```

#### 🔥 Delta Integration for Better Diffs

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

## 🪟 Window Management Workflow

### 🟩 AeroSpace Tiling Manager

#### 📊 Workspace Organization

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

#### ⌨️ Key Workflow Shortcuts

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

#### 🎨 Application Placement Strategy

```bash
# Automatic application workspace assignment
# Terminal applications → Workspace 3
# Browsers → Workspace 2
# Communication apps → Workspace 1
# Design tools → Workspace 5
# Monitoring tools → Workspace 0
```

## 💻 Terminal and Shell Workflow

### 🐚 Zsh Environment Features

#### 🤖 Intelligent Environment Detection

```bash
# The shell automatically detects and adapts to:
# - Work environment (Zendesk-specific configurations)
# - Remote SSH sessions (minimal mode)
# - Container environments (lightweight setup)
# - Personal vs. development contexts
```

#### 🧭 Enhanced Navigation and Search

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

#### ⚡ Alias and Function Workflow

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

## 📝 Editor Workflow (Neovim + LazyVim)

### 📆 Daily Editor Usage

#### 💾 Session Management

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

#### 📁 File Navigation and Management

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

#### 🚀 Development Features

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

### 🎨 Advanced Editor Workflows

#### 📝 Multi-file Editing

```bash
# Search and replace across files
<leader>sr               # Search and replace (Spectre)
:%s/old/new/gc          # Interactive replace in current file

# Multiple cursors and selection
Ctrl+n                   # Select next occurrence
Ctrl+p                   # Select previous occurrence
Ctrl+x                   # Skip current occurrence
```

## ⚡ Performance Optimization Workflow

### 📈 Regular Performance Monitoring

#### 📅 Weekly Performance Review

```bash
# Sunday evening routine
./bin/performance-monitor.sh history     # Review week's performance
./bin/performance-monitor.sh recommendations # Get optimization suggestions

# If startup time > 2 seconds, investigate
./bin/performance-monitor.sh profile    # Detailed startup analysis
./bin/performance-monitor.sh plugins    # Plugin performance analysis
```

#### 📆 Monthly Deep Analysis

```bash
# First Sunday of each month
./bin/performance-monitor.sh benchmark --runs 20  # Comprehensive benchmark
./bin/performance-monitor.sh system              # System resource analysis
./bin/performance-monitor.sh optimize            # Apply optimizations
```

### 🎨 Optimization Strategies

#### 🐚 Shell Performance

```bash
# Lazy loading configuration (already implemented)
# - NVM loads only when needed
# - asdf loads only when needed
# - Heavy plugins use lazy loading

# Monitor shell startup
time zsh -i -c exit      # Quick startup time check

# Profile with zprof (when enabled)
zsh -i -c 'zprof'       # Detailed startup profiling
```

#### 📱 Application Performance

```bash
# Neovim startup optimization
nvim --startuptime startup.log  # Profile Neovim startup
# Review startup.log for slow plugins

# tmux performance
tmux display-message -p '#{session_name}: #{window_name}' # Check session state
# Restart tmux server if sessions become sluggish: tmux kill-server
```

## 🔧 Maintenance Workflow

### 🤖 Daily Maintenance (Automated)

```bash
# These run automatically if automation is enabled:
# - Health monitoring every 5 minutes
# - Performance checks every hour
# - Auto-sync daily at 2 AM
# - Repository cleanup weekly
```

### 📅 Weekly Manual Review

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

### 📆 Monthly Deep Maintenance

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

### 📊 Quarterly System Review

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

## 🔧 Troubleshooting Workflow

### 🔍 Standard Troubleshooting Process

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

### 🆘 Emergency Recovery Workflow

#### ⚡ Quick Recovery

```bash
# If shell becomes unusable
export DOTFILES_MINIMAL=1               # Enable minimal mode
exec zsh                                 # Restart with minimal config

# If tmux becomes unresponsive
tmux kill-server                         # Nuclear option - kills all sessions
tmux new-session -s emergency            # Start fresh session
```

#### 🆘 Full Reset (Last Resort)

```bash
# Create backup first
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)

# Reset to clean state
cd ~/.dotfiles
git reset --hard HEAD                    # Reset repository
./bin/setup-interactive.sh --backup     # Reinstall with backup
```

## 🎨 Advanced Workflows

### 🤖 Custom Automation Development

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

### 🌍 Environment-Specific Workflows

#### 🏢 Work Environment

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

#### 🌐 Remote Development

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

## 🚀 Real-World Scenario Workflows

### 💼 **Scenario 1: New Project Setup**

Complete workflow for starting a new development project:

```bash
# 1. Create project structure
mkdir -p ~/projects/awesome-app
cd ~/projects/awesome-app

# 2. Initialize git repository with templates
git init
git config --local user.name "Your Name"
git config --local user.email "your.email@example.com"

# 3. Create project-specific tmux session
tmux new-session -s awesome-app -d -c ~/projects/awesome-app
tmux rename-window -t awesome-app:0 'main'
tmux new-window -t awesome-app -n 'editor' -c ~/projects/awesome-app
tmux new-window -t awesome-app -n 'server' -c ~/projects/awesome-app
tmux new-window -t awesome-app -n 'tests' -c ~/projects/awesome-app

# 4. Setup project workspace in AeroSpace
# Assign terminal to workspace 3, editor to workspace 4

# 5. Initialize project files
echo "# Awesome App" > README.md
echo "node_modules/" > .gitignore
echo ".env.local" >> .gitignore

# 6. First commit with dotfiles integration
git add .
git commit -m "🎉 initial: project setup with dotfiles integration"

# 7. Open in preferred editor
tmux send-keys -t awesome-app:editor 'nvim .' Enter
tmux attach -t awesome-app
```

### 🐛 **Scenario 2: Bug Investigation Workflow**

Systematic approach to investigating and fixing bugs:

```bash
# 1. Create investigation tmux session
tmux new-session -s bug-investigation -d
tmux rename-window -t bug-investigation:0 'logs'
tmux new-window -t bug-investigation -n 'editor'
tmux new-window -t bug-investigation -n 'tests'
tmux new-window -t bug-investigation -n 'research'

# 2. Set up log monitoring
tmux send-keys -t bug-investigation:logs 'tail -f application.log | grep -i error' Enter

# 3. Create bug fix branch
git checkout -b fix/issue-123-user-login-error

# 4. Document investigation in editor
tmux send-keys -t bug-investigation:editor 'nvim bug-investigation.md' Enter

# 5. Research similar issues
tmux send-keys -t bug-investigation:research 'gh issue list --label bug --state open' Enter

# 6. Run related tests continuously
tmux send-keys -t bug-investigation:tests 'npm run test -- --watch user-login' Enter

# 7. Use git tools for investigation
git log --oneline --grep="login" -10    # Find related changes
git blame src/auth/login.js             # Check recent modifications
git bisect start                         # Binary search for regression

# 8. Performance monitoring during fix
./bin/measure-shell-performance.sh 3 > bug-perf-before.log
# ... make changes ...
./bin/measure-shell-performance.sh 3 > bug-perf-after.log
```

### 🔄 **Scenario 3: Configuration Migration Workflow**

When upgrading or migrating configurations:

```bash
# 1. Backup current configuration
./bin/setup-profile.sh backup migration-$(date +%Y%m%d)

# 2. Test new configuration in isolated environment
export DOTFILES_TEST_MODE=1
zsh -l  # Test shell with new config

# 3. Performance comparison
echo "=== Before Migration ===" > migration-performance.log
./bin/measure-shell-performance.sh 10 >> migration-performance.log

# Apply migration changes...

echo "=== After Migration ===" >> migration-performance.log
./bin/measure-shell-performance.sh 10 >> migration-performance.log

# 4. Validate all components
./bin/health-check.sh all --verbose > migration-health-check.log

# 5. Test real-world workflows
tmux new-session -s migration-test -d
# Run through typical daily workflow
# Check editor startup, git operations, etc.

# 6. Rollback plan if issues found
if grep -q "FAILED" migration-health-check.log; then
    echo "Issues found, rolling back..."
    ./bin/setup-profile.sh restore migration-$(date +%Y%m%d)
fi
```

### 💻 **Scenario 4: Remote Development Setup**

Optimized workflow for remote development environments:

```bash
# 1. Detect remote environment (automatic)
if [[ -n "$SSH_CONNECTION" ]]; then
    echo "Remote environment detected, optimizing..."
    export ZSH_MINIMAL_MODE=true
fi

# 2. Sync essential configurations only
rsync -av ~/.dotfiles/stow/zsh/ remote-host:~/.dotfiles/stow/zsh/
rsync -av ~/.dotfiles/stow/nvim/ remote-host:~/.dotfiles/stow/nvim/
rsync -av ~/.dotfiles/stow/tmux/ remote-host:~/.dotfiles/stow/tmux/

# 3. Setup remote-optimized tmux session
ssh remote-host 'tmux new-session -s remote-dev -d'
ssh remote-host 'tmux send-keys -t remote-dev "cd /project && nvim ." Enter'

# 4. Port forwarding for development servers
ssh -L 3000:localhost:3000 -L 8080:localhost:8080 remote-host

# 5. Sync work back to local
rsync -av remote-host:/project/ ~/projects/remote-project/
```

### 🎯 **Scenario 5: Performance Optimization Session**

Dedicated session for improving system performance:

```bash
# 1. Create performance optimization workspace
tmux new-session -s perf-optimization -d
tmux rename-window -t perf-optimization:0 'monitoring'
tmux new-window -t perf-optimization -n 'analysis'
tmux new-window -t perf-optimization -n 'testing'

# 2. Setup continuous monitoring
tmux send-keys -t perf-optimization:monitoring 'htop' Enter
tmux split-window -t perf-optimization:monitoring
tmux send-keys -t perf-optimization:monitoring.1 'watch -n 2 "df -h && echo && free -h"' Enter

# 3. Baseline performance measurement
cd ~/.dotfiles
./bin/measure-shell-performance.sh 20 > perf-baseline.log
./bin/performance-monitor.sh benchmark > perf-benchmark-before.log

# 4. Systematic optimization testing
tmux send-keys -t perf-optimization:testing 'cd ~/.dotfiles && ./bin/performance-monitor.sh profile' Enter

# 5. A/B testing different configurations
test_config_performance() {
    local config_name="$1"
    echo "Testing configuration: $config_name"

    # Apply configuration
    cp "configs/$config_name.zsh" ~/.config/zsh/performance-test.zsh

    # Measure performance
    ./bin/measure-shell-performance.sh 10 | grep Average > "perf-$config_name.log"

    # Record system resources
    ps aux | awk '{mem += $6} END {print "Memory: " mem/1024 " MB"}' >> "perf-$config_name.log"
}

# Test different optimization levels
test_config_performance "minimal"
test_config_performance "standard"
test_config_performance "full"

# 6. Apply best-performing configuration
best_config=$(grep -l "$(sort -n perf-*.log | head -1)" perf-*.log | sed 's/perf-//;s/.log//')
echo "Best performing configuration: $best_config"
```

### 🔧 **Scenario 6: Dotfiles Contribution Workflow**

When contributing improvements back to the dotfiles repository:

```bash
# 1. Create feature branch
git checkout main
git pull origin main
git checkout -b feature/improve-shell-performance

# 2. Document the improvement
echo "# Performance Improvement: Lazy Loading" > docs/improvements/lazy-loading.md
echo "## Problem" >> docs/improvements/lazy-loading.md
echo "Shell startup time was slow due to eager loading of all completions." >> docs/improvements/lazy-loading.md

# 3. Implement and test changes
# Make your improvements to the configuration files

# Test the improvements
./bin/measure-shell-performance.sh 20 > improvement-results.log
./bin/health-check.sh all --verbose

# 4. Create comprehensive commit
git add .
git commit -m "⚡ perf(zsh): implement lazy loading for heavy completions

- Add lazy loading wrapper function for kubectl, docker, npm completions
- Reduce shell startup time by ~40% (from 0.8s to 0.5s average)
- Maintain full functionality while improving performance
- Add performance measurement tracking

Performance improvements:
- Shell startup: 0.8s → 0.5s (37% improvement)
- Memory usage: 45MB → 32MB (29% improvement)
- Plugin load time: 2.1s → 0.3s (86% improvement)

Tested on macOS 14.0 with 15 active plugins."

# 5. Push and create pull request
git push origin feature/improve-shell-performance
gh pr create --title "⚡ Implement lazy loading for shell performance optimization" \
  --body "$(cat docs/improvements/lazy-loading.md)"
```

This workflow guide provides comprehensive coverage of daily usage patterns,
real-world scenarios, and optimization strategies for the dotfiles environment,
enabling users to work efficiently and maintain their development environment
effectively across various contexts and challenges.
