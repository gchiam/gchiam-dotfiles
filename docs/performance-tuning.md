# ⚡ Performance Tuning Guide

This guide provides comprehensive strategies for optimizing the performance of
your dotfiles environment, from shell startup times to system responsiveness.

## 🧭 Navigation

**📖 Documentation:** [← Back to Main README](../README.md) |
**📋 Workflows:** [← Daily Workflows](workflow-guide.md) |
**🤖 Automation:** [← Automation Guide](automation-guide.md)

**🔧 Tool References:** [Zsh Reference](zsh-reference.md) |
[Neovim Reference](neovim-reference.md) | [Tmux Reference](tmux-reference.md)

**🆘 Having Issues?** Check the [Troubleshooting Guide](troubleshooting.md)
for performance problems

---

## 🎯 Performance Optimization Overview

```text
🚀 Performance Layers                   📊 Optimization Targets
├── 🐚 Shell Performance               ├── ⏱️ Startup Time < 0.3s
│   ├── Lazy loading                   ├── 🧠 Memory Usage < 50MB
│   ├── Minimal mode                   ├── 💾 Disk I/O Minimal
│   └── Plugin optimization            └── 🌐 Network Calls Deferred
├── 🖥️ Terminal Performance            
│   ├── Rendering optimization         📈 Measurement Tools
│   ├── Font performance               ├── measure-shell-performance.sh
│   └── Color optimization             ├── performance-monitor.sh
├── 💻 Application Performance         ├── System profiling tools
│   ├── Neovim startup                 └── Built-in benchmarks
│   ├── tmux responsiveness            
│   └── Git operations                 🎛️ Tuning Strategies
└── 🔧 System Performance              ├── 📦 Component Analysis
    ├── Resource utilization           ├── 🔄 Incremental Optimization
    ├── Background processes           ├── 📊 Performance Monitoring
    └── Storage optimization           └── 🎯 Targeted Improvements
```

## 🐚 Shell Performance Optimization

### 🚀 **Shell Startup Time Analysis**

Use the built-in performance measurement tool:

```bash
# Basic performance measurement (10 iterations)
./bin/measure-shell-performance.sh

# Detailed analysis (30 iterations for better accuracy)
./bin/measure-shell-performance.sh 30

# Compare different shells
./bin/measure-shell-performance.sh 10 zsh
./bin/measure-shell-performance.sh 10 bash

# Profile with timing details
zsh -xvs <<< 'exit' 2>&1 | head -20
```

### 🎛️ **Performance Modes**

The dotfiles system includes automatic performance optimization:

```bash
# Check current performance mode
echo "Minimal mode: $ZSH_MINIMAL_MODE"
echo "Environment: Work=$ZSH_ENV_WORK, Remote=$ZSH_ENV_REMOTE"

# Force minimal mode for testing
ZSH_MINIMAL_MODE=true zsh -l

# Profile difference between modes
echo "=== Full Mode ===" 
time (ZSH_MINIMAL_MODE=false zsh -c 'exit')
echo "=== Minimal Mode ==="
time (ZSH_MINIMAL_MODE=true zsh -c 'exit')
```

### 🔧 **Lazy Loading Configuration**

The dotfiles include a `_lazy_load_tool` utility function for lazy loading expensive
operations. This function is available but not currently in active use, as
performance testing showed that directly initializing lightweight configurations
(git, ssh) is faster than the lazy loading overhead.

The function is preserved in `stow/zsh/.config/zsh/utils.zsh` for future use cases
where lazy loading provides measurable benefits, such as:

- Heavy completion systems (kubectl, AWS CLI, etc.)
- Language version managers (nvm, rbenv, pyenv)
- Large environment setups

```bash
# Check if any tools are currently lazy-loaded
grep -r "_lazy_load_tool" ~/.config/zsh/

# Example usage (for future implementation):
# _lazy_load_tool kubectl setup_kubectl_completion
```

### 📊 **Performance Monitoring Dashboard**

Create a real-time performance dashboard:

```bash
#!/bin/bash
# ~/.local/bin/perf-dashboard.sh

while true; do
    clear
    echo "🚀 Dotfiles Performance Dashboard - $(date)"
    echo "=================================="
    
    # Shell startup time
    startup_time=$(./bin/measure-shell-performance.sh 3 | grep Average | awk '{print $2}')
    echo "Shell Startup: $startup_time"
    
    # Memory usage
    memory_usage=$(ps -o pid,ppid,pgid,pcpu,pmem,comm -p $$ | tail -1)
    echo "Shell Memory: $memory_usage"
    
    # Disk usage
    dotfiles_size=$(du -sh ~/.dotfiles | awk '{print $1}')
    cache_size=$(du -sh ~/.cache 2>/dev/null | awk '{print $1}' || echo "N/A")
    echo "Dotfiles Size: $dotfiles_size | Cache: $cache_size"
    
    # Plugin count and status
    plugin_count=$(grep -c "^[^#]" ~/.config/antidote/.zsh_plugins.txt)
    echo "Active Plugins: $plugin_count"
    
    # Performance score
    if [[ $(echo "$startup_time < 0.2" | bc -l 2>/dev/null) == 1 ]]; then
        echo "Performance: 🟢 Excellent"
    elif [[ $(echo "$startup_time < 0.4" | bc -l 2>/dev/null) == 1 ]]; then
        echo "Performance: 🟡 Good"
    else
        echo "Performance: 🔴 Needs optimization"
    fi
    
    sleep 5
done
```

## 💻 Application Performance Tuning

### 🎨 **Neovim Performance Optimization**

```bash
# Measure Neovim startup time
nvim --startuptime nvim-startup.log +q
tail -5 nvim-startup.log

# Profile LazyVim plugin loading
nvim --cmd "profile start profile.log" --cmd "profile func *" --cmd "profile file *" -c "profdel func *" -c "profdel file *" -c "qa!"

# Optimize specific components
# ~/.config/nvim/lua/config/performance.lua
-- Disable heavy plugins in specific environments
if os.getenv("SSH_CONNECTION") then
  -- Disable resource-intensive plugins for remote editing
  vim.g.disable_copilot = true
  vim.g.disable_treesitter_highlight = true
end
```

### 🖥️ **Terminal Performance Optimization**

```bash
# Test terminal rendering performance
# ~/.local/bin/terminal-benchmark.sh

test_terminal_performance() {
    echo "Testing terminal rendering performance..."
    
    # Color performance test
    time for i in {1..1000}; do
        echo -e "\033[38;5;${i}m■\033[0m"
    done >/dev/null
    
    # Unicode performance test  
    time for i in {1..1000}; do
        echo "🚀 ⚡ 📊 🎯 🔧"
    done >/dev/null
    
    # Large output test
    time seq 1 10000 | cat >/dev/null
}

# Optimize Alacritty/WezTerm/Kitty configurations
optimize_terminal_config() {
    # Alacritty optimizations
    cat >> ~/.config/alacritty/alacritty.toml << 'EOF'
[env]
TERM = "alacritty"

[window]  
decorations = "buttonless"  # Reduce overhead
dynamic_title = false       # Disable dynamic titles
    
[scrolling]
history = 5000              # Reduce memory usage

[cursor]
unfocused_hollow = false    # Reduce rendering complexity
EOF
}
```

### 🔧 **Git Performance Optimization**

```bash
# Git performance configuration
git config --global core.preloadindex true
git config --global core.fscache true  
git config --global gc.auto 256

# Enable Git commit graph for faster operations
git config --global feature.manyFiles true
git config --global index.version 4

# Optimize for large repositories
optimize_git_performance() {
    # Enable partial clone for large repos
    git config --global clone.filterSubDir true
    
    # Use faster algorithms
    git config --global diff.algorithm histogram
    git config --global merge.conflictstyle diff3
    
    # Optimize status operations
    git config --global status.showUntrackedFiles normal
    git config --global status.submoduleSummary false
}
```

## 📊 Performance Monitoring and Analysis

### 📈 **Continuous Performance Tracking**

Set up automated performance monitoring:

```bash
#!/bin/bash
# ~/.local/bin/performance-tracker.sh

# Create performance log directory
mkdir -p ~/.local/share/performance-logs

# Daily performance snapshot
daily_performance_check() {
    local date=$(date +%Y-%m-%d)
    local logfile="$HOME/.local/share/performance-logs/perf-$date.log"
    
    {
        echo "=== Performance Report: $date ==="
        echo "Shell startup: $(./bin/measure-shell-performance.sh 5 | grep Average)"
        echo "System load: $(uptime)"
        echo "Memory usage: $(free -h 2>/dev/null || echo 'N/A (macOS)')"
        echo "Disk usage: $(df -h ~ | tail -1)"
        echo "Active processes: $(ps aux | wc -l)"
        echo "Network connectivity: $(ping -c 1 8.8.8.8 >/dev/null && echo 'OK' || echo 'Failed')"
        echo "Git repo status: $(cd ~/.dotfiles && git status --porcelain | wc -l) uncommitted files"
        echo "=================================="
    } >> "$logfile"
}

# Performance trend analysis
analyze_performance_trends() {
    echo "📊 Performance Trend Analysis (Last 7 days)"
    echo "============================================="
    
    for i in {0..6}; do
        local date=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d)
        local logfile="$HOME/.local/share/performance-logs/perf-$date.log"
        
        if [[ -f "$logfile" ]]; then
            local startup_time=$(grep "Shell startup" "$logfile" | awk '{print $3}' | tr -d 's')
            echo "$date: ${startup_time}s"
        fi
    done
}

# Performance alerts
check_performance_alerts() {
    local current_startup=$(./bin/measure-shell-performance.sh 3 | grep Average | awk '{print $2}' | tr -d 's')
    
    if (( $(echo "$current_startup > 0.5" | bc -l) )); then
        osascript -e "display notification 'Shell startup time: ${current_startup}s' with title 'Performance Alert'"
        echo "⚠️ Performance degradation detected: ${current_startup}s startup time" >> ~/.system_alerts
    fi
}

# Run checks
daily_performance_check
check_performance_alerts
```

### 🎯 **Performance Optimization Recipes**

#### 🚀 **Recipe 1: Ultra-Fast Shell Startup**

Target: < 0.1s startup time

```bash
# 1. Enable aggressive lazy loading
cat >> ~/.zshrc.local << 'EOF'
# Ultra-performance mode
export ZSH_ULTRA_FAST=true

# Defer all non-essential loading
zsh-defer() {
    local cmd="$*"
    {
        # Run in background
        eval "$cmd" &
    } 2>/dev/null
}

# Lazy load heavy plugins
zsh-defer source ~/.config/zsh/completion.zsh
zsh-defer source ~/.config/zsh/aliases.zsh
EOF

# 2. Optimize plugin loading
optimize_antidote_plugins() {
    # Create minimal plugin set
    cat > ~/.config/antidote/.zsh_plugins_minimal.txt << 'EOF'
# Ultra-minimal plugin set
mattmc3/ez-compinit
zsh-users/zsh-autosuggestions
zdharma-continuum/fast-syntax-highlighting kind:defer
EOF
    
    # Use minimal set in ultra-fast mode
    if [[ "$ZSH_ULTRA_FAST" == "true" ]]; then
        antidote load ~/.config/antidote/.zsh_plugins_minimal.txt
    fi
}
```

#### 🧠 **Recipe 2: Memory Usage Optimization**

Target: < 30MB memory usage

```bash
# Memory optimization configuration
optimize_memory_usage() {
    # Reduce history size
    export HISTSIZE=1000
    export SAVEHIST=1000
    
    # Disable expensive features
    unsetopt share_history
    unsetopt inc_append_history
    
    # Optimize completion caching
    zstyle ':completion:*' use-cache false  # Disable cache if memory constrained
    
    # Reduce plugin memory footprint
    export ZSH_DISABLE_COMPFIX=true
}
```

#### 💾 **Recipe 3: Disk I/O Optimization**

Target: Minimal disk operations during startup

```bash
# Disk I/O optimization
optimize_disk_io() {
    # Move cache to RAM disk (macOS)
    if [[ "$OSTYPE" == darwin* ]]; then
        # Create RAM disk for caches
        sudo diskutil erasevolume HFS+ "ZshCache" `hdiutil attach -nomount ram://8192`
        export ZSH_CACHE_DIR="/Volumes/ZshCache"
    fi
    
    # Optimize file operations
    export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
    
    # Batch file operations
    defer_file_operations() {
        # Collect all file operations and run in background
        {
            compinit -d "$ZSH_COMPDUMP"
            # Other file-heavy operations
        } &
    }
}
```

## 🔍 Performance Troubleshooting

### 🐛 **Common Performance Issues**

#### Issue 1: Slow Shell Startup

```bash
# Diagnosis
zsh -xvs 2>&1 | grep -E "source|completion" | head -10

# Solutions
# 1. Identify slow components
# 2. Enable lazy loading  
# 3. Use minimal mode
# 4. Optimize plugin order
```

#### Issue 2: High Memory Usage

```bash
# Diagnosis  
ps -o pid,ppid,pgid,pcpu,pmem,comm -p $$

# Solutions
# 1. Reduce HISTSIZE
# 2. Disable cache
# 3. Remove memory-heavy plugins
# 4. Use minimal configurations
```

#### Issue 3: Slow Git Operations

```bash
# Diagnosis
time git status
git config --get-regexp core

# Solutions  
# 1. Enable Git optimizations
# 2. Use sparse checkout
# 3. Optimize repository structure
```

### 📊 **Performance Benchmarking**

Create standardized benchmarks:

```bash
#!/bin/bash
# ~/.local/bin/benchmark-suite.sh

run_comprehensive_benchmark() {
    echo "🚀 Comprehensive Performance Benchmark"
    echo "======================================"
    
    # Shell startup benchmark
    echo "1. Shell Startup Performance:"
    ./bin/measure-shell-performance.sh 10
    
    # Plugin loading benchmark
    echo "2. Plugin Loading Performance:"
    time (source ~/.config/zsh/aliases.zsh)
    time (source ~/.config/zsh/completion.zsh)
    time (source ~/.config/zsh/functions.zsh)
    
    # Git operations benchmark
    echo "3. Git Operations Performance:"
    cd ~/.dotfiles
    time git status >/dev/null
    time git log --oneline -10 >/dev/null
    time git diff --name-only >/dev/null
    
    # System integration benchmark
    echo "4. System Integration Performance:"
    time (which git >/dev/null)
    time (brew --version >/dev/null)
    time (nvim --version >/dev/null)
    
    echo "Benchmark completed: $(date)"
}

run_comprehensive_benchmark
```

---

## 🎯 Performance Optimization Checklist

### ✅ **Shell Performance**

- [ ] Startup time < 0.3s
- [ ] Lazy loading enabled for heavy tools
- [ ] Minimal mode configured for remote environments  
- [ ] Plugin count optimized (< 15 active plugins)
- [ ] Completion caching enabled

### ✅ **Application Performance**

- [ ] Neovim startup time < 0.5s
- [ ] Terminal rendering optimized
- [ ] Git operations < 1s for status/diff
- [ ] tmux session startup < 2s

### ✅ **System Performance**

- [ ] Memory usage < 50MB for shell
- [ ] Disk I/O minimized during startup
- [ ] Background processes optimized
- [ ] Performance monitoring active

### ✅ **Monitoring & Maintenance**

- [ ] Daily performance tracking enabled
- [ ] Performance alerts configured
- [ ] Benchmark suite scheduled
- [ ] Optimization documentation updated

---

## 🚀 Next Steps

1. **Measure current performance**: Run `./bin/measure-shell-performance.sh`
2. **Enable monitoring**: Set up daily performance tracking
3. **Apply optimizations**: Start with shell performance recipes
4. **Monitor improvements**: Track changes over time
5. **Fine-tune**: Adjust based on your specific usage patterns

For specific performance issues, check the [Troubleshooting Guide](troubleshooting.md)
or run the health check: `./bin/health-check.sh performance`
