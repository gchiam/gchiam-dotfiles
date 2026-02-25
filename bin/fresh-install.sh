#!/bin/bash
set -e

# Fresh macOS Setup - One Command Installer
# Complete dotfiles setup for new macOS installations

# Source shared utility functions
# shellcheck source=bin/lib/utils.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib/utils.sh"

# Configuration
DOTFILES_REPO="https://github.com/gchiam/gchiam-dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$HOME/fresh-install-$(date +%Y%m%d-%H%M%S).log"

# Installation profile
INSTALL_PROFILE="interactive"
SKIP_CONFIRMATION=false
VERBOSE=false

# System requirements
MIN_MACOS_VERSION="12.0"
REQUIRED_TOOLS=("git" "curl")

# Progress tracking
TOTAL_STEPS=10
CURRENT_STEP=0

progress_step() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo -e "\n${PURPLE}[${CURRENT_STEP}/${TOTAL_STEPS}]${NC} $1"
}

# Logging
log() {
    echo "$(date): $1" >> "$LOG_FILE"
    [[ "$VERBOSE" == true ]] && echo "$1"
}

# Check system requirements
check_requirements() {
    progress_step "Checking System Requirements"
    
    # Check macOS version
    local macos_version
    macos_version=$(sw_vers -productVersion)
    local macos_major
    macos_major=$(echo "$macos_version" | cut -d. -f1)
    local min_major
    min_major=$(echo "$MIN_MACOS_VERSION" | cut -d. -f1)
    
    if [[ "$macos_major" -lt "$min_major" ]]; then
        print_error "macOS $macos_version is not supported"
        print_info "Minimum required: macOS $MIN_MACOS_VERSION"
        exit 1
    fi
    
    print_success "macOS $macos_version is supported"
    log "System check: macOS $macos_version OK"
    
    # Check architecture
    local arch
    arch=$(uname -m)
    print_info "Architecture: $arch"
    log "Architecture: $arch"
    
    # Check required tools
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            print_error "$tool is not installed"
            exit 1
        fi
        print_success "$tool is available"
    done
    
    # Check Xcode Command Line Tools
    if ! xcode-select -p &> /dev/null; then
        print_warning "Xcode Command Line Tools not installed"
        print_step "Installing Xcode Command Line Tools..."
        xcode-select --install
        
        echo "Please complete the Xcode Command Line Tools installation and re-run this script."
        exit 1
    fi
    
    print_success "System requirements met"
}

# Install Homebrew
install_homebrew() {
    progress_step "Installing Homebrew"
    
    if ensure_homebrew; then
        log "Homebrew: Installed successfully or already installed"
    else
        log "ERROR: Homebrew installation failed"
        exit 1
    fi
}

# Clone dotfiles repository
clone_dotfiles() {
    progress_step "Cloning Dotfiles Repository"
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        print_warning "Dotfiles directory already exists"
        
        if [[ "$SKIP_CONFIRMATION" != true ]]; then
            read -p "Remove existing directory and re-clone? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Using existing directory"
                return 0
            fi
        fi
        
        print_step "Backing up existing directory..."
        mv "$DOTFILES_DIR" "$BACKUP_DIR"
        print_success "Backup created: $BACKUP_DIR"
    fi
    
    print_step "Cloning repository..."
    
    if git clone --recurse-submodules "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        print_success "Repository cloned successfully"
        log "Repository: Cloned from $DOTFILES_REPO"
    else
        print_error "Failed to clone repository"
        log "ERROR: Repository clone failed"
        exit 1
    fi
    
    # Change to dotfiles directory
    cd "$DOTFILES_DIR"
    print_info "Changed to dotfiles directory"
}

# Check compatibility
check_compatibility() {
    progress_step "Checking Compatibility"
    
    if [[ -x "bin/check-compatibility.sh" ]]; then
        print_step "Running compatibility check..."
        
        if ./bin/check-compatibility.sh --system --macos; then
            print_success "Compatibility check passed"
            log "Compatibility: Check passed"
        else
            print_warning "Compatibility check found issues"
            log "WARNING: Compatibility check issues"
            
            if [[ "$SKIP_CONFIRMATION" != true ]]; then
                read -p "Continue anyway? (y/N): " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Installation cancelled"
                    exit 1
                fi
            fi
        fi
    else
        print_warning "Compatibility checker not found, skipping"
    fi
}

# Install essential packages
install_essentials() {
    progress_step "Installing Essential Packages"
    
    print_step "Installing core development tools..."
    
    # Essential packages for the dotfiles to work
    local essential_packages=(
        "git"
        "zsh"
        "stow"
        "tmux"
        "neovim"
        "fzf"
        "ripgrep"
        "bat"
        "eza"
        "gh"
    )
    
    for package in "${essential_packages[@]}"; do
        if brew list "$package" &> /dev/null; then
            print_info "$package already installed"
        else
            print_step "Installing $package..."
            if brew install "$package" >> "$LOG_FILE" 2>&1; then
                print_success "$package installed"
                log "Package: $package installed"
            else
                print_warning "Failed to install $package"
                log "WARNING: $package installation failed"
            fi
        fi
    done
}

# Setup shell
setup_shell() {
    progress_step "Setting Up Shell"
    
    # Check if zsh is the default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        print_step "Setting zsh as default shell..."
        
        # Add zsh to allowed shells if not present
        local zsh_path
        zsh_path=$(which zsh)
        if ! grep -q "$zsh_path" /etc/shells; then
            echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
        fi
        
        # Change default shell
        if chsh -s "$zsh_path"; then
            print_success "Default shell changed to zsh"
            log "Shell: Changed to zsh"
        else
            print_warning "Failed to change default shell"
            log "WARNING: Shell change failed"
        fi
    else
        print_success "Zsh is already the default shell"
    fi
}

# Run installation
run_installation() {
    progress_step "Running Installation"
    
    local install_script=""
    local install_args=""
    
    # Determine installation method
    case "$INSTALL_PROFILE" in
        "full")
            if [[ -x "bin/setup-interactive.sh" ]]; then
                install_script="./bin/setup-interactive.sh"
                install_args="--full --backup"
            else
                install_script="./bin/setup.sh"
            fi
            ;;
        "minimal")
            if [[ -x "bin/setup-interactive.sh" ]]; then
                install_script="./bin/setup-interactive.sh"
                install_args="--minimal --backup"
            else
                install_script="./bin/setup-stow.sh"
            fi
            ;;
        "developer")
            if [[ -x "bin/setup-interactive.sh" ]]; then
                install_script="./bin/setup-interactive.sh"
                install_args="--developer --backup"
            else
                install_script="./bin/setup.sh"
            fi
            ;;
        "interactive")
            if [[ -x "bin/setup-interactive.sh" ]]; then
                install_script="./bin/setup-interactive.sh"
                install_args="--backup"
            else
                install_script="./bin/setup.sh"
            fi
            ;;
        *)
            print_error "Unknown installation profile: $INSTALL_PROFILE"
            exit 1
            ;;
    esac
    
    if [[ ! -x "$install_script" ]]; then
        print_error "Installation script not found: $install_script"
        exit 1
    fi
    
    print_step "Running $install_script $install_args"
    
    if [[ "$SKIP_CONFIRMATION" == true ]]; then
        # Run non-interactively if possible
        if $install_script "$install_args" --yes >> "$LOG_FILE" 2>&1; then
            print_success "Installation completed"
            log "Installation: Completed successfully"
        else
            print_warning "Installation completed with warnings"
            log "WARNING: Installation had issues"
        fi
    else
        # Run interactively
        if $install_script "$install_args"; then
            print_success "Installation completed"
            log "Installation: Completed successfully"
        else
            print_warning "Installation completed with warnings"
            log "WARNING: Installation had issues"
        fi
    fi
}

# Install additional tools
install_additional_tools() {
    progress_step "Installing Additional Tools"
    
    # Check if generated Brewfile exists
    if [[ -f "$HOME/.Brewfile" ]]; then
        print_step "Installing packages from Brewfile..."
        
        if brew bundle --file="$HOME/.Brewfile" >> "$LOG_FILE" 2>&1; then
            print_success "Brewfile packages installed"
            log "Brewfile: Packages installed"
        else
            print_warning "Some Brewfile packages failed to install"
            log "WARNING: Brewfile installation issues"
        fi
    else
        print_info "No Brewfile found at $HOME/.Brewfile, skipping additional packages"
    fi
}

# Run health check
run_health_check() {
    progress_step "Running Health Check"
    
    if [[ -x "bin/health-check.sh" ]]; then
        print_step "Verifying installation..."
        
        if ./bin/health-check.sh >> "$LOG_FILE" 2>&1; then
            print_success "Health check passed"
            log "Health check: Passed"
        else
            print_warning "Health check found issues"
            log "WARNING: Health check issues"
            
            print_info "Review the health check output:"
            print_info "  ./bin/health-check.sh"
        fi
    else
        print_warning "Health check script not found"
    fi
}

# Setup automation
setup_automation() {
    progress_step "Setting Up Automation"
    
    if [[ -x "bin/auto-sync.sh" ]]; then
        print_step "Setting up auto-sync..."
        
        if ./bin/auto-sync.sh setup-automation >> "$LOG_FILE" 2>&1; then
            print_success "Auto-sync configured"
            log "Auto-sync: Configured"
        else
            print_warning "Failed to setup auto-sync"
            log "WARNING: Auto-sync setup failed"
        fi
    else
        print_info "Auto-sync script not available"
    fi
    
    print_info "Additional automation setup available:"
    print_info "  Auto-sync: ./bin/auto-sync.sh status"
    print_info "  Performance monitoring: ./bin/performance-monitor.sh"
}

# Final steps and recommendations
show_completion() {
    progress_step "Installation Complete!"
    
    print_success "Fresh macOS setup completed successfully!"
    
    echo
    print_header "Next Steps"
    
    echo "1. ${GREEN}Restart your terminal${NC} or run: exec zsh"
    echo "2. ${CYAN}Customize your configuration${NC}:"
    echo "   - Edit ~/.config/zsh/.zshrc.local for personal settings"
    echo "   - Modify git configuration: git config --global user.name 'Your Name'"
    echo "3. ${PURPLE}Optional improvements${NC}:"
    echo "   - Setup SSH keys: ssh-keygen -t ed25519 -C 'your.email@example.com'"
    echo "   - Configure Git signing: gh auth setup-git"
    echo "   - Install additional fonts from Font Book"
    
    echo
    print_header "Available Tools"
    
    echo "• ${CYAN}Health check${NC}: ./bin/health-check.sh"
    echo "• ${CYAN}Performance monitoring${NC}: ./bin/performance-monitor.sh"
    echo "• ${CYAN}Compatibility check${NC}: ./bin/check-compatibility.sh"
    echo "• ${CYAN}Auto-sync setup${NC}: ./bin/auto-sync.sh setup-automation"
    echo "• ${CYAN}Profile management${NC}: ./bin/setup-profile.sh"
    
    echo
    print_header "Documentation"
    
    echo "• ${BLUE}Setup Guide${NC}: docs/setup-guide.md"
    echo "• ${BLUE}Troubleshooting${NC}: docs/troubleshooting.md"
    echo "• ${BLUE}All references${NC}: README.md"
    
    echo
    print_info "Installation log saved: $LOG_FILE"
    
    if [[ -d "$BACKUP_DIR" ]]; then
        print_info "Backup created: $BACKUP_DIR"
    fi
    
    echo
    print_success "Welcome to your new development environment! 🎉"
}

# Error handling
cleanup_on_error() {
    print_error "Installation failed!"
    print_info "Check the log file: $LOG_FILE"
    
    if [[ -d "$BACKUP_DIR" ]]; then
        print_info "Backup available: $BACKUP_DIR"
    fi
    
    print_info "For help, see: docs/troubleshooting.md"
}

trap cleanup_on_error ERR

# Show help
show_help() {
    cat << EOF
Fresh macOS Setup - One Command Installer

Usage: $0 [options]

Options:
    --profile TYPE       Installation profile: full, minimal, developer, interactive (default)
    --repo URL          Custom repository URL (default: $DOTFILES_REPO)
    --dir PATH          Installation directory (default: $DOTFILES_DIR)
    --skip-confirm      Skip confirmation prompts
    --verbose           Verbose logging output
    -h, --help          Show this help message

Profiles:
    full               Complete installation with all tools and configurations
    minimal            Essential tools only (shell, editor, git)
    developer          Development-focused setup
    interactive        Let user choose components interactively

Examples:
    $0                          # Interactive installation
    $0 --profile full           # Full installation
    $0 --profile minimal        # Minimal installation
    $0 --skip-confirm --verbose # Automated with verbose output

This script will:
1. Check system requirements
2. Install Homebrew if needed
3. Clone the dotfiles repository
4. Run compatibility checks
5. Install essential packages
6. Setup zsh as default shell
7. Run the dotfiles installation
8. Install additional tools
9. Run health checks
10. Setup automation

For more information, visit: https://github.com/gchiam/gchiam-dotfiles
EOF
}

# Main function
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --profile)
                INSTALL_PROFILE="$2"
                shift 2
                ;;
            --repo)
                DOTFILES_REPO="$2"
                shift 2
                ;;
            --dir)
                DOTFILES_DIR="$2"
                shift 2
                ;;
            --skip-confirm)
                SKIP_CONFIRMATION=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Welcome message
    echo -e "${BLUE}🚀 Fresh macOS Setup${NC}"
    echo "===================="
    echo
    echo "This script will set up your complete development environment."
    echo "Profile: $INSTALL_PROFILE"
    echo "Repository: $DOTFILES_REPO"
    echo "Installation directory: $DOTFILES_DIR"
    echo
    
    if [[ "$SKIP_CONFIRMATION" != true ]]; then
        read -p "Continue with installation? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Create log file
    echo "Fresh macOS Setup Log - $(date)" > "$LOG_FILE"
    log "Starting fresh installation with profile: $INSTALL_PROFILE"
    
    # Run installation steps
    check_requirements
    install_homebrew
    clone_dotfiles
    check_compatibility
    install_essentials
    setup_shell
    run_installation
    install_additional_tools
    run_health_check
    setup_automation
    show_completion
    
    log "Installation completed successfully"
}

main "$@"