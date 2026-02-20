# Zsh Configuration
# vim: set ft=zsh:

# Performance monitoring: record startup time if enabled and EPOCHREALTIME available
if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]]; then
    if [[ -n "$EPOCHREALTIME" ]]; then
        ZSH_STARTUP_START="$EPOCHREALTIME"
    else
        echo "Warning: Performance monitoring requires zsh 5.0.2+ (EPOCHREALTIME not available)" >&2
        export ZSH_PERFORMANCE_MONITORING=false
    fi
fi

# Safe sourcing function
safe_source() {
    [[ -r "$1" ]] && source "$1"
}

# asdf completions (must be before compinit)
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# Initialize completion system for compdef support
autoload -Uz compinit
compinit -C


# History configuration handled by environment.zsh

# Directory navigation improvements
setopt AUTO_CD                   # Change directory without cd
setopt AUTO_PUSHD                # Push directories to stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack

# Globbing improvements
setopt EXTENDED_GLOB             # Extended globbing patterns
setopt GLOB_DOTS                 # Include dotfiles in glob patterns

# Performance: Cache brew prefix
if [[ -z "$BREW_PREFIX" ]] && command -v brew >/dev/null; then
    export BREW_PREFIX="$(brew --prefix)"
fi


# PATH configuration
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="$HOME/bin:${BREW_PREFIX:-/opt/homebrew}/bin:/usr/local/bin:$PATH"

# Safe sourcing of configuration files
safe_source "$HOME/.bash_path"      # Only source once (was duplicated)
safe_source "$HOME/.bash_exports"
safe_source "$HOME/.bash_local"

# Load modular zsh configuration
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/environment.zsh"  # Load first for environment detection
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions.zsh"
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.zsh"
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions.zsh"
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/keybindings.zsh"

# FZF integration: Loaded here for standard functionality
# Note: FZF is also loaded in keybindings.zsh:zvm_after_init() to ensure
# compatibility with zsh-vi-mode plugin, which overrides key bindings.
# This dual loading ensures FZF works whether vi-mode plugin loads or not.
safe_source "$HOME/.fzf.zsh"

# Language environment
export LANG=en_US.UTF-8

# Load NVM immediately
export NVM_DIR="$HOME/.nvm"
if command -v brew >/dev/null; then
    local nvm_dir="${BREW_PREFIX:-$(brew --prefix)}/opt/nvm"
    [[ -s "$nvm_dir/nvm.sh" ]] && source "$nvm_dir/nvm.sh"
else
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
fi




# asdf version manager (lazy loaded for performance)
if [[ -f "${BREW_PREFIX:-/opt/homebrew}/opt/asdf/libexec/asdf.sh" ]]; then
    asdf() {
        unset -f asdf java javac
        source "${BREW_PREFIX:-/opt/homebrew}/opt/asdf/libexec/asdf.sh"
        [[ -f "${HOME}/.asdf/plugins/java/set-java-home.zsh" ]] && \
            source "${HOME}/.asdf/plugins/java/set-java-home.zsh"
        asdf "$@"
    }
    java() { asdf >/dev/null; command java "$@"; }
    javac() { asdf >/dev/null; command javac "$@"; }
fi

# Vi-mode configuration moved to keybindings.zsh

# Better word boundaries
autoload -Uz select-word-style
select-word-style bash


# Plugin management handled by environment.zsh


# Load profile-specific configuration
safe_source "$HOME/.zshrc.local"
safe_source "$HOME/.zshrc.profile"

# Load git profile configuration
if [[ -f "$HOME/.gitconfig.profile" ]]; then
    export GIT_CONFIG_GLOBAL="$HOME/.gitconfig.profile"
fi

# Prompt initialization (keep at end)
if command -v oh-my-posh >/dev/null && [[ -f "$HOME/.config/oh-my-posh/oh-my-posh.toml" ]]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
    # Pin config path to prevent fallback to default theme after cache invalidation
    _omp_config_path="$HOME/.config/oh-my-posh/oh-my-posh.toml"
    function _omp_get_prompt() {
      local type=$1
      local args=("${@[2,-1]}")
      $_omp_executable print $type \
        --config="$_omp_config_path" \
        --save-cache \
        --shell=zsh \
        --shell-version=$ZSH_VERSION \
        --status=$_omp_status \
        --pipestatus="${_omp_pipestatus[*]}" \
        --no-status=$_omp_no_status \
        --execution-time=$_omp_execution_time \
        --job-count=$_omp_job_count \
        --stack-count=$_omp_stack_count \
        --terminal-width="${COLUMNS-0}" \
        ${args[@]}
    }
fi



# Performance monitoring: calculate and export startup time if enabled
if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]] && [[ -n "$ZSH_STARTUP_START" ]]; then
    export ZSH_STARTUP_TIME="$(( EPOCHREALTIME - ZSH_STARTUP_START ))"
fi
