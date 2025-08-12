#!/opt/homebrew/bin/bash
set -e

# Performance Monitoring and Optimization Script
# Monitors and optimizes shell and system performance

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
PERFORMANCE_LOG="$HOME/.dotfiles-performance.log"
BENCHMARK_RUNS=5
STARTUP_THRESHOLD=1.0  # seconds
WARNING_THRESHOLD=2.0  # seconds

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

# Measure shell startup time
measure_shell_startup() {
    print_header "Shell Startup Performance"
    
    local times=()
    local total=0
    
    print_info "Running $BENCHMARK_RUNS startup measurements..."
    
    for i in $(seq 1 $BENCHMARK_RUNS); do
        local start_time=$(date +%s.%N)
        zsh -i -c 'exit' 2>/dev/null
        local end_time=$(date +%s.%N)
        
        local duration=$(echo "$end_time - $start_time" | bc -l)
        times+=("$duration")
        total=$(echo "$total + $duration" | bc -l)
        
        printf "  Run %d: %.3fs\n" "$i" "$duration"
    done
    
    local average=$(echo "scale=3; $total / $BENCHMARK_RUNS" | bc -l)
    
    print_metric "Average startup time: ${average}s"
    
    # Performance assessment
    if (( $(echo "$average < $STARTUP_THRESHOLD" | bc -l) )); then
        print_success "Excellent performance (< ${STARTUP_THRESHOLD}s)"
    elif (( $(echo "$average < $WARNING_THRESHOLD" | bc -l) )); then
        print_warning "Acceptable performance (< ${WARNING_THRESHOLD}s)"
        print_info "Consider optimizing for better responsiveness"
    else
        print_error "Poor performance (> ${WARNING_THRESHOLD}s)"
        print_info "Optimization recommended"
    fi
    
    # Log results
    echo "$(date): Shell startup average: ${average}s" >> "$PERFORMANCE_LOG"
    
    return 0
}

# Profile shell startup with detailed breakdown
profile_shell_startup() {
    print_header "Shell Startup Profiling"
    
    print_info "Generating detailed startup profile..."
    
    # Create temporary profile script
    local profile_script=$(mktemp)
    trap "rm -f $profile_script" EXIT
    
    cat > "$profile_script" << 'EOF'
# Enable profiling
zmodload zsh/zprof

# Source the main configuration
source ~/.zshrc

# Print profile results
echo "=== ZSH STARTUP PROFILE ==="
zprof
EOF
    
    # Run profiling
    local profile_output=$(zsh -c "source $profile_script" 2>&1)
    
    # Parse and display results
    echo "$profile_output" | tail -20
    
    # Extract top slow functions
    local slow_functions=$(echo "$profile_output" | grep -E "^[[:space:]]*[0-9]" | head -5)
    
    if [[ -n "$slow_functions" ]]; then
        print_warning "Slowest functions:"
        echo "$slow_functions" | while read -r line; do
            echo "  $line"
        done
    fi
}

# Monitor system resource usage
monitor_system_resources() {
    print_header "System Resource Monitoring"
    
    # CPU usage
    local cpu_usage=$(top -l 1 -s 0 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
    print_metric "CPU Usage: ${cpu_usage}%"
    
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
    
    print_metric "Memory Usage: ${used_memory}MB / ${total_memory}MB (${memory_percent}%)"
    
    # Disk usage for home directory
    local disk_usage=$(df -h "$HOME" | tail -1 | awk '{print $5}' | sed 's/%//')
    print_metric "Home Directory Usage: ${disk_usage}%"
    
    # Load average
    local load_avg=$(uptime | awk -F'load averages:' '{print $2}' | xargs)
    print_metric "Load Average: $load_avg"
    
    # Log system metrics
    echo "$(date): CPU: ${cpu_usage}%, Memory: ${memory_percent}%, Disk: ${disk_usage}%, Load: $load_avg" >> "$PERFORMANCE_LOG"
}

# Analyze shell configuration performance
analyze_shell_config() {
    print_header "Shell Configuration Analysis"
    
    # Check for common performance issues
    local config_files=(
        "$HOME/.zshrc"
        "$HOME/.config/zsh/.zshrc"
        "$HOME/.zshrc.local"
    )
    
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            print_info "Analyzing $config_file..."
            
            # Check file size
            local file_size=$(wc -c < "$config_file")
            if [[ $file_size -gt 10000 ]]; then
                print_warning "Large configuration file (${file_size} bytes)"
                print_info "Consider splitting into modules"
            fi
            
            # Check for potentially slow patterns
            local slow_patterns=(
                "find.*-exec"
                "which.*in.*loop"
                "brew.*--prefix"
                "python.*-c"
                "npm.*list"
            )
            
            for pattern in "${slow_patterns[@]}"; do
                if grep -q "$pattern" "$config_file" 2>/dev/null; then
                    print_warning "Potentially slow pattern found: $pattern"
                fi
            done
            
            # Check for synchronous network calls
            if grep -E "(curl|wget|git.*remote)" "$config_file" >/dev/null 2>&1; then
                print_warning "Synchronous network calls detected"
                print_info "Consider lazy loading or background execution"
            fi
        fi
    done
}

# Check plugin performance
analyze_plugin_performance() {
    print_header "Plugin Performance Analysis"
    
    # Check for antidote plugins
    local plugin_file="$HOME/.config/antidote/.zsh_plugins.txt"
    if [[ -f "$plugin_file" ]]; then
        local plugin_count=$(wc -l < "$plugin_file")
        print_metric "Plugin count: $plugin_count"
        
        if [[ $plugin_count -gt 20 ]]; then
            print_warning "High plugin count may impact startup time"
            print_info "Consider removing unused plugins"
        fi
        
        # Check for heavy plugins
        local heavy_plugins=(
            "nvm"
            "pyenv"
            "rbenv"
            "jenv"
            "sdkman"
        )
        
        for plugin in "${heavy_plugins[@]}"; do
            if grep -q "$plugin" "$plugin_file" 2>/dev/null; then
                print_warning "Heavy plugin detected: $plugin"
                print_info "Consider lazy loading"
            fi
        done
    fi
    
    # Check tmux plugin count
    local tmux_plugins_dir="$HOME/.tmux/plugins"
    if [[ -d "$tmux_plugins_dir" ]]; then
        local tmux_plugin_count=$(find "$tmux_plugins_dir" -maxdepth 1 -type d | wc -l)
        print_metric "Tmux plugin count: $tmux_plugin_count"
        
        if [[ $tmux_plugin_count -gt 10 ]]; then
            print_warning "High tmux plugin count may impact session startup"
        fi
    fi
}

# Generate optimization recommendations
generate_recommendations() {
    print_header "Optimization Recommendations"
    
    local recommendations=()
    
    # Shell startup optimization
    recommendations+=(
        "🚀 Shell Startup Optimization:"
        "  • Use lazy loading for heavy tools (nvm, pyenv, etc.)"
        "  • Cache expensive operations (brew --prefix)"
        "  • Move non-essential code to functions"
        "  • Use conditional loading based on directory/context"
    )
    
    # Plugin optimization
    recommendations+=(
        ""
        "🔌 Plugin Optimization:"
        "  • Remove unused plugins"
        "  • Use async loading where possible"
        "  • Profile individual plugins with zprof"
        "  • Consider lightweight alternatives"
    )
    
    # System optimization
    recommendations+=(
        ""
        "⚡ System Optimization:"
        "  • Increase shell history size limits if needed"
        "  • Use SSD for better I/O performance"
        "  • Close unused applications"
        "  • Monitor background processes"
    )
    
    # Configuration optimization
    recommendations+=(
        ""
        "⚙️ Configuration Optimization:"
        "  • Split large config files into modules"
        "  • Use functions instead of aliases for complex operations"
        "  • Avoid network calls in startup scripts"
        "  • Cache frequently used data"
    )
    
    for recommendation in "${recommendations[@]}"; do
        echo "$recommendation"
    done
}

# Create performance optimization script
create_optimization_script() {
    print_header "Creating Optimization Script"
    
    local opt_script="$HOME/.dotfiles/bin/optimize-performance.sh"
    
    cat > "$opt_script" << 'EOF'
#!/bin/bash
# Auto-generated performance optimization script

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo "Performance Optimization Script"
echo "==============================="

# Lazy load nvm
if command -v nvm >/dev/null 2>&1; then
    print_info "Setting up lazy loading for nvm..."
    
    # Create lazy nvm function
    nvm() {
        unset -f nvm
        if [[ -n "${NVM_DIR:-}" ]]; then
            [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
        else
            local nvm_dir="${BREW_PREFIX:-$(brew --prefix)}/opt/nvm"
            [[ -s "$nvm_dir/nvm.sh" ]] && source "$nvm_dir/nvm.sh"
        fi
        nvm "$@"
    }
    
    # Create lazy node/npm functions
    node() { nvm >/dev/null 2>&1; command node "$@"; }
    npm() { nvm >/dev/null 2>&1; command npm "$@"; }
    
    print_success "NVM lazy loading configured"
fi

# Cache brew prefix
if command -v brew >/dev/null 2>&1 && [[ -z "${BREW_PREFIX:-}" ]]; then
    print_info "Caching brew prefix..."
    export BREW_PREFIX="$(brew --prefix)"
    print_success "Brew prefix cached: $BREW_PREFIX"
fi

# Optimize zsh completion
if [[ -d ~/.zcompdump ]]; then
    print_info "Cleaning zsh completion cache..."
    rm -f ~/.zcompdump*
    print_success "Completion cache cleaned"
fi

# Clean up shell history if too large
local history_file="${HISTFILE:-$HOME/.zsh_history}"
if [[ -f "$history_file" ]]; then
    local history_size=$(wc -l < "$history_file")
    if [[ $history_size -gt 50000 ]]; then
        print_warning "Large history file ($history_size lines)"
        print_info "Consider truncating: tail -10000 $history_file > ${history_file}.tmp && mv ${history_file}.tmp $history_file"
    fi
fi

print_success "Performance optimization completed"
print_info "Restart your shell to apply changes: exec zsh"
EOF
    
    chmod +x "$opt_script"
    print_success "Created optimization script: $opt_script"
}

# View performance history
view_performance_history() {
    print_header "Performance History"
    
    if [[ -f "$PERFORMANCE_LOG" ]]; then
        echo "Recent performance measurements:"
        tail -20 "$PERFORMANCE_LOG"
    else
        print_info "No performance history available"
        print_info "Run performance measurements to create history"
    fi
}

# Benchmark comparison
benchmark_comparison() {
    print_header "Performance Benchmarking"
    
    print_info "Running comprehensive benchmark..."
    
    # Shell startup benchmark
    local shell_times=()
    for i in {1..3}; do
        local time=$(time (zsh -i -c 'exit') 2>&1 | grep real | awk '{print $2}' | sed 's/[ms]//g')
        shell_times+=("$time")
    done
    
    # File operations benchmark
    local temp_dir=$(mktemp -d)
    local file_time=$(time (for i in {1..100}; do touch "$temp_dir/file$i"; done) 2>&1 | grep real | awk '{print $2}')
    rm -rf "$temp_dir"
    
    # Command execution benchmark
    local cmd_time=$(time (for i in {1..10}; do ls >/dev/null; done) 2>&1 | grep real | awk '{print $2}')
    
    print_metric "Shell startup: ${shell_times[*]}"
    print_metric "File operations: $file_time"
    print_metric "Command execution: $cmd_time"
    
    # Log benchmark results
    echo "$(date): Benchmark - Shell: ${shell_times[0]}, File: $file_time, Cmd: $cmd_time" >> "$PERFORMANCE_LOG"
}

# Show help
show_help() {
    cat << EOF
Performance Monitoring and Optimization Script

Usage: $0 [command] [options]

Commands:
    startup             Measure shell startup performance
    profile             Profile shell startup with detailed breakdown
    system              Monitor system resource usage
    config              Analyze shell configuration performance
    plugins             Analyze plugin performance
    recommendations     Generate optimization recommendations
    optimize            Create and run optimization script
    history             View performance measurement history
    benchmark           Run comprehensive performance benchmark
    all                 Run all monitoring and analysis

Options:
    -h, --help          Show this help message
    --runs N            Number of benchmark runs (default: $BENCHMARK_RUNS)
    --threshold N       Startup time warning threshold in seconds (default: $WARNING_THRESHOLD)

Examples:
    $0 startup                    # Quick startup time check
    $0 profile                    # Detailed startup profiling
    $0 all                        # Complete performance analysis
    $0 startup --runs 10          # Extended startup benchmarking
EOF
}

# Main function
main() {
    local command="${1:-startup}"
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --runs)
                BENCHMARK_RUNS="$2"
                shift 2
                ;;
            --threshold)
                WARNING_THRESHOLD="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                if [[ "$1" != "$command" ]]; then
                    command="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Ensure bc is available for calculations
    if ! command -v bc >/dev/null 2>&1; then
        print_error "bc (calculator) is required but not installed"
        print_info "Install with: brew install bc"
        exit 1
    fi
    
    echo -e "${BLUE}Performance Monitor${NC}"
    echo "==================="
    
    case "$command" in
        "startup")
            measure_shell_startup
            ;;
        "profile")
            profile_shell_startup
            ;;
        "system")
            monitor_system_resources
            ;;
        "config")
            analyze_shell_config
            ;;
        "plugins")
            analyze_plugin_performance
            ;;
        "recommendations")
            generate_recommendations
            ;;
        "optimize")
            create_optimization_script
            print_info "Run the optimization script: ~/.dotfiles/bin/optimize-performance.sh"
            ;;
        "history")
            view_performance_history
            ;;
        "benchmark")
            benchmark_comparison
            ;;
        "all")
            measure_shell_startup
            analyze_shell_config
            analyze_plugin_performance
            monitor_system_resources
            generate_recommendations
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
    
    print_success "Performance monitoring completed"
    print_info "Performance log: $PERFORMANCE_LOG"
}

main "$@"