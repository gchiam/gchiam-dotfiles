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

# Initialize completion system early to prevent compdef errors
autoload -Uz compinit

# Set stack limit to prevent deep recursion in completions
ulimit -s 8192

# shellcheck disable=SC1072,SC1073,SC1036 # Zsh-specific glob patterns
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Load menu selection widget
zmodload zsh/complist

# Enable bash completion compatibility
autoload -U +X bashcompinit && bashcompinit

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

# Completion initialization handled by completion.zsh

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
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completion.zsh"
safe_source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.zsh"
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
    [[ -s "$nvm_dir/etc/bash_completion.d/nvm" ]] && source "$nvm_dir/etc/bash_completion.d/nvm"
else
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

# Lazy load kubectl completions on first use
kubectl() {
    unfunction kubectl
    if command -v kubectl >/dev/null; then
        source <(kubectl completion zsh 2>/dev/null)
        compdef __start_kubectl k
    fi
    command kubectl "$@"
}

# Lazy load docker completions on first use  
docker() {
    unfunction docker
    if command -v docker >/dev/null && [[ -f /usr/local/etc/bash_completion.d/docker ]]; then
        source /usr/local/etc/bash_completion.d/docker
    fi
    command docker "$@"
}

# Lazy load terraform completions on first use
terraform() {
    unfunction terraform
    if command -v terraform >/dev/null; then
        autoload -U +X bashcompinit && bashcompinit
        complete -o nospace -C terraform terraform
    fi
    command terraform "$@"
}

# Lazy load helm completions on first use
helm() {
    unfunction helm
    if command -v helm >/dev/null; then
        source <(helm completion zsh 2>/dev/null)
    fi
    command helm "$@"
}

# Lazy load aws cli completions on first use
aws() {
    unfunction aws
    if command -v aws >/dev/null; then
        complete -C aws_completer aws
    fi
    command aws "$@"
}

# Java environment (jenv)
if [[ -d "$HOME/.jenv" ]]; then
    export PATH="$HOME/.jenv/bin:$PATH"
    command -v jenv >/dev/null && eval "$(jenv init -)"
fi

# Vi-mode configuration moved to keybindings.zsh

# Better word boundaries
autoload -Uz select-word-style
select-word-style bash

# Brew completions handled by completion.zsh

# Plugin management handled by environment.zsh

# Command completions (with error handling)
command -v cicd >/dev/null && source <(cicd completion zsh) 2>/dev/null && compdef _cicd cicd
command -v zetup >/dev/null && source <(zetup completion zsh) 2>/dev/null
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)" 2>/dev/null
command -v uvx >/dev/null && eval "$(uvx --generate-shell-completion zsh)" 2>/dev/null

# Completion styling handled by completion.zsh

# Gradle completion (with error handling)
if command -v antidote >/dev/null; then
    local gradle_completion="$(antidote path gradle/gradle-completion 2>/dev/null)/_gradle"
    [[ -f "$gradle_completion" ]] && source "$gradle_completion" 2>/dev/null
fi

# SDKMAN initialization (lazy load could be added here too)
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    # Lazy load SDKMAN for better performance
    sdk() {
        unset -f sdk
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        sdk "$@"
    }
fi

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
fi

# Custom completions setup
if [[ -d "$HOME/.config/zsh/completions" ]]; then
    fpath=("$HOME/.config/zsh/completions" $fpath)
fi

# Load custom dotfiles completions
if [[ -f "$HOME/.config/zsh/completions/_dotfiles" ]]; then
    autoload -U _dotfiles
fi

# Completion system already initialized at top of file
# Additional completion styles are handled by completion.zsh

# Performance monitoring: calculate and export startup time if enabled
if [[ "$ZSH_PERFORMANCE_MONITORING" == true ]] && [[ -n "$ZSH_STARTUP_START" ]]; then
    export ZSH_STARTUP_TIME="$(( EPOCHREALTIME - ZSH_STARTUP_START ))"
fi
