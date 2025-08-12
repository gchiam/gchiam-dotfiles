# Zsh Configuration
# vim: set ft=zsh:

# Safe sourcing function
safe_source() {
    [[ -r "$1" ]] && source "$1"
}

# Initialize completion system early to prevent compdef errors
autoload -Uz compinit
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

# FZF integration (also loaded in keybindings.zsh for vi-mode compatibility)
safe_source "$HOME/.fzf.zsh"

# Language environment
export LANG=en_US.UTF-8

# Lazy load NVM for better performance
nvm() {
    unset -f nvm node npm
    export NVM_DIR="$HOME/.nvm"
    if command -v brew >/dev/null; then
        local nvm_dir="${BREW_PREFIX:-$(brew --prefix)}/opt/nvm"
        [[ -s "$nvm_dir/nvm.sh" ]] && source "$nvm_dir/nvm.sh"
        [[ -s "$nvm_dir/etc/bash_completion.d/nvm" ]] && source "$nvm_dir/etc/bash_completion.d/nvm"
    else
        [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    fi
    nvm "$@"
}
# Create lazy-loaded aliases for common commands
node() { nvm >/dev/null 2>&1; command node "$@"; }
npm() { nvm >/dev/null 2>&1; command npm "$@"; }

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

# Prompt initialization (keep at end)
if command -v oh-my-posh >/dev/null && [[ -f "$HOME/.config/oh-my-posh/oh-my-posh.toml" ]]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
fi
