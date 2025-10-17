#!/bin/bash
set -euo pipefail

# Dotfiles Health Check Script
# Validates that configurations are properly installed and working

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNED=0

# Helper functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    PASSED=$((PASSED + 1))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    FAILED=$((FAILED + 1))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    WARNED=$((WARNED + 1))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Main validation functions
check_basic_tools() {
    echo -e "\n${BLUE}=== Basic Tools ===${NC}"
    
    if command -v stow &> /dev/null; then
        check_pass "GNU Stow is installed"
    else
        check_fail "GNU Stow is not installed"
    fi
    
    if command -v brew &> /dev/null; then
        check_pass "Homebrew is installed"
        if brew bundle check --file="${HOME}/.Brewfile" &> /dev/null; then
            check_pass "All Brewfile packages are installed"
        else
            check_warn "Some Brewfile packages are missing (run: brew bundle install)"
        fi
    else
        check_warn "Homebrew is not installed"
    fi
    
    if command -v git &> /dev/null; then
        check_pass "Git is installed"
    else
        check_fail "Git is not installed"
    fi
}

check_shell_setup() {
    echo -e "\n${BLUE}=== Shell Setup ===${NC}"
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        check_pass "Zsh is the default shell"
        
        if [[ -f "${ZDOTDIR:-$HOME/.config/zsh}/.zshrc" ]]; then
            check_pass "Zsh configuration exists"
            
            if grep -q "antidote" "${ZDOTDIR:-$HOME/.config/zsh}/.zshrc" 2>/dev/null; then
                check_pass "Antidote plugin manager is configured"
            else
                check_warn "Antidote plugin manager not found in .zshrc"
            fi
        else
            check_fail "Zsh configuration (.zshrc) not found"
        fi
        
        if command -v antidote &> /dev/null; then
            check_pass "Antidote is available"
        else
            check_warn "Antidote is not installed"
        fi
    else
        check_warn "Zsh is not the default shell (current: $SHELL)"
    fi
}

check_editor_setup() {
    echo -e "\n${BLUE}=== Editor Setup ===${NC}"
    
    if command -v nvim &> /dev/null; then
        check_pass "Neovim is installed"
        
        if [[ -d "${HOME}/.config/nvim" ]]; then
            check_pass "Neovim configuration directory exists"
        else
            check_fail "Neovim configuration directory not found"
        fi
    else
        check_warn "Neovim is not installed"
    fi
    
    if command -v vim &> /dev/null; then
        check_pass "Vim is available"
    else
        check_warn "Vim is not installed"
    fi
}

check_terminal_setup() {
    echo -e "\n${BLUE}=== Terminal Setup ===${NC}"
    
    terminals=("alacritty" "kitty" "wezterm")
    terminal_found=false
    
    for term in "${terminals[@]}"; do
        if command -v "$term" &> /dev/null; then
            check_pass "$term is installed"
            terminal_found=true
            
            case $term in
                "alacritty")
                    if [[ -f "${HOME}/.config/alacritty/alacritty.toml" ]] || [[ -f "${HOME}/.config/alacritty/alacritty.yml" ]]; then
                        check_pass "Alacritty configuration exists"
                    else
                        check_warn "Alacritty configuration not found"
                    fi
                    ;;
                "kitty")
                    if [[ -f "${HOME}/.config/kitty/kitty.conf" ]]; then
                        check_pass "Kitty configuration exists"
                    else
                        check_warn "Kitty configuration not found"
                    fi
                    ;;
                "wezterm")
                    if [[ -f "${HOME}/.config/wezterm/wezterm.lua" ]]; then
                        check_pass "WezTerm configuration exists"
                    else
                        check_warn "WezTerm configuration not found"
                    fi
                    ;;
            esac
        fi
    done
    
    if ! $terminal_found; then
        check_warn "No configured terminals found (alacritty, kitty, wezterm)"
    fi
}

check_window_manager() {
    echo -e "\n${BLUE}=== Window Management ===${NC}"
    
    if command -v aerospace &> /dev/null; then
        check_pass "AeroSpace is installed"
        
        if [[ -f "${HOME}/.config/aerospace/aerospace.toml" ]]; then
            check_pass "AeroSpace configuration exists"
        else
            check_warn "AeroSpace configuration not found"
        fi
    else
        check_warn "AeroSpace is not installed"
    fi
    
    if command -v yabai &> /dev/null; then
        check_info "Yabai is available (legacy)"
    fi
    
    if command -v skhd &> /dev/null; then
        check_info "skhd is available (legacy)"
    fi
}

check_development_tools() {
    echo -e "\n${BLUE}=== Development Tools ===${NC}"
    
    dev_tools=("gh" "git-delta" "bat" "eza" "fd" "fzf" "ripgrep")
    
    for tool in "${dev_tools[@]}"; do
        case $tool in
            "git-delta")
                if command -v delta &> /dev/null; then
                    check_pass "Delta (git-delta) is installed"
                else
                    check_warn "Delta (git-delta) is not installed"
                fi
                ;;
            "ripgrep")
                if command -v rg &> /dev/null; then
                    check_pass "Ripgrep is installed"
                else
                    check_warn "Ripgrep is not installed"
                fi
                ;;
            *)
                if command -v "$tool" &> /dev/null; then
                    check_pass "$tool is installed"
                else
                    check_warn "$tool is not installed"
                fi
                ;;
        esac
    done
}

check_dotfiles_structure() {
    echo -e "\n${BLUE}=== Dotfiles Structure ===${NC}"
    
    if [[ -L "${HOME}/dotfiles" ]]; then
        check_pass "Dotfiles symlink exists"
        
        target=$(readlink "${HOME}/dotfiles")
        if [[ -d "$target" ]]; then
            check_pass "Dotfiles target directory exists: $target"
        else
            check_fail "Dotfiles symlink target is broken: $target"
        fi
    else
        check_warn "Dotfiles symlink not found at ~/dotfiles"
    fi
    
    # Check for key stow directories
    stow_dirs=("zsh" "nvim" "tmux")
    for dir in "${stow_dirs[@]}"; do
        if [[ -d "${HOME}/dotfiles/stow/$dir" ]] || [[ -d "${HOME}/.dotfiles/stow/$dir" ]]; then
            check_pass "Stow directory '$dir' exists"
        else
            check_warn "Stow directory '$dir' not found"
        fi
    done
}

check_theme_setup() {
    echo -e "\n${BLUE}=== Theme Setup ===${NC}"
    
    if command -v bat &> /dev/null; then
        if bat --list-themes | grep -q "Catppuccin"; then
            check_pass "Catppuccin themes are available in bat"
        else
            check_warn "Catppuccin themes not found in bat (run: bat cache --build)"
        fi
    fi
    
    if command -v fast-theme &> /dev/null; then
        if [[ -f "${HOME}/.config/zsh-fsh/current_theme.zsh" ]]; then
            current_theme=$(cat "${HOME}/.config/zsh-fsh/current_theme.zsh" 2>/dev/null | grep -o 'catppuccin[^"]*' || echo "unknown")
            if [[ "$current_theme" == *"catppuccin"* ]]; then
                check_pass "Fast Syntax Highlighting uses Catppuccin theme"
            else
                check_warn "Fast Syntax Highlighting theme is not Catppuccin"
            fi
        else
            check_warn "Fast Syntax Highlighting theme not configured"
        fi
    fi
}

check_performance() {
    echo -e "\n${BLUE}=== Performance ===${NC}"
    
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        # Only check zsh startup time if we're in zsh
        startup_time=$(zsh -i -c 'exit' 2>&1 | tail -1 | grep -o '[0-9.]*s' || echo "unknown")
        if [[ "$startup_time" != "unknown" ]]; then
            check_info "Zsh startup time: $startup_time"
        fi
    fi
    
    if command -v tmux &> /dev/null; then
        if tmux list-sessions &> /dev/null; then
            check_info "Tmux server is running"
        else
            check_info "Tmux server is not running"
        fi
    fi
}

# Main execution
main() {
    echo -e "${BLUE}Dotfiles Health Check${NC}"
    echo "=============================="
    
    check_basic_tools
    check_shell_setup
    check_editor_setup
    check_terminal_setup
    check_window_manager
    check_development_tools
    check_dotfiles_structure
    check_theme_setup
    check_performance
    
    # Summary
    echo -e "\n${BLUE}=== Summary ===${NC}"
    echo -e "Passed: ${GREEN}$PASSED${NC}"
    echo -e "Warnings: ${YELLOW}$WARNED${NC}"
    echo -e "Failed: ${RED}$FAILED${NC}"
    
    if [[ $FAILED -gt 0 ]]; then
        echo -e "\n${RED}Some critical checks failed. Review the output above.${NC}"
        exit 1
    elif [[ $WARNED -gt 0 ]]; then
        echo -e "\n${YELLOW}Some optional components are missing. Consider installing them.${NC}"
        exit 0
    else
        echo -e "\n${GREEN}All checks passed! Your dotfiles are properly configured.${NC}"
        exit 0
    fi
}

# Show help
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "Dotfiles Health Check Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "This script validates that your dotfiles are properly installed and configured."
    echo "It checks for required tools, configurations, and provides recommendations."
    exit 0
fi

main "$@"