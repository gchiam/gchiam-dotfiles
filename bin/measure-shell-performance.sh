#!/bin/bash
set -euo pipefail

# Shell Performance Measurement Script
# Measures zsh startup time and provides optimization recommendations

# Handle --no-color flag
NO_COLOR=false
if [[ "${1:-}" == "--no-color" ]]; then
    NO_COLOR=true
    shift
fi

# Colors
if [[ "$NO_COLOR" = true ]]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

# Configuration
ITERATIONS=${1:-10}
SHELL_TO_TEST=${2:-zsh}

print_header() {
    echo -e "${BLUE}=== Shell Performance Measurement ===${NC}"
    echo "Shell: $SHELL_TO_TEST"
    echo "Iterations: $ITERATIONS"
    echo "Date: $(date)"
    echo
}

measure_startup_time() {
    local shell_cmd="$1"
    local times=()
    
    echo -e "${YELLOW}Measuring startup times...${NC}"
    
    for ((i=1; i<=ITERATIONS; i++)); do
        echo -n "Run $i/$ITERATIONS: "
        
        # Measure time for shell to start and exit
        local start_time
        start_time=$(python3 -c "import time; print(time.time())")
        $shell_cmd -c "exit" 2>/dev/null
        local end_time
        end_time=$(python3 -c "import time; print(time.time())")
        
        local duration
        duration=$(python3 -c "print(f'{$end_time - $start_time:.3f}')")
        times+=("$duration")
        echo "${duration}s"
    done
    
    # Calculate statistics
    local total=0
    local min=${times[0]}
    local max=${times[0]}
    
    for time in "${times[@]}"; do
        total=$(python3 -c "print($total + $time)")
        if (( $(python3 -c "print(1 if $time < $min else 0)") )); then
            min=$time
        fi
        if (( $(python3 -c "print(1 if $time > $max else 0)") )); then
            max=$time
        fi
    done
    
    local avg
    avg=$(python3 -c "print(f'{$total / $ITERATIONS:.3f}')")
    
    echo
    echo -e "${GREEN}Results:${NC}"
    echo "Average: ${avg}s"
    echo "Minimum: ${min}s"
    echo "Maximum: ${max}s"
    echo "Range: $(python3 -c "print(f'{$max - $min:.3f}')")s"
    
    # Performance assessment
    if (( $(python3 -c "print(1 if $avg < 0.1 else 0)") )); then
        echo -e "${GREEN}✓ Excellent performance${NC}"
    elif (( $(python3 -c "print(1 if $avg < 0.3 else 0)") )); then
        echo -e "${YELLOW}⚠ Good performance${NC}"
    elif (( $(python3 -c "print(1 if $avg < 0.5 else 0)") )); then
        echo -e "${YELLOW}⚠ Fair performance - consider optimization${NC}"
    else
        echo -e "${RED}✗ Slow performance - optimization recommended${NC}"
    fi
}

measure_plugin_impact() {
    if [[ "$SHELL_TO_TEST" == "zsh" ]]; then
        echo -e "\n${YELLOW}Measuring plugin impact...${NC}"
        
        # Test minimal zsh (no plugins)
        echo "Testing minimal zsh (ZSH_MINIMAL_MODE=true):"
        ZSH_MINIMAL_MODE=true measure_startup_time "zsh"
        
        echo
        echo "Testing full zsh (with plugins):"
        ZSH_MINIMAL_MODE=false measure_startup_time "zsh"
    fi
}

check_heavy_operations() {
    echo -e "\n${YELLOW}Checking for heavy operations in startup files...${NC}"
    
    local heavy_patterns=(
        "curl\|wget\|fetch"  # Network calls
        "find.*-exec"        # Heavy find operations
        "grep -r"            # Recursive grep
        "source.*completion" # Heavy completion loading
        "\$\(.*completion"   # Command substitution for completions
    )
    
    local config_files=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.config/zsh/*.zsh"
    )
    
    for pattern in "${heavy_patterns[@]}"; do
        echo -n "Checking for: $pattern ... "
        local found=false
        
        for file in "${config_files[@]}"; do
            if [[ -f "$file" ]] && grep -q "$pattern" "$file" 2>/dev/null; then
                if [[ "$found" == false ]]; then
                    echo -e "${YELLOW}FOUND${NC}"
                    found=true
                fi
                echo "  -> $file: $(grep -n "$pattern" "$file" | head -1)"
            fi
        done
        
        if [[ "$found" == false ]]; then
            echo -e "${GREEN}OK${NC}"
        fi
    done
}

provide_recommendations() {
    echo -e "\n${BLUE}=== Optimization Recommendations ===${NC}"
    
    echo "1. Enable lazy loading for heavy tools:"
    echo "   - kubectl, docker, terraform completions"
    echo "   - Use ZSH_MINIMAL_MODE=true for remote/container environments"
    echo
    
    echo "2. Profile specific bottlenecks:"
    echo "   zsh -xvs <<< 'exit' 2>&1 | grep -E '^\\+.*completion|^\\+.*source'"
    echo
    
    echo "3. Consider using zsh-defer for heavy plugins:"
    echo "   https://github.com/romkatv/zsh-defer"
    echo
    
    echo "4. Monitor plugin performance:"
    echo "   Use 'zsh -df' to start without configs and test incrementally"
    echo
    
    echo "5. Check for duplicate functionality:"
    echo "   Review aliases and functions across bash/zsh/fish configs"
}

main() {
    print_header
    measure_startup_time "$SHELL_TO_TEST"
    
    if [[ "$SHELL_TO_TEST" == "zsh" ]]; then
        measure_plugin_impact
    fi
    
    check_heavy_operations
    provide_recommendations
    
    echo -e "\n${GREEN}Performance measurement complete!${NC}"
}

# Help function
show_help() {
    echo "Usage: $0 [iterations] [shell]"
    echo
    echo "Options:"
    echo "  iterations    Number of test runs (default: 10)"
    echo "  shell         Shell to test (default: zsh)"
    echo
    echo "Examples:"
    echo "  $0            # Test zsh with 10 iterations"
    echo "  $0 20         # Test zsh with 20 iterations"
    echo "  $0 10 bash    # Test bash with 10 iterations"
}

# Handle help flag
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

# Make sure we have Python 3 for calculations
if ! command -v python3 >/dev/null; then
    echo -e "${RED}Error: python3 is required for performance calculations${NC}" >&2
    exit 1
fi

main