#!/usr/bin/env bats

load "helpers/test_helper"

# Source the script under test
source "${PROJECT_ROOT}/bin/setup-interactive.sh"

setup() {
    common_setup
    
    # Redefine the associative array in the test environment
    # This is needed because BATS seems to lose global associative arrays when sourcing
    declare -gA STOW_CATEGORIES
    STOW_CATEGORIES["zsh"]="essential"
    STOW_CATEGORIES["tmux"]="essential"
    STOW_CATEGORIES["bash"]="essential"
    STOW_CATEGORIES["antidote"]="essential"
    STOW_CATEGORIES["nvim"]="editors"
    STOW_CATEGORIES["alacritty"]="terminals"
    STOW_CATEGORIES["kitty"]="terminals"
    STOW_CATEGORIES["wezterm"]="terminals"
    STOW_CATEGORIES["aerospace"]="window-mgmt"
    STOW_CATEGORIES["yabai"]="window-mgmt"
    STOW_CATEGORIES["skhd"]="window-mgmt"
    STOW_CATEGORIES["karabiner"]="window-mgmt"
    STOW_CATEGORIES["gh-dash"]="development"
    STOW_CATEGORIES["starship"]="development"
    STOW_CATEGORIES["oh-my-posh"]="development"
    STOW_CATEGORIES["tig"]="development"
    STOW_CATEGORIES["custom-bin"]="development"
    STOW_CATEGORIES["bat"]="theming"
    STOW_CATEGORIES["borders"]="theming"
    STOW_CATEGORIES["zsh-fsh"]="theming"
    STOW_CATEGORIES["bottom"]="theming"
    STOW_CATEGORIES["JetBrains"]="work"
    STOW_CATEGORIES["brew"]="essential"
    STOW_CATEGORIES["input"]="window-mgmt"
    STOW_CATEGORIES["autoraise"]="window-mgmt"
    STOW_CATEGORIES["fish"]="experimental"
    STOW_CATEGORIES["ohmyzsh"]="experimental"
    STOW_CATEGORIES["k9s"]="development"

    # Mock get_stow_directories
    get_stow_directories() {
        printf '%s\n' "zsh" "tmux" "nvim" "alacritty" "gh-dash" "bat" "aerospace" "JetBrains" "brew" "k9s"
    }
}

teardown() {
    common_teardown
}

@test "get_selected_stow_dirs: minimal profile returns only essential tools" {
    run get_selected_stow_dirs "minimal"
    assert_success
    assert_line "zsh"
    assert_line "tmux"
    assert_line "brew"
    refute_line "nvim"
    refute_line "gh-dash"
}

@test "get_selected_stow_dirs: developer profile returns essential, development, and editors" {
    run get_selected_stow_dirs "developer"
    assert_success
    assert_line "zsh"
    assert_line "nvim"
    assert_line "gh-dash"
    assert_line "k9s"
    refute_line "bat"
}

@test "get_selected_stow_dirs: full profile returns all directories" {
    run get_selected_stow_dirs "full"
    assert_success
    assert_line "zsh"
    assert_line "nvim"
    assert_line "aerospace"
    assert_line "bat"
}
