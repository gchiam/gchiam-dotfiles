# vim: set ft=zsh:
# Environment-specific Configuration
# Sources modular configuration files for a cleaner and more maintainable setup.

# Source modular configuration files
for file in "${ZDOTDIR:-$HOME/.config/zsh}/detect-env.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/performance.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/os.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/terminal.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/plugins.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/git-ssh.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/git-worktree-helper.zsh" \
            "${ZDOTDIR:-$HOME/.config/zsh}/utils.zsh"; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done

# History options (moved from .zshrc)
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY          # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_ALL_DUPS      # Remove all earlier duplicate lines
setopt HIST_IGNORE_SPACE         # Don't record lines starting with space
setopt HIST_REDUCE_BLANKS        # Remove extra blanks from commands
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt HIST_VERIFY               # Show command before executing from history

# Work-specific configurations
if [[ "$ZSH_ENV_WORK" == true ]]; then
    # Work-specific aliases
    if [[ -f "${ZDOTDIR:-$HOME/.config/zsh}/work-aliases.zsh" ]]; then
        source "${ZDOTDIR:-$HOME/.config/zsh}/work-aliases.zsh"
    fi
    
    # Work-specific functions
    if [[ -f "${ZDOTDIR:-$HOME/.config/zsh}/work-functions.zsh" ]]; then
        source "${ZDOTDIR:-$HOME/.config/zsh}/work-functions.zsh"
    fi
    
    # Work proxy settings (if needed)
    if [[ -f "$HOME/.work_proxy" ]]; then
        source "$HOME/.work_proxy"
    fi
fi

# Initialize environment-specific configurations
init_environment() {
    load_env_plugins

    # Note: vi mode is enabled in keybindings.zsh
    # zsh-vi-mode plugin will override if it loads successfully

    # Setup git and ssh configurations directly (no lazy loading needed)
    setup_git_config
    setup_ssh_config
    setup_performance_monitoring
}

# Auto-initialize on source
init_environment
