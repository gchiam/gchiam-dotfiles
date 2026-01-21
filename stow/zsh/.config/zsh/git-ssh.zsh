# shellcheck disable=SC2148
# vim: set ft=zsh:
# Git and SSH Configuration
# Configures git and ssh based on the detected environment.

# Git configuration based on environment
setup_git_config() {
    if [[ "$ZSH_ENV_WORK" == true ]]; then
        # Work git configuration
        if [[ -f "$HOME/.gitconfig-work" ]]; then
            git config --global include.path ~/.gitconfig-work
        fi
    else
        # Personal git configuration
        if [[ -f "$HOME/.gitconfig-personal" ]]; then
            git config --global include.path ~/.gitconfig-personal
        fi
    fi
}

# SSH configuration based on environment
setup_ssh_config() {
    if [[ "$ZSH_ENV_WORK" == true ]]; then
        # Use work SSH config if available
        if [[ -f "$HOME/.ssh/config_work" ]]; then
            export SSH_CONFIG_FILE="$HOME/.ssh/config_work"
        fi
    fi
}
