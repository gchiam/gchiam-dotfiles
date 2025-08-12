# Automation Guide

This guide covers the comprehensive automation features available in the dotfiles repository, including health monitoring, auto-sync, performance optimization, and maintenance scheduling.

## Navigation

**📖 Documentation:** [← Back to Main README](../README.md) | **📋 Workflows:** [← Daily Workflows](workflow-guide.md) | **⚙️ Development:** [Development Notes →](development-notes.md)

**🔧 References:** [Shell Completions](shell-completions.md) | [Git Aliases](git-aliases-reference.md)

**🆘 Having Issues?** Check the [Troubleshooting Guide](troubleshooting.md) for automation problems

---

## Automation System Architecture

```
🔄 Automation Layer                     📊 Monitoring & Feedback
├── 🏥 Health Monitoring               ├── 📈 Performance Metrics
│   ├── health-check.sh               │   ├── Shell startup times
│   ├── health-monitor.sh             │   ├── Resource usage
│   └── Continuous validation         │   └── Optimization suggestions
├── 🔄 Auto-Sync System               ├── 📋 Health Reports  
│   ├── auto-sync.sh                  │   ├── Component status
│   ├── Submodule updates             │   ├── Configuration validation
│   └── Configuration commits         │   └── Automated fixes
├── ⚡ Performance Optimization       └── 🚨 Alert System
│   ├── performance-monitor.sh        │   ├── System notifications
│   ├── Resource analysis             │   ├── Email/Slack alerts
│   └── Automated tuning              │   └── Log aggregation
└── 🔧 Repository Optimization
    ├── optimize-repo.sh
    ├── Git LFS management
    └── Storage cleanup

                    ⬇️ Integration Layer ⬇️

🖥️ System Integration                   ⏰ Scheduling & Triggers
├── 🍎 macOS LaunchAgents              ├── ⏰ Cron-like scheduling
├── 🐚 Shell environment hooks         ├── 📅 Daily/Weekly/Monthly
├── 🔗 Git hooks automation            ├── 🔄 Event-driven triggers
└── 🚀 Application lifecycle           └── 🎯 Conditional execution
```

## System Overview

The dotfiles repository includes several automation systems designed to:
- **🏥 Maintain system health and performance** through continuous monitoring
- **🔄 Keep configurations and dependencies up to date** with auto-sync
- **📊 Monitor and optimize resource usage** with performance analysis
- **📢 Provide continuous feedback** on system status and issues
- **🤖 Automate routine maintenance tasks** to reduce manual overhead

## Health Monitoring System

### Overview

The health monitoring system continuously checks the status of your development environment and provides automated fixes for common issues.

### Components

- **health-check.sh**: On-demand health validation
- **health-monitor.sh**: Continuous monitoring daemon
- **performance-monitor.sh**: Performance analysis and optimization

### Setup

#### Basic Health Monitoring

```bash
# Run one-time comprehensive health check
./bin/health-check.sh all

# Check specific components
./bin/health-check.sh basic           # Essential tools and paths
./bin/health-check.sh shell           # Zsh configuration and plugins
./bin/health-check.sh editor          # Neovim setup and plugins
./bin/health-check.sh terminal        # Terminal emulators and multiplexers
./bin/health-check.sh window-manager  # AeroSpace and window management
./bin/health-check.sh development     # Development tools and environments
```

#### Continuous Health Monitoring

```bash
# Start continuous monitoring daemon
./bin/health-monitor.sh start

# Setup automatic monitoring on system startup
./bin/health-monitor.sh setup-automation

# Check monitoring status
./bin/health-monitor.sh status

# View monitoring reports
./bin/health-monitor.sh report

# Access monitoring logs
./bin/health-monitor.sh logs monitor  # General monitoring logs
./bin/health-monitor.sh logs alerts   # Alert notifications
./bin/health-monitor.sh logs health   # Health check results
```

#### Health Check Configuration

```bash
# Enable automatic fixes for detected issues
export HEALTH_AUTO_FIX=1

# Set monitoring interval (default: 300 seconds)
export HEALTH_MONITOR_INTERVAL=600

# Enable alert notifications
export HEALTH_ENABLE_ALERTS=1

# Set alert threshold levels
export HEALTH_ALERT_LEVEL="warning"  # info, warning, error, critical
```

## Auto-Sync System

### Overview

The auto-sync system automatically maintains git submodules, updates external dependencies, and commits configuration changes.

### Features

- Automatic submodule updates
- External theme and plugin synchronization
- Configuration change detection and commit
- Remote repository synchronization
- Conflict resolution and backup creation

### Setup

#### Basic Auto-Sync

```bash
# Perform manual sync operation
./bin/auto-sync.sh sync

# Check current sync status
./bin/auto-sync.sh status

# Generate detailed sync report
./bin/auto-sync.sh report

# Check repository health
./bin/auto-sync.sh health
```

#### Automated Sync Setup

```bash
# Enable daily automatic sync
./bin/auto-sync.sh setup-automation

# Configure sync settings
./bin/auto-sync.sh setup-automation --interval 1  # Daily
./bin/auto-sync.sh setup-automation --interval 7  # Weekly

# Remove automatic sync
./bin/auto-sync.sh remove-automation
```

#### Advanced Sync Options

```bash
# Sync with specific options
./bin/auto-sync.sh sync --dry-run          # Preview changes
./bin/auto-sync.sh sync --force            # Force sync even if not due
./bin/auto-sync.sh sync --no-commit        # Don't auto-commit changes
./bin/auto-sync.sh sync --auto-push        # Push changes to remote

# Configure automatic behavior
export AUTO_SYNC_AUTO_COMMIT=1     # Automatically commit changes
export AUTO_SYNC_AUTO_PUSH=1       # Automatically push to remote
export AUTO_SYNC_CREATE_BACKUP=1   # Create backups before changes
```

## Performance Monitoring

### Overview

The performance monitoring system tracks system resource usage, shell startup times, and application performance to identify optimization opportunities.

### Features

- Shell startup time analysis
- System resource monitoring
- Configuration performance profiling
- Plugin and tool performance analysis
- Automated optimization recommendations
- Performance history tracking

### Usage

#### Performance Analysis

```bash
# Measure shell startup performance
./bin/performance-monitor.sh startup

# Profile shell startup with detailed breakdown
./bin/performance-monitor.sh profile

# Monitor system resource usage
./bin/performance-monitor.sh system

# Analyze configuration performance impact
./bin/performance-monitor.sh config

# Analyze individual plugin performance
./bin/performance-monitor.sh plugins
```

#### Optimization

```bash
# Generate optimization recommendations
./bin/performance-monitor.sh recommendations

# Apply automated optimizations
./bin/performance-monitor.sh optimize

# View performance measurement history
./bin/performance-monitor.sh history

# Run comprehensive performance benchmark
./bin/performance-monitor.sh benchmark --runs 10
```

#### Performance Configuration

```bash
# Set performance thresholds
export PERF_STARTUP_THRESHOLD=2.0    # Shell startup warning threshold (seconds)
export PERF_BENCHMARK_RUNS=5         # Default benchmark iterations
export PERF_MONITOR_INTERVAL=3600    # System monitoring interval (seconds)

# Enable performance optimizations
export PERF_LAZY_LOADING=1           # Enable lazy loading for heavy tools
export PERF_CACHE_COMPLETIONS=1      # Cache completion functions
export PERF_OPTIMIZE_PATH=1          # Optimize PATH variable
```

## Repository Optimization

### Overview

The repository optimization system maintains the git repository structure, manages large files, and optimizes storage usage.

### Features

- Repository size and structure analysis
- Git LFS setup and migration
- Binary file management
- Submodule optimization
- Repository cleanup and maintenance

### Usage

#### Analysis and Reporting

```bash
# Analyze repository size and structure
./bin/optimize-repo.sh --analyze

# Generate comprehensive report
./bin/optimize-repo.sh --analyze --report
```

#### Optimization Operations

```bash
# Set up Git LFS for binary files
./bin/optimize-repo.sh --lfs

# Migrate existing binary files to LFS
./bin/optimize-repo.sh --migrate-lfs

# Optimize submodule configuration
./bin/optimize-repo.sh --submodules

# Clean up repository
./bin/optimize-repo.sh --cleanup

# Run all optimizations
./bin/optimize-repo.sh --all
```

## Git Hooks Automation

### Overview

Automated git hooks provide continuous validation of configurations, code quality checks, and automated maintenance tasks.

### Features

- Pre-commit configuration validation
- Automatic linting and formatting
- Dependency checking
- Performance regression detection
- Documentation generation

### Setup

```bash
# Install all git hooks
./bin/setup-git-hooks.sh install

# Test installed hooks
./bin/setup-git-hooks.sh test

# Check hook installation status
./bin/setup-git-hooks.sh status

# Remove installed hooks
./bin/setup-git-hooks.sh remove
```

### Hook Configuration

Git hooks are configured to run:

- **pre-commit**: Configuration validation, linting, performance checks
- **pre-push**: Comprehensive testing, compatibility verification
- **post-merge**: Automatic dependency updates, cache clearing
- **post-checkout**: Environment setup, plugin installation

## Scheduling and Automation

### LaunchAgent Setup

For macOS, automation can be configured using LaunchAgents:

```bash
# Health monitoring LaunchAgent
~/Library/LaunchAgents/com.user.health-monitor.plist

# Auto-sync LaunchAgent  
~/Library/LaunchAgents/com.user.auto-sync.plist

# Performance monitoring LaunchAgent
~/Library/LaunchAgents/com.user.performance-monitor.plist
```

### Cron-like Scheduling

```bash
# Daily health check at 9 AM
0 9 * * * ~/.dotfiles/bin/health-check.sh all --quiet

# Weekly repository sync on Sundays at 10 PM
0 22 * * 0 ~/.dotfiles/bin/auto-sync.sh sync --auto-push

# Monthly performance optimization on the 1st at midnight
0 0 1 * * ~/.dotfiles/bin/performance-monitor.sh optimize
```

## Environment-Specific Automation

### Work Environment

```bash
# Work-specific health checks
if [[ -n "$ZENDESK_ENV" ]]; then
    # Additional work tool validation
    ./bin/health-check.sh --work-tools
    
    # Work-specific performance monitoring
    export PERF_WORK_MODE=1
fi
```

### Remote/Container Environments

```bash
# Minimal automation for resource-constrained environments
if [[ -n "$SSH_CONNECTION" || -n "$container" ]]; then
    # Disable heavy monitoring
    export HEALTH_MINIMAL_MODE=1
    export PERF_DISABLE_MONITORING=1
    
    # Basic health check only
    ./bin/health-check.sh basic --quiet
fi
```

## Monitoring and Alerts

### Log Management

```bash
# Centralized logging location
~/.local/log/dotfiles/

# Log files
├── health-monitor.log     # Health monitoring events
├── auto-sync.log         # Sync operations and results
├── performance.log       # Performance measurements
├── automation.log        # General automation events
└── alerts.log           # Alert notifications
```

### Alert Configuration

```bash
# Enable system notifications
export ALERT_SYSTEM_NOTIFICATIONS=1

# Email alerts (if configured)
export ALERT_EMAIL="user@example.com"

# Slack/Discord webhooks (if configured)
export ALERT_WEBHOOK_URL="https://hooks.slack.com/..."

# Alert severity levels
export ALERT_MIN_LEVEL="warning"  # info, warning, error, critical
```

### Dashboard and Reporting

```bash
# Generate automation status dashboard
./bin/automation-status.sh

# Export automation metrics
./bin/automation-metrics.sh --format json > metrics.json

# Generate weekly automation report
./bin/automation-report.sh --week
```

## Troubleshooting Automation

### Common Issues

1. **Permission denied errors**
   ```bash
   # Fix script permissions
   chmod +x bin/*.sh
   
   # Fix LaunchAgent permissions
   chmod 644 ~/Library/LaunchAgents/com.user.*.plist
   ```

2. **Automation not running**
   ```bash
   # Check LaunchAgent status
   launchctl list | grep com.user
   
   # Reload LaunchAgent
   launchctl unload ~/Library/LaunchAgents/com.user.health-monitor.plist
   launchctl load ~/Library/LaunchAgents/com.user.health-monitor.plist
   ```

3. **High resource usage**
   ```bash
   # Enable minimal mode
   export AUTOMATION_MINIMAL_MODE=1
   
   # Increase monitoring intervals
   export HEALTH_MONITOR_INTERVAL=1800  # 30 minutes
   export PERF_MONITOR_INTERVAL=7200    # 2 hours
   ```

### Debugging

```bash
# Enable debug logging
export DEBUG=1

# Run automation in foreground
./bin/health-monitor.sh start --foreground

# Check automation logs
tail -f ~/.local/log/dotfiles/automation.log

# Test individual components
./bin/health-check.sh basic --verbose --dry-run
```

## Best Practices

### Configuration

1. **Start with minimal automation** and gradually add more features
2. **Test automation in dry-run mode** before enabling
3. **Monitor resource usage** and adjust intervals accordingly
4. **Keep backups** of important configurations
5. **Review logs regularly** for issues and optimization opportunities

### Security

1. **Limit automation privileges** to necessary operations only
2. **Validate external inputs** in automation scripts
3. **Use secure storage** for sensitive automation credentials
4. **Regular security audits** of automation configurations
5. **Monitor for unauthorized changes** through automation logs

### Performance

1. **Use lazy loading** for expensive operations
2. **Cache results** where possible to avoid repeated work
3. **Run heavy operations** during low-usage times
4. **Optimize monitoring intervals** based on actual needs
5. **Profile automation scripts** regularly for performance regressions

## Advanced Automation

### Custom Automation Scripts

Create custom automation scripts following the established patterns:

```bash
#!/opt/homebrew/bin/bash
set -euo pipefail

# Source common automation functions
source ~/.dotfiles/bin/lib/automation-common.sh

# Your custom automation logic
main() {
    log_info "Starting custom automation task"
    
    # Your automation code here
    
    log_success "Custom automation completed"
}

# Run main function with error handling
main "$@"
```

### Integration with External Systems

```bash
# Slack/Discord notifications
send_notification() {
    local message="$1"
    local webhook_url="$ALERT_WEBHOOK_URL"
    
    if [[ -n "$webhook_url" ]]; then
        curl -X POST -H 'Content-type: application/json' \
             --data "{\"text\":\"$message\"}" \
             "$webhook_url"
    fi
}

# Email notifications
send_email() {
    local subject="$1"
    local body="$2"
    local to="$ALERT_EMAIL"
    
    if command -v mail >/dev/null && [[ -n "$to" ]]; then
        echo "$body" | mail -s "$subject" "$to"
    fi
}
```

This automation guide provides comprehensive coverage of all automation features available in the dotfiles repository, enabling users to set up and customize automation according to their specific needs and environment.