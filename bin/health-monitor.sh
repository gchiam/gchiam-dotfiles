#!/opt/homebrew/bin/bash
set -e

# Health Monitoring System
# Continuous monitoring and alerting for dotfiles environment

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    PURPLE='\033[0;35m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    PURPLE=''
    NC=''
fi

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_metric() {
    echo -e "${PURPLE}📊${NC} $1"
}

# Configuration
MONITOR_LOG="$HOME/.dotfiles-health-monitor.log"
ALERT_LOG="$HOME/.dotfiles-alerts.log"
STATUS_FILE="$HOME/.dotfiles-health-status.json"
CONFIG_DIR="$HOME/.config/dotfiles-monitor"
ALERTS_ENABLED=true
MONITORING_INTERVAL=300  # 5 minutes
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Thresholds
SHELL_STARTUP_THRESHOLD=2.0     # seconds
MEMORY_USAGE_THRESHOLD=80       # percentage
DISK_USAGE_THRESHOLD=90         # percentage
CPU_USAGE_THRESHOLD=80          # percentage
FAILED_COMMANDS_THRESHOLD=5     # count

# Create config directory
mkdir -p "$CONFIG_DIR"

# Logging functions
log_event() {
    echo "$(date): $1" >> "$MONITOR_LOG"
}

log_alert() {
    echo "$(date): ALERT: $1" >> "$ALERT_LOG"
    [[ "$ALERTS_ENABLED" == true ]] && show_alert "$1"
}

# Show alert notification
show_alert() {
    local message="$1"
    
    # Try to show system notification
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"Dotfiles Health Alert\"" 2>/dev/null || true
    fi
    
    # Also show in terminal if running interactively
    if [[ -t 1 ]]; then
        print_error "ALERT: $message"
    fi
}

# Health check functions
check_shell_performance() {
    local start_time=$(date +%s.%N)
    
    # Test shell startup time
    if command -v zsh &> /dev/null; then
        local shell_time=$(time (zsh -i -c 'exit' 2>/dev/null) 2>&1 | grep real | awk '{print $2}' | sed 's/[ms]//g' || echo "0")
        
        # Convert to seconds if needed
        if [[ "$shell_time" == *"m"* ]]; then
            local minutes=$(echo "$shell_time" | cut -d'm' -f1)
            local seconds=$(echo "$shell_time" | cut -d'm' -f2 | sed 's/s//')
            shell_time=$(echo "$minutes * 60 + $seconds" | bc -l)
        elif [[ "$shell_time" == *"s"* ]]; then
            shell_time=$(echo "$shell_time" | sed 's/s//')
        fi
        
        # Alert if too slow
        if (( $(echo "$shell_time > $SHELL_STARTUP_THRESHOLD" | bc -l) )); then
            log_alert "Shell startup slow: ${shell_time}s (threshold: ${SHELL_STARTUP_THRESHOLD}s)"
            return 1
        fi
        
        echo "shell_startup_time:$shell_time"
    fi
    
    return 0
}

check_system_resources() {
    # Memory usage
    local memory_info=$(vm_stat)
    local pages_free=$(echo "$memory_info" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    local pages_active=$(echo "$memory_info" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    local pages_inactive=$(echo "$memory_info" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
    local pages_wired=$(echo "$memory_info" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
    
    local page_size=4096
    local total_memory=$(echo "($pages_free + $pages_active + $pages_inactive + $pages_wired) * $page_size / 1024 / 1024" | bc)
    local used_memory=$(echo "($pages_active + $pages_inactive + $pages_wired) * $page_size / 1024 / 1024" | bc)
    local memory_percent=$(echo "scale=1; $used_memory * 100 / $total_memory" | bc)
    
    if (( $(echo "$memory_percent > $MEMORY_USAGE_THRESHOLD" | bc -l) )); then
        log_alert "High memory usage: ${memory_percent}% (threshold: ${MEMORY_USAGE_THRESHOLD}%)"
    fi
    
    echo "memory_usage_percent:$memory_percent"
    
    # Disk usage
    local disk_usage=$(df -h "$HOME" | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if [[ $disk_usage -gt $DISK_USAGE_THRESHOLD ]]; then
        log_alert "High disk usage: ${disk_usage}% (threshold: ${DISK_USAGE_THRESHOLD}%)"
    fi
    
    echo "disk_usage_percent:$disk_usage"
    
    # CPU usage (last 1 minute)
    local cpu_usage=$(top -l 2 -s 1 | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//' || echo "0")
    
    if (( $(echo "$cpu_usage > $CPU_USAGE_THRESHOLD" | bc -l) 2>/dev/null )); then
        log_alert "High CPU usage: ${cpu_usage}% (threshold: ${CPU_USAGE_THRESHOLD}%)"
    fi
    
    echo "cpu_usage_percent:$cpu_usage"
    
    return 0
}

check_development_tools() {
    local issues_found=0
    
    # Check essential tools
    local essential_tools=("git" "zsh" "tmux" "nvim" "brew")
    
    for tool in "${essential_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_alert "Essential tool missing: $tool"
            ((issues_found++))
        fi
    done
    
    # Check Homebrew
    if command -v brew &> /dev/null; then
        local outdated_count=$(brew outdated | wc -l | xargs)
        if [[ $outdated_count -gt 10 ]]; then
            log_alert "Many outdated Homebrew packages: $outdated_count"
        fi
        echo "brew_outdated_count:$outdated_count"
    fi
    
    # Check git repository status
    if git rev-parse --git-dir &> /dev/null; then
        local uncommitted=$(git status --porcelain | wc -l | xargs)
        if [[ $uncommitted -gt 0 ]]; then
            echo "git_uncommitted_changes:$uncommitted"
        fi
        
        # Check if we're behind remote
        if git remote | grep -q origin; then
            git fetch origin 2>/dev/null || true
            local behind=$(git rev-list HEAD..origin/$(git branch --show-current) --count 2>/dev/null || echo "0")
            if [[ $behind -gt 0 ]]; then
                echo "git_commits_behind:$behind"
            fi
        fi
    fi
    
    echo "development_issues:$issues_found"
    return $issues_found
}

check_configuration_integrity() {
    local config_issues=0
    
    # Check important config files
    local config_files=(
        "$HOME/.zshrc"
        "$HOME/.config/zsh/.zshrc"
        "$HOME/.tmux.conf"
        "$HOME/.config/tmux/tmux.conf"
        "$HOME/.gitconfig"
    )
    
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            # Check if file is readable
            if [[ ! -r "$config_file" ]]; then
                log_alert "Config file not readable: $config_file"
                ((config_issues++))
            fi
            
            # Check for syntax errors in shell configs
            if [[ "$config_file" == *".zshrc"* ]] || [[ "$config_file" == *".zsh"* ]]; then
                if ! zsh -n "$config_file" 2>/dev/null; then
                    log_alert "Syntax error in: $config_file"
                    ((config_issues++))
                fi
            fi
            
            # Check tmux config
            if [[ "$config_file" == *"tmux.conf"* ]]; then
                if ! tmux -f "$config_file" list-keys > /dev/null 2>&1; then
                    log_alert "Invalid tmux config: $config_file"
                    ((config_issues++))
                fi
            fi
        fi
    done
    
    # Check submodules if they exist
    if [[ -f "$REPO_ROOT/.gitmodules" ]]; then
        local submodule_issues=$(git submodule status | grep -c "^-" || echo "0")
        if [[ $submodule_issues -gt 0 ]]; then
            log_alert "Uninitialized submodules: $submodule_issues"
            ((config_issues++))
        fi
        echo "submodule_issues:$submodule_issues"
    fi
    
    echo "config_issues:$config_issues"
    return $config_issues
}

check_security_status() {
    local security_issues=0
    
    # Check for suspicious files
    local suspicious_patterns=(
        "*.log"
        "*password*"
        "*secret*"
        "*.key"
        ".env"
    )
    
    for pattern in "${suspicious_patterns[@]}"; do
        local matches=$(find "$REPO_ROOT" -name "$pattern" -not -path "*/.git/*" 2>/dev/null | wc -l | xargs)
        if [[ $matches -gt 0 ]] && [[ "$pattern" != "*.log" || $matches -gt 5 ]]; then
            echo "suspicious_files_${pattern//[^a-zA-Z0-9]/_}:$matches"
        fi
    done
    
    # Check file permissions
    local world_writable=$(find "$HOME" -maxdepth 3 -perm -002 -type f 2>/dev/null | wc -l | xargs)
    if [[ $world_writable -gt 0 ]]; then
        log_alert "World-writable files found: $world_writable"
        ((security_issues++))
    fi
    
    echo "security_issues:$security_issues"
    return $security_issues
}

# Generate health report
generate_health_report() {
    local timestamp=$(date)
    local metrics=()
    
    print_header "Health Monitoring Report"
    
    # Collect all metrics
    print_info "Collecting metrics..."
    
    # Shell performance
    local shell_metrics=$(check_shell_performance 2>/dev/null || echo "shell_startup_time:error")
    metrics+=("$shell_metrics")
    
    # System resources
    local system_metrics=$(check_system_resources 2>/dev/null || echo "system_check:error")
    metrics+=("$system_metrics")
    
    # Development tools
    local dev_metrics=$(check_development_tools 2>/dev/null || echo "dev_tools:error")
    metrics+=("$dev_metrics")
    
    # Configuration integrity
    local config_metrics=$(check_configuration_integrity 2>/dev/null || echo "config_check:error")
    metrics+=("$config_metrics")
    
    # Security status
    local security_metrics=$(check_security_status 2>/dev/null || echo "security_check:error")
    metrics+=("$security_metrics")
    
    # Create JSON status file
    {
        echo "{"
        echo "  \"timestamp\": \"$timestamp\","
        echo "  \"status\": \"healthy\","
        echo "  \"metrics\": {"
        
        local first=true
        for metric_line in "${metrics[@]}"; do
            IFS=$'\n' read -d '' -r -a metric_items <<< "$metric_line" || true
            for item in "${metric_items[@]}"; do
                if [[ "$item" == *":"* ]]; then
                    local key=$(echo "$item" | cut -d: -f1)
                    local value=$(echo "$item" | cut -d: -f2-)
                    
                    if [[ "$first" == true ]]; then
                        first=false
                    else
                        echo ","
                    fi
                    
                    # Format value as number or string
                    if [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
                        echo -n "    \"$key\": $value"
                    else
                        echo -n "    \"$key\": \"$value\""
                    fi
                fi
            done
        done
        
        echo
        echo "  }"
        echo "}"
    } > "$STATUS_FILE"
    
    # Display summary
    print_success "Health report generated"
    print_info "Status file: $STATUS_FILE"
    
    # Show key metrics
    if [[ -f "$STATUS_FILE" ]]; then
        local shell_time=$(jq -r '.metrics.shell_startup_time // "unknown"' "$STATUS_FILE" 2>/dev/null)
        local memory_usage=$(jq -r '.metrics.memory_usage_percent // "unknown"' "$STATUS_FILE" 2>/dev/null)
        local disk_usage=$(jq -r '.metrics.disk_usage_percent // "unknown"' "$STATUS_FILE" 2>/dev/null)
        
        echo
        print_metric "Shell startup: ${shell_time}s"
        print_metric "Memory usage: ${memory_usage}%"
        print_metric "Disk usage: ${disk_usage}%"
    fi
}

# Start monitoring daemon
start_monitoring() {
    print_header "Starting Health Monitoring"
    
    local pid_file="$CONFIG_DIR/monitor.pid"
    
    # Check if already running
    if [[ -f "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        print_warning "Monitoring is already running (PID: $(cat "$pid_file"))"
        return 1
    fi
    
    print_info "Starting monitoring with ${MONITORING_INTERVAL}s interval"
    
    # Start background monitoring
    {
        echo $$ > "$pid_file"
        
        while true; do
            generate_health_report > /dev/null 2>&1
            log_event "Health check completed"
            sleep "$MONITORING_INTERVAL"
        done
    } &
    
    local monitor_pid=$!
    echo "$monitor_pid" > "$pid_file"
    
    print_success "Monitoring started (PID: $monitor_pid)"
    print_info "View status: $0 status"
    print_info "Stop monitoring: $0 stop"
}

# Stop monitoring daemon
stop_monitoring() {
    print_header "Stopping Health Monitoring"
    
    local pid_file="$CONFIG_DIR/monitor.pid"
    
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file")
        if kill "$pid" 2>/dev/null; then
            print_success "Monitoring stopped (PID: $pid)"
        else
            print_warning "Failed to stop monitoring process"
        fi
        rm -f "$pid_file"
    else
        print_info "Monitoring is not running"
    fi
}

# Show monitoring status
show_status() {
    print_header "Health Monitoring Status"
    
    local pid_file="$CONFIG_DIR/monitor.pid"
    
    if [[ -f "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        local pid=$(cat "$pid_file")
        print_success "Monitoring is running (PID: $pid)"
        
        # Show uptime
        local start_time=$(ps -o lstart= -p "$pid" 2>/dev/null | xargs || echo "Unknown")
        print_info "Started: $start_time"
    else
        print_warning "Monitoring is not running"
    fi
    
    # Show configuration
    echo
    print_info "Configuration:"
    echo "  Interval: ${MONITORING_INTERVAL}s"
    echo "  Alerts: $ALERTS_ENABLED"
    echo "  Thresholds:"
    echo "    Shell startup: ${SHELL_STARTUP_THRESHOLD}s"
    echo "    Memory usage: ${MEMORY_USAGE_THRESHOLD}%"
    echo "    Disk usage: ${DISK_USAGE_THRESHOLD}%"
    
    # Show recent status
    if [[ -f "$STATUS_FILE" ]]; then
        echo
        print_info "Last health check:"
        local timestamp=$(jq -r '.timestamp // "unknown"' "$STATUS_FILE" 2>/dev/null)
        echo "  Time: $timestamp"
        
        local shell_time=$(jq -r '.metrics.shell_startup_time // "unknown"' "$STATUS_FILE" 2>/dev/null)
        local memory_usage=$(jq -r '.metrics.memory_usage_percent // "unknown"' "$STATUS_FILE" 2>/dev/null)
        
        echo "  Shell startup: ${shell_time}s"
        echo "  Memory usage: ${memory_usage}%"
    fi
    
    # Show recent alerts
    if [[ -f "$ALERT_LOG" ]]; then
        echo
        print_info "Recent alerts:"
        tail -5 "$ALERT_LOG" | sed 's/^/  /'
    fi
}

# Setup monitoring automation
setup_automation() {
    print_header "Setting Up Monitoring Automation"
    
    # Create launchd plist for macOS
    local plist_file="$HOME/Library/LaunchAgents/com.gchiam.dotfiles-health-monitor.plist"
    local script_path=$(realpath "$0")
    
    cat > "$plist_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.gchiam.dotfiles-health-monitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>$script_path</string>
        <string>start</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$REPO_ROOT</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.dotfiles-health-monitor-stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.dotfiles-health-monitor-stderr.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF
    
    if launchctl load "$plist_file" 2>/dev/null; then
        print_success "Automated monitoring configured"
        print_info "The monitor will start automatically and restart if it crashes"
    else
        print_warning "Failed to setup automated monitoring"
    fi
}

# View logs
view_logs() {
    local log_type="${1:-monitor}"
    
    case "$log_type" in
        "monitor"|"health")
            if [[ -f "$MONITOR_LOG" ]]; then
                print_header "Health Monitor Log"
                tail -20 "$MONITOR_LOG"
            else
                print_info "No monitor log found"
            fi
            ;;
        "alerts")
            if [[ -f "$ALERT_LOG" ]]; then
                print_header "Alert Log"
                tail -20 "$ALERT_LOG"
            else
                print_info "No alerts logged"
            fi
            ;;
        "all")
            view_logs "monitor"
            echo
            view_logs "alerts"
            ;;
        *)
            print_error "Unknown log type: $log_type"
            print_info "Available types: monitor, alerts, all"
            ;;
    esac
}

# Show help
show_help() {
    cat << EOF
Health Monitoring System for Dotfiles

Usage: $0 [command] [options]

Commands:
    report              Generate one-time health report
    start               Start continuous monitoring daemon
    stop                Stop monitoring daemon
    status              Show monitoring status and recent metrics
    restart             Restart monitoring daemon
    setup-automation    Setup automatic monitoring via launchd
    logs [type]         View logs (monitor, alerts, all)
    
Options:
    --interval SECONDS  Set monitoring interval (default: $MONITORING_INTERVAL)
    --no-alerts        Disable alert notifications
    --help             Show this help message

Monitoring includes:
    • Shell startup performance
    • System resource usage (CPU, memory, disk)
    • Development tool availability
    • Configuration file integrity  
    • Security status checks
    • Git repository status

Thresholds:
    • Shell startup: ${SHELL_STARTUP_THRESHOLD}s
    • Memory usage: ${MEMORY_USAGE_THRESHOLD}%
    • Disk usage: ${DISK_USAGE_THRESHOLD}%
    • CPU usage: ${CPU_USAGE_THRESHOLD}%

Files:
    • Status: $STATUS_FILE
    • Monitor log: $MONITOR_LOG
    • Alert log: $ALERT_LOG
    • Config: $CONFIG_DIR/

Examples:
    $0 report                    # Generate health report
    $0 start                     # Start monitoring
    $0 --interval 600 start      # Monitor every 10 minutes
    $0 logs alerts              # View alert history
EOF
}

# Main function
main() {
    local command="report"
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --interval)
                MONITORING_INTERVAL="$2"
                shift 2
                ;;
            --no-alerts)
                ALERTS_ENABLED=false
                shift
                ;;
            report|start|stop|status|restart|setup-automation|logs)
                command="$1"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                if [[ "$command" == "logs" ]]; then
                    # Additional argument for logs command
                    view_logs "$1"
                    exit 0
                else
                    print_error "Unknown option: $1"
                    show_help
                    exit 1
                fi
                ;;
        esac
    done
    
    echo -e "${BLUE}Health Monitoring System${NC}"
    echo "======================="
    
    case "$command" in
        "report")
            generate_health_report
            ;;
        "start")
            start_monitoring
            ;;
        "stop")
            stop_monitoring
            ;;
        "status")
            show_status
            ;;
        "restart")
            stop_monitoring
            sleep 2
            start_monitoring
            ;;
        "setup-automation")
            setup_automation
            ;;
        "logs")
            view_logs "all"
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Ensure jq is available for JSON operations
if ! command -v jq &> /dev/null && [[ "$1" != "--help" ]] && [[ "$1" != "-h" ]]; then
    print_warning "jq not found, installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install jq
    else
        print_error "jq is required but not available. Please install it manually."
        exit 1
    fi
fi

main "$@"