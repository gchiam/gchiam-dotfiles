#!/bin/bash
# Shared utility functions for dotfiles scripts

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
    echo -e "${RED}✗${NC} $1" >&2
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_step() {
    echo -e "${PURPLE}➤${NC} $1"
}

# Get XDG compliant path with standard defaults
# Usage: get_xdg_path <TYPE> [FALLBACK]
# Types: CONFIG, DATA, CACHE, STATE
get_xdg_path() {
    local type="${1:-}"
    local fallback="${2:-}"

    case "$type" in
        CONFIG)
            echo "${XDG_CONFIG_HOME:-$HOME/.config}"
            ;;
        DATA)
            echo "${XDG_DATA_HOME:-$HOME/.local/share}"
            ;;
        CACHE)
            echo "${XDG_CACHE_HOME:-$HOME/.cache}"
            ;;
        STATE)
            echo "${XDG_STATE_HOME:-$HOME/.local/state}"
            ;;
        *)
            if [[ -n "$fallback" ]]; then
                echo "$fallback"
            else
                return 1
            fi
            ;;
    esac
}

# Ensure directory exists for a given file path
# Usage: ensure_dir <FILE_PATH>
ensure_dir() {
    local file_path="$1"
    local dir_path
    dir_path=$(dirname "$file_path")
    mkdir -p "$dir_path"
}

# Verify dotfiles directory exists
# Usage: verify_dotfiles_dir <DIR_PATH>
verify_dotfiles_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        print_error "Dotfiles directory $dir does not exist"
        return 1
    fi
    return 0
}

# Ensure Homebrew is installed and in PATH
# Usage: ensure_homebrew
ensure_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew already installed"
        return 0
    fi
    
    print_step "Installing Homebrew..."
    
    # Download and install Homebrew
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        print_success "Homebrew installed successfully"
    else
        print_error "Failed to install Homebrew"
        return 1
    fi
    
    # Add Homebrew to PATH
    local arch
    arch=$(uname -m)
    local brew_path=""
    
    if [[ "$arch" == "arm64" ]]; then
        brew_path="/opt/homebrew/bin"
    else
        brew_path="/usr/local/bin"
    fi
    
    if [[ ":$PATH:" != *":$brew_path:"* ]]; then
        export PATH="$brew_path:$PATH"
        print_info "Added Homebrew to PATH"
    fi
    
    # Verify installation
    if command -v brew &> /dev/null; then
        print_success "Homebrew is ready"
        brew --version | head -1
    else
        print_error "Homebrew installation verification failed"
        return 1
    fi
}
