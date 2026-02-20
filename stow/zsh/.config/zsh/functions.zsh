# vim: set ft=zsh:
# Custom Zsh Functions
# Useful utility functions for development and system administration

# Create directory and cd into it
mkcd() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: mkcd <directory_name>" >&2
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: extract <file>" >&2
        echo "Supported formats: .tar.gz, .tar.bz2, .tar.xz, .zip, .rar, .7z, .gz, .bz2" >&2
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "Error: '$1' is not a valid file" >&2
        return 1
    fi
    
    case "$1" in
        *.tar.gz|*.tgz)     tar -xzf "$1" ;;
        *.tar.bz2|*.tbz2)   tar -xjf "$1" ;;
        *.tar.xz|*.txz)     tar -xJf "$1" ;;
        *.tar)              tar -xf "$1" ;;
        *.zip)              unzip "$1" ;;
        *.rar)              unrar x "$1" ;;
        *.7z)               7z x "$1" ;;
        *.gz)               gunzip "$1" ;;
        *.bz2)              bunzip2 "$1" ;;
        *.Z)                uncompress "$1" ;;
        *)                  echo "Error: '$1' cannot be extracted via extract()" >&2; return 1 ;;
    esac
}

# Find and kill process by name
killp() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: killp <process_name>" >&2
        return 1
    fi
    
    local pids
    pids=($(pgrep -f "$1"))
    
    if [[ ${#pids[@]} -eq 0 ]]; then
        echo "No processes found matching '$1'" >&2
        return 1
    fi
    
    echo "Found ${#pids[@]} process(es) matching '$1':"
    ps -p "${pids[@]}" -o pid,ppid,user,command
    
    echo -n "Kill these processes? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        kill "${pids[@]}"
        echo "Processes killed"
    else
        echo "Operation cancelled"
    fi
}

# Quick backup of file
backup() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: backup <file>" >&2
        return 1
    fi
    
    if [[ ! -e "$1" ]]; then
        echo "Error: '$1' does not exist" >&2
        return 1
    fi
    
    local backup_name="${1}.backup.$(date +%Y%m%d_%H%M%S)"
    cp -r "$1" "$backup_name"
    echo "Backup created: $backup_name"
}

# Git shortcuts and enhancements
git-branch-clean() {
    echo "Cleaning up merged branches..."
    git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
}

git-last() {
    local count=${1:-10}
    git log --oneline -n "$count"
}

git-size() {
    git count-objects -v | grep -E "(size|size-pack)" | awk '{print $2}' | paste -sd+ | bc | numfmt --to=iec
}

# Network utilities
myip() {
    echo "Local IP addresses:"
    ifconfig | grep -E "inet [0-9]" | grep -v 127.0.0.1 | awk '{print $2}'
    echo
    echo "Public IP address:"
    command curl -s https://ipinfo.io/ip 2>/dev/null || command curl -s https://api.ipify.org 2>/dev/null || echo "Unable to fetch public IP"
}

# Port checking
port() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: port <port_number>" >&2
        return 1
    fi
    
    lsof -i ":$1"
}

# Directory size with human readable format
dush() {
    du -sh "${@:-.}" | sort -hr
}


# JSON pretty print
json() {
    if [[ $# -eq 0 ]]; then
        python3 -m json.tool
    else
        python3 -m json.tool "$1"
    fi
}

# Base64 encode/decode shortcuts
b64encode() {
    echo -n "$1" | base64
}

b64decode() {
    echo -n "$1" | base64 -d
}

# Docker helpers
docker-clean() {
    echo "Cleaning Docker containers..."
    docker container prune -f
    echo "Cleaning Docker images..."
    docker image prune -f
    echo "Cleaning Docker volumes..."
    docker volume prune -f
    echo "Cleaning Docker networks..."
    docker network prune -f
}

docker-stop-all() {
    local containers
    containers=$(docker ps -q)
    if [[ -n "$containers" ]]; then
        docker stop $containers
        echo "All running containers stopped"
    else
        echo "No running containers found"
    fi
}

# Kubernetes helpers
k8s-ctx() {
    if [[ $# -eq 0 ]]; then
        kubectl config current-context
    else
        kubectl config use-context "$1"
    fi
}

k8s-ns() {
    if [[ $# -eq 0 ]]; then
        kubectl config view --minify --output 'jsonpath={..namespace}' || echo "default"
    else
        kubectl config set-context --current --namespace="$1"
    fi
}

# File search helpers
ff() {
    find . -type f -name "*$1*" 2>/dev/null
}

fd() {
    find . -type d -name "*$1*" 2>/dev/null
}


# System information
sysinfo() {
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "OS: $(uname -s) $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Uptime: $(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')"
    echo "Load: $(uptime | awk -F'load average: ' '{print $2}')"
    echo "Memory: $(free -h 2>/dev/null | grep ^Mem | awk '{print $3 "/" $2}' || echo "N/A (macOS)")"
    echo "Disk: $(df -h . | tail -1 | awk '{print $3 "/" $2 " (" $5 " used)"}')"
}

# Performance monitoring
topcpu() {
    ps aux | sort -nr -k 3 | head -"${1:-10}"
}

topmem() {
    ps aux | sort -nr -k 4 | head -"${1:-10}"
}

# Text processing helpers
upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Random password generator
genpass() {
    local length=${1:-16}
    openssl rand -base64 "$length" | tr -d "=+/" | cut -c1-"$length"
}

# Quick notes
note() {
    local notes_file="$HOME/.notes"
    if [[ $# -eq 0 ]]; then
        if [[ -f "$notes_file" ]]; then
            cat "$notes_file"
        else
            echo "No notes found. Use 'note <text>' to add a note."
        fi
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" >> "$notes_file"
        echo "Note added"
    fi
}

# Performance monitoring control
zsh-perf() {
    case "$1" in
        enable|on)
            # Check if we're in zsh and have EPOCHREALTIME support
            if [[ -n "$ZSH_VERSION" ]]; then
                local major_version="${ZSH_VERSION%%.*}"
                if (( major_version >= 5 )); then
                    export ZSH_PERFORMANCE_MONITORING=true
                    echo "✓ Zsh performance monitoring enabled"
                    echo "ℹ Restart your shell to begin tracking startup times"
                    if [[ -n "$EPOCHREALTIME" ]]; then
                        echo "✓ EPOCHREALTIME support confirmed"
                    else
                        echo "ℹ EPOCHREALTIME will be available in zsh sessions"
                    fi
                else
                    echo "❌ Cannot enable performance monitoring"
                    echo "⚠️  Requires zsh 5.0+ (current: zsh $ZSH_VERSION)"
                fi
            else
                echo "❌ Cannot enable performance monitoring"
                echo "⚠️  This function requires zsh shell"
                echo "ℹ Current shell: $0"
            fi
            ;;
        disable|off)
            unset ZSH_PERFORMANCE_MONITORING
            echo "✓ Zsh performance monitoring disabled"
            ;;
        status)
            if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]]; then
                echo "✓ Performance monitoring: enabled"
                if [[ -n "$ZSH_STARTUP_TIME" ]]; then
                    local startup_time="$ZSH_STARTUP_TIME"
                    echo "ℹ Current session startup time: ${startup_time}s"
                    
                    # Performance threshold warnings
                    if (( $(echo "$startup_time > 3.0" | bc -l 2>/dev/null || echo 0) )); then
                        echo "🚨 SLOW: Startup time > 3.0s - consider optimization"
                    elif (( $(echo "$startup_time > 2.0" | bc -l 2>/dev/null || echo 0) )); then
                        echo "⚠️  WARNING: Startup time > 2.0s - may need attention"
                    elif (( $(echo "$startup_time > 1.0" | bc -l 2>/dev/null || echo 0) )); then
                        echo "⚡ GOOD: Startup time > 1.0s but acceptable"
                    else
                        echo "🚀 EXCELLENT: Fast startup time"
                    fi
                    
                    # Show plugin loading time if available
                    if [[ -n "$ZSH_PLUGIN_LOAD_TIME" ]]; then
                        echo "🔌 Plugin load time: ${ZSH_PLUGIN_LOAD_TIME}s"
                        if (( $(echo "$ZSH_PLUGIN_LOAD_TIME > 1.0" | bc -l 2>/dev/null || echo 0) )); then
                            echo "   ⚠️  Plugins are taking significant time to load"
                        fi
                    fi
                fi
            else
                echo "✗ Performance monitoring: disabled"
            fi
            ;;
        log)
            if [[ -f "$HOME/.dotfiles-performance.log" ]]; then
                tail -"${2:-20}" "$HOME/.dotfiles-performance.log"
            else
                echo "No performance log found"
            fi
            ;;
        analyze)
            local perf_script
            # Find performance-monitor.sh in common locations
            for path in "$HOME/bin/performance-monitor.sh" "$HOME/.local/bin/performance-monitor.sh" "$HOME/projects/gchiam-dotfiles/bin/performance-monitor.sh" "$HOME/.dotfiles/bin/performance-monitor.sh"; do
                if [[ -x "$path" ]]; then
                    perf_script="$path"
                    break
                fi
            done
            
            if [[ -n "$perf_script" ]]; then
                "$perf_script" startup
            else
                echo "Performance monitor script not found in standard locations"
                echo "Searched: ~/bin, ~/.local/bin, ~/projects/gchiam-dotfiles/bin, ~/.dotfiles/bin"
            fi
            ;;
        summary)
            if [[ -f "$HOME/.dotfiles-performance.log" ]]; then
                echo "=== Performance Summary (Last 24 hours) ==="
                local today=$(date '+%Y-%m-%d')
                local log_entries=$(grep "^$today" "$HOME/.dotfiles-performance.log" 2>/dev/null | wc -l | tr -d ' ')
                
                if [[ "$log_entries" -gt 0 ]]; then
                    echo "📊 Shell sessions today: $log_entries"
                    
                    # Calculate average startup time (requires bc)
                    if command -v bc >/dev/null; then
                        local avg_time=$(grep "^$today" "$HOME/.dotfiles-performance.log" 2>/dev/null | \
                            grep -o '[0-9]*\.[0-9]*s' | sed 's/s$//' | \
                            awk '{sum+=$1; count++} END {if(count>0) printf "%.3f", sum/count; else print "0"}')
                        
                        if [[ -n "$avg_time" ]] && [[ "$avg_time" != "0" ]]; then
                            echo "⏱️  Average startup time: ${avg_time}s"
                            
                            # Performance assessment
                            if (( $(echo "$avg_time > 2.0" | bc -l) )); then
                                echo "💡 Suggestion: Consider running 'zsh-perf analyze' for optimization tips"
                            elif (( $(echo "$avg_time < 1.0" | bc -l) )); then
                                echo "🚀 Excellent performance - no action needed"
                            fi
                        fi
                    else
                        echo "ℹ️  Install 'bc' for detailed performance analytics"
                    fi
                    
                    echo "📈 Recent startup times:"
                    tail -5 "$HOME/.dotfiles-performance.log" | sed 's/^/   /'
                else
                    echo "ℹ️  No performance data for today"
                fi
            else
                echo "No performance log found - enable monitoring with 'zsh-perf enable'"
            fi
            ;;
        *)
            echo "Usage: zsh-perf {enable|disable|status|log [lines]|analyze|summary}"
            echo "  enable   - Enable performance monitoring"
            echo "  disable  - Disable performance monitoring"
            echo "  status   - Show current monitoring status with thresholds"
            echo "  log      - Show recent performance log entries"
            echo "  summary  - Show performance summary and trends"
            echo "  analyze  - Run detailed performance analysis"
            ;;
    esac
}

# Clean up function definitions on shell exit
cleanup_functions() {
    unset -f mkcd extract killp backup git-branch-clean git-last git-size myip port dush json
    unset -f b64encode b64decode docker-clean docker-stop-all k8s-ctx k8s-ns
    unset -f ff fd sysinfo topcpu topmem upper lower genpass note zsh-perf cleanup_functions
}

# Register cleanup function to run on shell exit (only for non-interactive shells)
# Interactive shells should keep functions available
if [[ ! -o interactive ]]; then
    trap cleanup_functions EXIT
fi
