#!/bin/bash
set -euo pipefail

# Environment Profile Setup Script
# Manages different configuration profiles (work, personal, etc.)

# Configuration
DOTFILES_SOURCE="${DOTFILES_SOURCE:-$HOME/projects/gchiam-dotfiles}"
PROFILES_DIR="$DOTFILES_SOURCE/profiles"
CURRENT_PROFILE_FILE="$HOME/.dotfiles-profile"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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

# Profile definitions
declare -A PROFILES=(
    ["personal"]="Personal development setup"
    ["work"]="Work environment with corporate tools"
    ["minimal"]="Minimal configuration for servers/containers"
    ["experimental"]="Bleeding edge configurations for testing"
)

# Profile-specific configurations
declare -A PROFILE_CONFIGS=(
    # Personal profile
    ["personal:gitconfig"]=".gitconfig.personal"
    ["personal:brewfile"]=".Brewfile"
    ["personal:ssh_config"]=".ssh/config.personal"
    ["personal:zshrc_local"]=".zshrc.personal"
    
    # Work profile  
    ["work:gitconfig"]=".gitconfig.work"
    ["work:brewfile"]=".Brewfile.zendesk"
    ["work:ssh_config"]=".ssh/config.work"
    ["work:zshrc_local"]=".zshrc.work"
    
    # Minimal profile
    ["minimal:gitconfig"]=".gitconfig.minimal"
    ["minimal:brewfile"]=".Brewfile.minimal"
    ["minimal:zshrc_local"]=".zshrc.minimal"
    
    # Experimental profile
    ["experimental:gitconfig"]=".gitconfig.experimental"
    ["experimental:brewfile"]=".Brewfile.experimental"
    ["experimental:zshrc_local"]=".zshrc.experimental"
)

# Profile-specific stow directories to include/exclude
declare -A PROFILE_STOW_INCLUDE=(
    ["personal"]="zsh tmux nvim alacritty kitty wezterm aerospace gh-dash starship bat borders custom-bin antidote brew"
    ["work"]="zsh tmux nvim alacritty aerospace gh-dash starship bat borders custom-bin antidote brew JetBrains"
    ["minimal"]="zsh tmux bash custom-bin brew"
    ["experimental"]="zsh tmux nvim alacritty kitty wezterm aerospace yabai skhd gh-dash starship oh-my-posh bat borders zsh-fsh custom-bin antidote brew fish"
)

declare -A PROFILE_STOW_EXCLUDE=(
    ["personal"]="JetBrains"
    ["work"]="kitty wezterm yabai skhd oh-my-posh zsh-fsh fish"
    ["minimal"]="nvim alacritty kitty wezterm aerospace yabai skhd JetBrains gh-dash starship oh-my-posh bat borders zsh-fsh antidote fish"
    ["experimental"]=""
)

# Get current profile
get_current_profile() {
    if [[ -f "$CURRENT_PROFILE_FILE" ]]; then
        cat "$CURRENT_PROFILE_FILE"
    else
        echo "none"
    fi
}

# Set current profile
set_current_profile() {
    local profile="$1"
    echo "$profile" > "$CURRENT_PROFILE_FILE"
    print_success "Set current profile to: $profile"
}

# List available profiles
list_profiles() {
    print_header "Available Profiles"
    
    local current_profile
    current_profile=$(get_current_profile)
    
    for profile in "${!PROFILES[@]}"; do
        local marker=""
        if [[ "$profile" == "$current_profile" ]]; then
            marker=" ${GREEN}(current)${NC}"
        fi
        echo -e "  ${CYAN}$profile${NC}: ${PROFILES[$profile]}$marker"
    done
}

# Create profile-specific configuration files
create_profile_configs() {
    local profile="$1"
    
    print_header "Creating Profile Configurations"
    
    mkdir -p "$PROFILES_DIR/$profile"
    
    # Create profile-specific git config
    if [[ ! -f "$PROFILES_DIR/$profile/.gitconfig" ]]; then
        case "$profile" in
            "work")
                cat > "$PROFILES_DIR/$profile/.gitconfig" << EOF
[user]
    name = Your Name
    email = your.name@company.com

[core]
    autocrlf = input
    
[push]
    default = simple
    
[pull]
    rebase = true

# Work-specific aliases
[alias]
    work-log = log --oneline --graph --decorate --since="1 week ago"
    
# Include main git config
[include]
    path = ~/.gitconfig.main
EOF
                ;;
            "personal")
                cat > "$PROFILES_DIR/$profile/.gitconfig" << EOF
[user]
    name = Your Name
    email = your.personal@email.com

[core]
    autocrlf = input
    
[push]
    default = simple
    
[pull]
    rebase = true

# Personal aliases
[alias]
    personal-stats = shortlog -sn --since="1 month ago"
    
# Include main git config
[include]
    path = ~/.gitconfig.main
EOF
                ;;
            "minimal")
                cat > "$PROFILES_DIR/$profile/.gitconfig" << EOF
[user]
    name = Your Name
    email = user@example.com

[core]
    autocrlf = input
    editor = vim
    
[push]
    default = simple
EOF
                ;;
        esac
        print_success "Created git config for $profile"
    fi
    
    # Create profile-specific zsh config
    if [[ ! -f "$PROFILES_DIR/$profile/.zshrc.local" ]]; then
        case "$profile" in
            "work")
                cat > "$PROFILES_DIR/$profile/.zshrc.local" << 'EOF'
# Work-specific ZSH configuration

# Work-specific aliases
alias work-vpn='echo "Connect to work VPN"'
alias work-ssh='ssh work-server'

# Work-specific environment variables
export COMPANY_ENV="production"
export KUBECTL_CONTEXT="work-cluster"

# Work-specific functions
work_project() {
    cd "$HOME/work/projects/$1" || echo "Project $1 not found"
}

# Load work-specific secrets (if available)
[[ -f "$HOME/.work-secrets" ]] && source "$HOME/.work-secrets"
EOF
                ;;
            "personal")
                cat > "$PROFILES_DIR/$profile/.zshrc.local" << 'EOF'
# Personal ZSH configuration

# Personal aliases
alias personal-backup='rsync -av --progress'
alias personal-server='ssh personal-server'

# Personal environment variables
export PERSONAL_PROJECTS="$HOME/projects"

# Personal functions
personal_project() {
    cd "$HOME/projects/$1" || echo "Project $1 not found"
}

# Load personal dotfiles functions
[[ -f "$HOME/.personal-functions" ]] && source "$HOME/.personal-functions"
EOF
                ;;
            "minimal")
                cat > "$PROFILES_DIR/$profile/.zshrc.local" << 'EOF'
# Minimal ZSH configuration

# Essential aliases only
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Minimal prompt
export PS1='%n@%m:%~$ '
EOF
                ;;
        esac
        print_success "Created zsh config for $profile"
    fi
    
    # Create profile-specific Brewfile
    if [[ ! -f "$PROFILES_DIR/$profile/.Brewfile" ]]; then
        case "$profile" in
            "work")
                # Copy main Brewfile and add work-specific packages
                cp "$DOTFILES_SOURCE/stow/brew/.Brewfile.zendesk" "$PROFILES_DIR/$profile/.Brewfile" 2>/dev/null || \
                cat > "$PROFILES_DIR/$profile/.Brewfile" << 'EOF'
# Work-specific Homebrew packages

# Essential tools
brew 'git'
brew 'stow'
brew 'zsh'

# Work development tools
brew 'kubectl'
brew 'helm'
brew 'docker'
brew 'aws-cli'

# Communication
cask 'slack'
cask 'zoom'
cask 'microsoft-teams'

# Development
cask 'visual-studio-code'
cask 'jetbrains-toolbox'
EOF
                ;;
            "minimal")
                cat > "$PROFILES_DIR/$profile/.Brewfile" << 'EOF'
# Minimal Homebrew packages

# Essential tools only
brew 'git'
brew 'stow'
brew 'zsh'
brew 'tmux'
brew 'vim'
EOF
                ;;
        esac
        print_success "Created Brewfile for $profile"
    fi
}

# Apply profile configuration
apply_profile() {
    local profile="$1"
    
    if [[ ! -v "PROFILES[$profile]" ]]; then
        print_error "Unknown profile: $profile"
        return 1
    fi
    
    print_header "Applying Profile: $profile"
    
    # Create profile configs if they don't exist
    create_profile_configs "$profile"
    
    # Link profile-specific configurations
    local profile_dir="$PROFILES_DIR/$profile"
    
    if [[ -f "$profile_dir/.gitconfig" ]]; then
        ln -sf "$profile_dir/.gitconfig" "$HOME/.gitconfig.profile"
        print_success "Linked git configuration"
    fi
    
    if [[ -f "$profile_dir/.zshrc.local" ]]; then
        ln -sf "$profile_dir/.zshrc.local" "$HOME/.zshrc.local"
        print_success "Linked zsh local configuration"
    fi
    
    if [[ -f "$profile_dir/.Brewfile" ]]; then
        ln -sf "$profile_dir/.Brewfile" "$HOME/.Brewfile.profile"
        print_success "Linked Brewfile"
    fi
    
    # Apply stow configurations based on profile
    local stow_dirs="${PROFILE_STOW_INCLUDE[$profile]:-}"
    if [[ -n "$stow_dirs" ]]; then
        print_info "Installing stow packages for $profile profile..."
        
        cd "$DOTFILES_SOURCE/stow"
        for dir in $stow_dirs; do
            if [[ -d "$dir" ]]; then
                echo "Stowing $dir..."
                stow -R -d "$DOTFILES_SOURCE/stow" -t "$HOME" "$dir" 2>/dev/null || \
                print_warning "Failed to stow $dir"
            fi
        done
        cd - > /dev/null
    fi
    
    # Set as current profile
    set_current_profile "$profile"
    
    print_success "Profile '$profile' applied successfully!"
    print_info "Restart your shell to apply changes: exec zsh"
}

# Remove profile application
remove_profile() {
    print_header "Removing Profile Application"
    
    # Remove profile-specific links
    [[ -L "$HOME/.gitconfig.profile" ]] && rm "$HOME/.gitconfig.profile"
    [[ -L "$HOME/.zshrc.local" ]] && rm "$HOME/.zshrc.local"
    [[ -L "$HOME/.Brewfile.profile" ]] && rm "$HOME/.Brewfile.profile"
    
    # Remove current profile marker
    [[ -f "$CURRENT_PROFILE_FILE" ]] && rm "$CURRENT_PROFILE_FILE"
    
    print_success "Profile application removed"
}

# Show profile status
show_status() {
    print_header "Profile Status"
    
    local current_profile
    current_profile=$(get_current_profile)
    
    echo "Current profile: $current_profile"
    
    if [[ "$current_profile" != "none" ]]; then
        echo "Description: ${PROFILES[$current_profile]:-Unknown}"
        
        echo -e "\nActive configurations:"
        [[ -L "$HOME/.gitconfig.profile" ]] && echo "  - Git config: $(readlink "$HOME/.gitconfig.profile")"
        [[ -L "$HOME/.zshrc.local" ]] && echo "  - Zsh local: $(readlink "$HOME/.zshrc.local")"  
        [[ -L "$HOME/.Brewfile.profile" ]] && echo "  - Brewfile: $(readlink "$HOME/.Brewfile.profile")"
    fi
}

# Interactive profile selection
interactive_select() {
    print_header "Select Profile"
    
    local profiles=($(printf '%s\n' "${!PROFILES[@]}" | sort))
    
    echo "Available profiles:"
    for i in "${!profiles[@]}"; do
        local profile="${profiles[$i]}"
        echo "$((i+1))) $profile - ${PROFILES[$profile]}"
    done
    
    echo
    while true; do
        read -p "Select profile (1-${#profiles[@]}): " -r
        
        if [[ "$REPLY" =~ ^[0-9]+$ ]] && [[ "$REPLY" -ge 1 ]] && [[ "$REPLY" -le "${#profiles[@]}" ]]; then
            local selected_profile="${profiles[$((REPLY-1))]}"
            apply_profile "$selected_profile"
            break
        else
            echo "Please select a number between 1 and ${#profiles[@]}"
        fi
    done
}

# Show help
show_help() {
    cat << EOF
Environment Profile Setup Script

Usage: $0 [command] [options]

Commands:
    list                List available profiles
    status              Show current profile status
    apply <profile>     Apply a specific profile
    remove              Remove current profile application
    interactive         Interactively select and apply a profile
    create <profile>    Create a new custom profile

Options:
    -h, --help          Show this help message

Available profiles:
$(for profile in "${!PROFILES[@]}"; do echo "    $profile - ${PROFILES[$profile]}"; done)

Examples:
    $0 list
    $0 apply work
    $0 status
    $0 interactive
EOF
}

# Main function
main() {
    case "${1:-}" in
        "list")
            list_profiles
            ;;
        "status")
            show_status
            ;;
        "apply")
            if [[ -z "${2:-}" ]]; then
                print_error "Profile name required"
                show_help
                exit 1
            fi
            apply_profile "$2"
            ;;
        "remove")
            remove_profile
            ;;
        "interactive")
            interactive_select
            ;;
        "create")
            if [[ -z "${2:-}" ]]; then
                print_error "Profile name required"
                exit 1
            fi
            create_profile_configs "$2"
            ;;
        "-h"|"--help"|"help")
            show_help
            ;;
        "")
            show_status
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"