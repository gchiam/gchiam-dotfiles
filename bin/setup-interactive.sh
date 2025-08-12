#!/bin/bash
set -euo pipefail

# Interactive Dotfiles Setup Script
# Provides selective installation with backup functionality

# Configuration
DOTFILES_SOURCE="${DOTFILES_SOURCE:-$HOME/projects/gchiam-dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
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

# Configuration categories with descriptions
declare -A CATEGORIES=(
    ["essential"]="Core tools (git, zsh, tmux)"
    ["editors"]="Text editors (neovim)"
    ["terminals"]="Terminal emulators (alacritty, kitty, wezterm)"
    ["window-mgmt"]="Window management (aerospace, yabai)"
    ["development"]="Development tools (gh-dash, starship)"
    ["theming"]="Theming and appearance (bat, borders)"
    ["work"]="Work-specific tools (JetBrains)"
    ["experimental"]="Experimental configurations"
)

# Map stow directories to categories
declare -A STOW_CATEGORIES=(
    # Essential
    ["zsh"]="essential"
    ["tmux"]="essential" 
    ["bash"]="essential"
    ["antidote"]="essential"
    
    # Editors
    ["nvim"]="editors"
    
    # Terminals
    ["alacritty"]="terminals"
    ["kitty"]="terminals"
    ["wezterm"]="terminals"
    
    # Window Management
    ["aerospace"]="window-mgmt"
    ["yabai"]="window-mgmt"
    ["skhd"]="window-mgmt"
    ["karabiner"]="window-mgmt"
    
    # Development
    ["gh-dash"]="development"
    ["starship"]="development"
    ["oh-my-posh"]="development"
    ["tig"]="development"
    ["custom-bin"]="development"
    
    # Theming
    ["bat"]="theming"
    ["borders"]="theming"
    ["zsh-fsh"]="theming"
    ["bottom"]="theming"
    
    # Work
    ["JetBrains"]="work"
    
    # Package Management
    ["brew"]="essential"
    
    # Input/System
    ["input"]="window-mgmt"
    ["autoraise"]="window-mgmt"
    
    # Shell alternatives
    ["fish"]="experimental"
    ["ohmyzsh"]="experimental"
    
    # Monitoring
    ["k9s"]="development"
)

# Get available stow directories
get_stow_directories() {
    local stow_dir="$DOTFILES_SOURCE/stow"
    if [[ -d "$stow_dir" ]]; then
        find "$stow_dir" -maxdepth 1 -type d -not -path "$stow_dir" -exec basename {} \; | sort
    fi
}

# Create backup of existing configurations
create_backup() {
    local configs_to_backup=()
    
    print_header "Creating Backup"
    
    # Check for existing configurations
    while IFS= read -r stow_dir; do
        local config_path
        case "$stow_dir" in
            "zsh") config_path="$HOME/.zshrc" ;;
            "nvim") config_path="$HOME/.config/nvim" ;;
            "tmux") config_path="$HOME/.tmux.conf" ;;
            "alacritty") config_path="$HOME/.config/alacritty" ;;
            "kitty") config_path="$HOME/.config/kitty" ;;
            "wezterm") config_path="$HOME/.config/wezterm" ;;
            "aerospace") config_path="$HOME/.config/aerospace" ;;
            *) continue ;;
        esac
        
        if [[ -e "$config_path" ]] && [[ ! -L "$config_path" ]]; then
            configs_to_backup+=("$config_path")
        fi
    done < <(get_stow_directories)
    
    if [[ ${#configs_to_backup[@]} -eq 0 ]]; then
        print_info "No existing configurations found to backup"
        return 0
    fi
    
    echo "Found existing configurations:"
    for config in "${configs_to_backup[@]}"; do
        echo "  - $config"
    done
    
    echo
    read -p "Create backup before proceeding? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_warning "Skipping backup - existing files may be overwritten"
        return 0
    fi
    
    mkdir -p "$BACKUP_DIR"
    
    for config in "${configs_to_backup[@]}"; do
        local backup_path="$BACKUP_DIR$(dirname "$config")"
        mkdir -p "$backup_path"
        
        if cp -r "$config" "$backup_path/" 2>/dev/null; then
            print_success "Backed up $config"
        else
            print_warning "Failed to backup $config"
        fi
    done
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Select installation profile
select_profile() {
    print_header "Installation Profiles"
    
    echo "1) Full Installation - All configurations"
    echo "2) Minimal - Essential tools only" 
    echo "3) Developer - Essential + development tools"
    echo "4) Custom - Choose individual categories"
    echo
    
    while true; do
        read -p "Select profile (1-4): " -n 1 -r
        echo
        
        case $REPLY in
            1) echo "full"; return ;;
            2) echo "minimal"; return ;;
            3) echo "developer"; return ;;
            4) echo "custom"; return ;;
            *) echo "Please select 1-4" ;;
        esac
    done
}

# Select categories for custom installation
select_categories() {
    local selected_categories=()
    
    print_header "Select Configuration Categories"
    
    for category in "${!CATEGORIES[@]}"; do
        echo "Install ${CATEGORIES[$category]}? (y/N)"
        read -p "  $category: " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            selected_categories+=("$category")
        fi
    done
    
    printf '%s\n' "${selected_categories[@]}"
}

# Get stow directories based on profile/categories
get_selected_stow_dirs() {
    local profile="$1"
    shift
    local categories=("$@")
    
    case "$profile" in
        "full")
            get_stow_directories
            ;;
        "minimal")
            while IFS= read -r dir; do
                if [[ "${STOW_CATEGORIES[$dir]:-}" == "essential" ]]; then
                    echo "$dir"
                fi
            done < <(get_stow_directories)
            ;;
        "developer")
            while IFS= read -r dir; do
                local cat="${STOW_CATEGORIES[$dir]:-}"
                if [[ "$cat" == "essential" || "$cat" == "development" || "$cat" == "editors" ]]; then
                    echo "$dir"
                fi
            done < <(get_stow_directories)
            ;;
        "custom")
            while IFS= read -r dir; do
                local cat="${STOW_CATEGORIES[$dir]:-}"
                for selected_cat in "${categories[@]}"; do
                    if [[ "$cat" == "$selected_cat" ]]; then
                        echo "$dir"
                        break
                    fi
                done
            done < <(get_stow_directories)
            ;;
    esac
}

# Install selected configurations
install_configurations() {
    local selected_dirs=("$@")
    
    print_header "Installing Configurations"
    
    if [[ ${#selected_dirs[@]} -eq 0 ]]; then
        print_warning "No configurations selected for installation"
        return 0
    fi
    
    echo "Selected configurations:"
    for dir in "${selected_dirs[@]}"; do
        local category="${STOW_CATEGORIES[$dir]:-unknown}"
        echo "  - $dir ($category)"
    done
    
    echo
    read -p "Proceed with installation? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Installation cancelled"
        return 0
    fi
    
    local stow_dir="$DOTFILES_SOURCE/stow"
    local failed_dirs=()
    
    cd "$stow_dir"
    
    for dir in "${selected_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            print_warning "Directory $dir not found, skipping"
            continue
        fi
        
        echo "Installing $dir..."
        if stow -v --dir="$stow_dir" --target="$HOME" --restow "$dir" 2>/dev/null; then
            print_success "Installed $dir"
        else
            print_error "Failed to install $dir"
            failed_dirs+=("$dir")
        fi
    done
    
    cd - > /dev/null
    
    if [[ ${#failed_dirs[@]} -gt 0 ]]; then
        print_warning "Failed to install: ${failed_dirs[*]}"
        print_info "Run with --verbose for more details"
    fi
}

# Post-installation tasks
post_install_tasks() {
    print_header "Post-Installation Tasks"
    
    # Rebuild bat cache for themes (if bat is available)
    if command -v bat &> /dev/null; then
        echo "Rebuilding bat cache..."
        if bat cache --build 2>/dev/null; then
            print_success "Rebuilt bat cache"
        else
            print_warning "Failed to rebuild bat cache"
        fi
    fi
    
    # Configure ZSH Fast Syntax Highlighting theme (if available)
    if command -v fast-theme &> /dev/null; then
        echo "Setting fast-syntax-highlighting theme..."
        if fast-theme XDG:catppuccin-frappe 2>/dev/null; then
            print_success "Set fast-syntax-highlighting theme"
        else
            print_warning "Failed to set fast-syntax-highlighting theme"
        fi
    fi
    
    # Generate Fleet properties file
    if [[ -d "$HOME/.config/JetBrains" ]]; then
        echo "Generating Fleet configuration..."
        echo "fleet.config.path=${HOME}/.config/JetBrains/Fleet/" > ~/fleet.properties
        print_success "Generated Fleet configuration"
    fi
    
    # Setup fzf directory structure
    echo "Setting up fzf directory..."
    mkdir -p "$HOME/.fzf"
    if [[ -f "$HOME/.fzf.zsh" ]]; then
        ln -snvf "$HOME/.fzf.zsh" "$HOME/.fzf/fzf.zsh" 2>/dev/null
        print_success "Set up fzf directory"
    fi
}

# Show help
show_help() {
    cat << EOF
Interactive Dotfiles Setup Script

Usage: $0 [options]

Options:
  -h, --help      Show this help message
  -f, --full      Skip prompts and install everything
  -m, --minimal   Skip prompts and install minimal profile
  -d, --developer Skip prompts and install developer profile
  --no-backup     Skip backup creation
  --dry-run       Show what would be installed without installing

This script provides an interactive way to install dotfiles configurations
with backup functionality and selective installation options.
EOF
}

# Main function
main() {
    local skip_prompts=false
    local profile=""
    local create_backup_flag=true
    local dry_run=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -f|--full)
                skip_prompts=true
                profile="full"
                shift
                ;;
            -m|--minimal)
                skip_prompts=true
                profile="minimal"
                shift
                ;;
            -d|--developer)
                skip_prompts=true
                profile="developer"
                shift
                ;;
            --no-backup)
                create_backup_flag=false
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    echo -e "${BLUE}Interactive Dotfiles Setup${NC}"
    echo "=============================="
    
    # Verify source directory exists
    if [[ ! -d "$DOTFILES_SOURCE" ]]; then
        print_error "Source directory $DOTFILES_SOURCE does not exist"
        exit 1
    fi
    
    # Create symlink to dotfiles directory
    print_info "Creating symlink: $DOTFILES_DIR → $DOTFILES_SOURCE"
    if [[ -L "$DOTFILES_DIR" ]] || [[ ! -e "$DOTFILES_DIR" ]]; then
        ln -snvf "$DOTFILES_SOURCE" "$DOTFILES_DIR"
        print_success "Created dotfiles symlink"
    else
        print_warning "$DOTFILES_DIR exists and is not a symlink. Skipping."
    fi
    
    # Verify and install stow if needed
    if ! command -v stow &> /dev/null; then
        print_info "stow not found. Installing via Homebrew..."
        if command -v brew &> /dev/null; then
            brew install stow
            print_success "Installed stow"
        else
            print_error "Neither stow nor brew is available. Please install stow manually."
            exit 1
        fi
    fi
    
    # Create backup if requested
    if [[ "$create_backup_flag" == true ]]; then
        create_backup
    fi
    
    # Select installation profile
    if [[ "$skip_prompts" == false ]]; then
        profile=$(select_profile)
    fi
    
    # Get selected categories for custom profile
    local selected_categories=()
    if [[ "$profile" == "custom" ]]; then
        readarray -t selected_categories < <(select_categories)
    fi
    
    # Get stow directories to install
    readarray -t selected_dirs < <(get_selected_stow_dirs "$profile" "${selected_categories[@]}")
    
    if [[ "$dry_run" == true ]]; then
        print_header "Dry Run - Would Install"
        for dir in "${selected_dirs[@]}"; do
            local category="${STOW_CATEGORIES[$dir]:-unknown}"
            echo "  - $dir ($category)"
        done
        exit 0
    fi
    
    # Install configurations
    install_configurations "${selected_dirs[@]}"
    
    # Run post-installation tasks
    post_install_tasks
    
    print_success "Dotfiles setup completed successfully!"
    
    if [[ "$create_backup_flag" == true ]] && [[ -d "$BACKUP_DIR" ]]; then
        print_info "Backup available at: $BACKUP_DIR"
    fi
    
    print_info "Run 'bin/health-check.sh' to validate your installation"
}

# Run main function with all arguments
main "$@"