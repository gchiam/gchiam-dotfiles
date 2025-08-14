#!/opt/homebrew/bin/bash
set -e

# macOS Compatibility Checker
# Verifies system compatibility before dotfiles installation

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
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

# System information
MACOS_VERSION=""
MACOS_MAJOR=""
MACOS_MINOR=""
ARCHITECTURE=""
SHELL_VERSION=""
HOMEBREW_VERSION=""

# Compatibility requirements (using functions instead of associative arrays for bash 3.2 compatibility)
get_min_version() {
    case "$1" in
        "macos_major") echo "12" ;;     # macOS Monterey (12.0)
        "zsh") echo "5.8" ;;
        "tmux") echo "3.0" ;;
        "neovim") echo "0.8" ;;
        "homebrew") echo "4.0" ;;
        *) echo "0.0.0" ;;
    esac
}

get_recommended_version() {
    case "$1" in
        "macos_major") echo "13" ;;     # macOS Ventura (13.0)
        "zsh") echo "5.9" ;;
        "tmux") echo "3.3" ;;
        "neovim") echo "0.9" ;;
        "homebrew") echo "4.1" ;;
        *) echo "0.0.0" ;;
    esac
}

get_tool_compatibility() {
    case "$1" in
        # Terminal emulators
        "alacritty:min_macos") echo "10.15" ;;
        "kitty:min_macos") echo "10.15" ;;
        "wezterm:min_macos") echo "10.15" ;;
        
        # Window managers
        "aerospace:min_macos") echo "13.0" ;;
        "yabai:min_macos") echo "11.0" ;;
        "skhd:min_macos") echo "10.15" ;;
        
        # Development tools
        "gh:min_macos") echo "10.15" ;;
        "docker:min_macos") echo "10.15" ;;
        "kubectl:min_macos") echo "10.15" ;;
        
        # Architecture specific
        "aerospace:arch") echo "arm64,x86_64" ;;
        "yabai:arch") echo "arm64,x86_64" ;;
        "docker:arch") echo "arm64,x86_64" ;;
        
        *) echo "" ;;
    esac
}

# Get system information
get_system_info() {
    print_header "System Information"
    
    # macOS version
    MACOS_VERSION=$(sw_vers -productVersion)
    MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)
    MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d. -f2)
    
    # Architecture
    ARCHITECTURE=$(uname -m)
    
    # Shell version
    local shell_output
    shell_output=$($SHELL --version 2>/dev/null | head -n1)
    SHELL_VERSION=$(echo "$shell_output" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
    [[ -z "$SHELL_VERSION" ]] && SHELL_VERSION="unknown"
    
    # Homebrew version (if installed)
    if command -v brew &> /dev/null; then
        local brew_output
        brew_output=$(brew --version 2>/dev/null | head -n1)
        HOMEBREW_VERSION=$(echo "$brew_output" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
        [[ -z "$HOMEBREW_VERSION" ]] && HOMEBREW_VERSION="unknown"
    fi
    
    echo "macOS Version: $MACOS_VERSION"
    echo "Architecture: $ARCHITECTURE"
    echo "Default Shell: $SHELL ($SHELL_VERSION)"
    [[ -n "$HOMEBREW_VERSION" ]] && echo "Homebrew: $HOMEBREW_VERSION"
    
    # System details (with timeout to avoid hanging)
    local hardware_info
    # shellcheck disable=SC2034  # Variable assigned but not used
    local memory_info
    
    if hardware_info=$(timeout 5s system_profiler SPHardwareDataType 2>/dev/null); then
        echo "Hardware: $(echo "$hardware_info" | grep "Model Name" | cut -d: -f2 | xargs || echo "Unknown")"
        echo "Memory: $(echo "$hardware_info" | grep "Memory" | cut -d: -f2 | xargs || echo "Unknown")"
    else
        echo "Hardware: Unable to detect (system_profiler timeout)"
        echo "Memory: Unable to detect (system_profiler timeout)"
    fi
}

# Check macOS version compatibility
check_macos_compatibility() {
    print_header "macOS Compatibility"
    
    local min_major
    min_major="$(get_min_version "macos_major")"
    local rec_major
    rec_major="$(get_recommended_version "macos_major")"
    
    if [[ "$MACOS_MAJOR" -lt "$min_major" ]]; then
        print_error "macOS $MACOS_VERSION is not supported"
        print_info "Minimum required: macOS $min_major.0"
        print_info "Recommended: macOS $rec_major.0+"
        return 1
    elif [[ "$MACOS_MAJOR" -lt "$rec_major" ]]; then
        print_warning "macOS $MACOS_VERSION is supported but not recommended"
        print_info "Recommended: macOS $rec_major.0+ for best experience"
    else
        print_success "macOS $MACOS_VERSION is fully supported"
    fi
    
    # Architecture-specific warnings
    case "$ARCHITECTURE" in
        "arm64")
            print_success "Apple Silicon (M1/M2/M3) architecture detected"
            ;;
        "x86_64")
            print_warning "Intel architecture detected"
            print_info "Some tools may have better performance on Apple Silicon"
            ;;
        *)
            print_warning "Unknown architecture: $ARCHITECTURE"
            ;;
    esac
}

# Check shell compatibility
check_shell_compatibility() {
    print_header "Shell Compatibility"
    
    # Check if zsh is available and version
    if command -v zsh &> /dev/null; then
        local zsh_version
        zsh_version=$(zsh --version | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
        local min_zsh
        min_zsh="$(get_min_version "zsh")"
        
        if version_compare "$zsh_version" "$min_zsh"; then
            print_success "Zsh $zsh_version is compatible"
        else
            print_warning "Zsh $zsh_version is below recommended version $min_zsh"
        fi
    else
        print_error "Zsh is not installed"
        print_info "Install with: brew install zsh"
    fi
    
    # Check default shell
    if [[ "$SHELL" == *"zsh"* ]]; then
        print_success "Zsh is the default shell"
    else
        print_warning "Default shell is not zsh: $SHELL"
        print_info "Change with: chsh -s $(which zsh)"
    fi
}

# Check Homebrew compatibility
check_homebrew_compatibility() {
    print_header "Homebrew Compatibility"
    
    if command -v brew &> /dev/null; then
        local min_brew
        min_brew="$(get_min_version "homebrew")"
        
        if version_compare "$HOMEBREW_VERSION" "$min_brew"; then
            print_success "Homebrew $HOMEBREW_VERSION is compatible"
        else
            print_warning "Homebrew $HOMEBREW_VERSION is below recommended version $min_brew"
            print_info "Update with: brew update"
        fi
        
        # Check Homebrew installation location
        local brew_prefix
        brew_prefix=$(brew --prefix)
        case "$ARCHITECTURE" in
            "arm64")
                if [[ "$brew_prefix" == "/opt/homebrew" ]]; then
                    print_success "Homebrew installed in correct location for Apple Silicon"
                else
                    print_warning "Homebrew not in expected location (/opt/homebrew)"
                fi
                ;;
            "x86_64")
                if [[ "$brew_prefix" == "/usr/local" ]]; then
                    print_success "Homebrew installed in correct location for Intel"
                else
                    print_warning "Homebrew not in expected location (/usr/local)"
                fi
                ;;
        esac
    else
        print_error "Homebrew is not installed"
        print_info "Install from: https://brew.sh"
    fi
}

# Check tool-specific compatibility
check_tool_compatibility() {
    print_header "Tool Compatibility"
    
    local tools_to_check=("alacritty" "aerospace" "yabai" "docker" "gh")
    
    for tool in "${tools_to_check[@]}"; do
        local min_macos_lookup="${tool}:min_macos"
        local arch_lookup="${tool}:arch"
        
        local min_macos
        min_macos="$(get_tool_compatibility "$min_macos_lookup")"
        if [[ -n "$min_macos" ]]; then
            
            if version_compare "$MACOS_VERSION" "$min_macos"; then
                print_success "$tool: Compatible with macOS $MACOS_VERSION"
            else
                print_warning "$tool: Requires macOS $min_macos+ (current: $MACOS_VERSION)"
            fi
        fi
        
        local supported_archs
        supported_archs="$(get_tool_compatibility "$arch_lookup")"
        if [[ -n "$supported_archs" ]]; then
            if [[ "$supported_archs" == *"$ARCHITECTURE"* ]]; then
                print_success "$tool: Compatible with $ARCHITECTURE architecture"
            else
                print_warning "$tool: May not be optimized for $ARCHITECTURE"
            fi
        fi
    done
}

# Check development environment
check_development_environment() {
    print_header "Development Environment"
    
    # Check Xcode Command Line Tools
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools installed"
    else
        print_error "Xcode Command Line Tools not installed"
        print_info "Install with: xcode-select --install"
    fi
    
    # Check Git
    if command -v git &> /dev/null; then
        local git_version
        git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')
        print_success "Git $git_version is available"
    else
        print_error "Git is not installed"
    fi
    
    # Check common development tools
    local dev_tools=("curl" "wget" "rsync" "ssh")
    for tool in "${dev_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_success "$tool is available"
        else
            print_warning "$tool is not installed"
        fi
    done
}

# Check for known issues
check_known_issues() {
    print_header "Known Issues Check"
    
    # macOS Sequoia (15.0+) specific issues
    if [[ "$MACOS_MAJOR" -ge 15 ]]; then
        print_info "macOS Sequoia detected - checking for known issues:"
        
        # Check for Gatekeeper issues
        print_info "  - Some unsigned binaries may require manual approval"
        print_info "  - Window management permissions may need explicit granting"
        
        # Check System Integrity Protection
        local sip_status
        sip_status=$(csrutil status 2>/dev/null | grep -o "enabled\|disabled" || echo "unknown")
        if [[ "$sip_status" == "enabled" ]]; then
            print_info "  - SIP is enabled (recommended, but may limit some tools)"
        fi
    fi
    
    # Architecture-specific issues
    if [[ "$ARCHITECTURE" == "arm64" ]]; then
        print_info "Apple Silicon specific considerations:"
        print_info "  - Some tools may run under Rosetta 2 translation"
        print_info "  - Docker containers may need --platform specification"
    fi
    
    # Version-specific warnings
    case "$MACOS_MAJOR" in
        "12")
            print_warning "macOS Monterey: Some window management features limited"
            ;;
        "13")
            print_info "macOS Ventura: Excellent compatibility"
            ;;
        "14")
            print_info "macOS Sonoma: Excellent compatibility"
            ;;
        *)
            if [[ "$MACOS_MAJOR" -gt 14 ]]; then
                print_info "Newer macOS version: Most features should work"
            fi
            ;;
    esac
}

# Version comparison helper
version_compare() {
    local version1="${1:-0.0.0}"
    local version2="${2:-0.0.0}"
    
    # Handle empty versions
    [[ -z "$version1" ]] && version1="0.0.0"
    [[ -z "$version2" ]] && version2="0.0.0"
    
    # Convert versions to comparable numbers, handling missing parts
    local v1_num
    v1_num=$(echo "$version1" | awk -F. '{printf "%d%03d%03d", ($1?$1:0), ($2?$2:0), ($3?$3:0)}')
    local v2_num
    v2_num=$(echo "$version2" | awk -F. '{printf "%d%03d%03d", ($1?$1:0), ($2?$2:0), ($3?$3:0)}')
    
    [[ "$v1_num" -ge "$v2_num" ]]
}

# Generate compatibility report
generate_report() {
    print_header "Compatibility Report"
    
    local report_file
    report_file="compatibility-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "macOS Dotfiles Compatibility Report"
        echo "Generated: $(date)"
        echo "=================================="
        echo
        echo "System Information:"
        echo "  macOS: $MACOS_VERSION"
        echo "  Architecture: $ARCHITECTURE"
        echo "  Shell: $SHELL ($SHELL_VERSION)"
        [[ -n "$HOMEBREW_VERSION" ]] && echo "  Homebrew: $HOMEBREW_VERSION"
        echo
        echo "Compatibility Status:"
        echo "  macOS: $(if [[ "$MACOS_MAJOR" -ge "$(get_min_version "macos_major")" ]]; then echo "✓ Compatible"; else echo "✗ Incompatible"; fi)"
        echo "  Shell: $(if command -v zsh &> /dev/null; then echo "✓ Zsh available"; else echo "✗ Zsh missing"; fi)"
        echo "  Homebrew: $(if command -v brew &> /dev/null; then echo "✓ Installed"; else echo "✗ Not installed"; fi)"
        echo "  Dev Tools: $(if xcode-select -p &> /dev/null 2>&1; then echo "✓ Installed"; else echo "✗ Not installed"; fi)"
    } > "$report_file"
    
    print_success "Compatibility report saved: $report_file"
}

# Show recommendations
show_recommendations() {
    print_header "Recommendations"
    
    echo "Based on your system configuration:"
    echo
    
    # Installation profile recommendation
    if [[ "$MACOS_MAJOR" -ge 14 && "$ARCHITECTURE" == "arm64" ]]; then
        print_success "Recommended profile: Full installation"
        echo "  Your system supports all features"
    elif [[ "$MACOS_MAJOR" -ge 13 ]]; then
        print_info "Recommended profile: Developer installation"
        echo "  Most features supported, some limitations possible"
    else
        print_warning "Recommended profile: Minimal installation"
        echo "  Limited feature support on older macOS versions"
    fi
    
    echo
    echo "Installation command:"
    if [[ "$MACOS_MAJOR" -ge 14 ]]; then
        echo "  ./bin/setup-interactive.sh --full"
    elif [[ "$MACOS_MAJOR" -ge 13 ]]; then
        echo "  ./bin/setup-interactive.sh --developer"
    else
        echo "  ./bin/setup-interactive.sh --minimal"
    fi
}

# Show help
show_help() {
    cat << EOF
macOS Compatibility Checker

Usage: $0 [options]

Options:
  -h, --help          Show this help message
  --system            Check system information only
  --macos             Check macOS compatibility only
  --tools             Check tool compatibility only
  --report            Generate compatibility report
  --recommendations   Show installation recommendations

This script checks system compatibility for dotfiles installation,
including macOS version, architecture, and required tools.
EOF
}

# Main function
main() {
    local check_system=true
    local check_macos=true
    local check_shell=true
    local check_homebrew=true
    local check_tools=true
    local check_dev=true
    local check_issues=true
    local show_recs=true
    local generate_rep=false
    
    case "${1:-}" in
        "--system")
            check_macos=false
            check_shell=false
            check_homebrew=false
            check_tools=false
            check_dev=false
            check_issues=false
            show_recs=false
            ;;
        "--macos")
            check_system=true
            check_shell=false
            check_homebrew=false
            check_tools=false
            check_dev=false
            check_issues=false
            show_recs=false
            ;;
        "--tools")
            check_system=false
            check_macos=false
            check_shell=false
            check_homebrew=false
            check_dev=false
            check_issues=false
            show_recs=false
            ;;
        "--report")
            generate_rep=true
            ;;
        "--recommendations")
            check_macos=false
            check_shell=false
            check_homebrew=false
            check_tools=false
            check_dev=false
            check_issues=false
            ;;
        "-h"|"--help")
            show_help
            exit 0
            ;;
    esac
    
    echo -e "${BLUE}macOS Compatibility Checker${NC}"
    echo "============================"
    
    # Get system info for display if requested
    if [[ "$check_system" == true ]]; then
        get_system_info
    fi
    
    # Silently gather system info if needed by other checks
    if [[ "$check_tools" == true ]] || [[ "$check_macos" == true ]] || [[ "$show_recs" == true ]]; then
        if [[ "$check_system" == false ]]; then
            # Gather system info silently (without header)
            MACOS_VERSION=$(sw_vers -productVersion)
            MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)
            # shellcheck disable=SC2034  # Variable assigned but potentially used elsewhere
            MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d. -f2)
            ARCHITECTURE=$(uname -m)
            
            local shell_output
            shell_output=$($SHELL --version 2>/dev/null | head -n1)
            SHELL_VERSION=$(echo "$shell_output" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
            [[ -z "$SHELL_VERSION" ]] && SHELL_VERSION="unknown"
            
            if command -v brew &> /dev/null; then
                local brew_output
                brew_output=$(brew --version 2>/dev/null | head -n1)
                HOMEBREW_VERSION=$(echo "$brew_output" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
                [[ -z "$HOMEBREW_VERSION" ]] && HOMEBREW_VERSION="unknown"
            fi
        fi
    fi
    
    if [[ "$check_macos" == true ]]; then
        check_macos_compatibility
    fi
    
    if [[ "$check_shell" == true ]]; then
        check_shell_compatibility
    fi
    
    if [[ "$check_homebrew" == true ]]; then
        check_homebrew_compatibility
    fi
    
    if [[ "$check_tools" == true ]]; then
        check_tool_compatibility
    fi
    
    if [[ "$check_dev" == true ]]; then
        check_development_environment
    fi
    
    if [[ "$check_issues" == true ]]; then
        check_known_issues
    fi
    
    if [[ "$generate_rep" == true ]]; then
        generate_report
    fi
    
    if [[ "$show_recs" == true ]]; then
        show_recommendations
    fi
    
    echo
    print_success "Compatibility check completed"
    print_info "Run with --report to generate a detailed report"
}

main "$@"