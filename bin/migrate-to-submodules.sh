#!/usr/bin/env bash
set -e

# Submodule Migration Script
# Converts external dependencies to Git submodules

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    GREEN=''
    YELLOW=''
    BLUE=''
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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Submodule configurations
declare -A SUBMODULES=(
    ["external/catppuccin/alacritty"]="https://github.com/catppuccin/alacritty.git"
    ["external/catppuccin/bat"]="https://github.com/catppuccin/bat.git"
    ["external/catppuccin/delta"]="https://github.com/catppuccin/delta.git"
    ["external/catppuccin/gh-dash"]="https://github.com/catppuccin/gh-dash.git"
    ["external/catppuccin/k9s"]="https://github.com/catppuccin/k9s.git"
    ["external/catppuccin/zsh-fsh"]="https://github.com/catppuccin/zsh-fast-syntax-highlighting.git"
    ["external/tmux-plugins/tpm"]="https://github.com/tmux-plugins/tpm.git"
)

migrate_to_submodules() {
    print_header "Migrating External Dependencies to Submodules"
    
    print_warning "This operation will:"
    echo "  - Remove existing external directories"
    echo "  - Add them as Git submodules"  
    echo "  - Require internet connection to clone repositories"
    echo
    
    read -p "Continue with submodule migration? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Submodule migration cancelled"
        exit 0
    fi
    
    # Create backup of current external directory
    local backup_dir
    backup_dir="external-backup-$(date +%Y%m%d-%H%M%S)"
    cp -r external "$backup_dir"
    print_success "Created backup: $backup_dir"
    
    # Remove existing directories and add as submodules
    for path in "${!SUBMODULES[@]}"; do
        local url="${SUBMODULES[$path]}"
        
        if [[ -d "$path" ]]; then
            print_info "Migrating $path to submodule..."
            
            # Remove existing directory from git and clean up git cache
            git rm -r "$path" 2>/dev/null || true
            rm -rf "$path"
            
            # Clean up any cached git directory references
            git rm --cached "$path" 2>/dev/null || true
            
            # Remove any git modules references
            if [[ -f .git/modules/"$(basename "$path")"/config ]]; then
                rm -rf ".git/modules/$(basename "$path")"
            fi
            
            # Add as submodule with force flag to handle any remaining conflicts
            if git submodule add --force "$url" "$path"; then
                print_success "Added $path as submodule"
            else
                print_warning "Failed to add $path as submodule"
            fi
        else
            print_warning "$path does not exist, skipping"
        fi
    done
    
    # Initialize and update submodules
    git submodule update --init --recursive
    
    print_success "Submodule migration completed"
    print_info "Backup available at: $backup_dir"
    print_info "Run 'git submodule update --remote' to update submodules"
}

# Show current external dependencies
show_dependencies() {
    print_header "Current External Dependencies"
    
    echo "Directories that could become submodules:"
    for path in "${!SUBMODULES[@]}"; do
        if [[ -d "$path" ]]; then
            local size
            size=$(du -sh "$path" | cut -f1)
            echo "  - $path ($size) -> ${SUBMODULES[$path]}"
        else
            echo "  - $path (missing) -> ${SUBMODULES[$path]}"
        fi
    done
}

case "${1:-}" in
    "migrate")
        migrate_to_submodules
        ;;
    "show"|"list")
        show_dependencies
        ;;
    *)
        echo "Usage: $0 {migrate|show}"
        echo ""
        echo "Commands:"
        echo "  migrate  Convert external dependencies to submodules"
        echo "  show     Show current external dependencies"
        ;;
esac
