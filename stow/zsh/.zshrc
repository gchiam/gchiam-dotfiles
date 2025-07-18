# Zsh Configuration
# vim: set ft=zsh:

# Safe sourcing function
safe_source() {
    [[ -r "$1" ]] && source "$1"
}

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY          # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_ALL_DUPS      # Remove all earlier duplicate lines
setopt HIST_IGNORE_SPACE         # Don't record lines starting with space
setopt HIST_REDUCE_BLANKS        # Remove extra blanks from commands
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt HIST_VERIFY               # Show command before executing from history

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

# Optimized completion initialization
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
autoload -U +X bashcompinit && bashcompinit

# PATH configuration
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="$HOME/bin:${BREW_PREFIX:-/opt/homebrew}/bin:/usr/local/bin:$PATH"

# Safe sourcing of configuration files
safe_source "$HOME/.bash_path"      # Only source once (was duplicated)
safe_source "$HOME/.bash_exports"
safe_source "$HOME/.bash_aliases"
safe_source "$HOME/.bash_local"

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

# Vi-mode configuration
zvm_config() {
    # jeffreytse/zsh-vi-mode
    ZVM_INIT_MODE=sourcing
    ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
    ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
    # Always starting with insert mode for each command line
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

    # zsh-users/zsh-history-substring-search
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=black,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
}

function zvm_after_init() {
    safe_source "$HOME/.fzf.zsh"

    bindkey '^[OA' history-substring-search-up   # Up
    bindkey '^[[A' history-substring-search-up   # Up

    bindkey '^[OB' history-substring-search-down # Down
    bindkey '^[[B' history-substring-search-down # Down

    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
}

# Better word boundaries
autoload -Uz select-word-style
select-word-style bash

# Brew completions
if command -v brew >/dev/null; then
    fpath=("${BREW_PREFIX:-$(brew --prefix)}/share/zsh/site-functions" $fpath)
fi

# Plugin management with antidote
if command -v antidote >/dev/null; then
    # Cache plugin loading for better performance
    local antidote_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"
    if [[ ! -f "$antidote_plugins" ]] || [[ "$HOME/.config/antidote/.zsh_plugins.txt" -nt "$antidote_plugins" ]]; then
        source "${BREW_PREFIX:-$(brew --prefix)}/share/antidote/antidote.zsh"
        antidote bundle < "$HOME/.config/antidote/.zsh_plugins.txt" > "$antidote_plugins"
    fi
    source "$antidote_plugins"
fi

# Command completions (with error handling)
command -v cicd >/dev/null && source <(cicd completion zsh) 2>/dev/null && compdef _cicd cicd
command -v zetup >/dev/null && source <(zetup completion zsh) 2>/dev/null
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)" 2>/dev/null
command -v uvx >/dev/null && eval "$(uvx --generate-shell-completion zsh)" 2>/dev/null

# Completion styling
zstyle ':plugin:ez-compinit' 'compstyle' 'zshzoo'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Directory colors
if [[ "$OSTYPE" == darwin* ]]; then
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
fi

# Gradle completion (with error handling)
if command -v antidote >/dev/null; then
    local gradle_completion
    gradle_completion="$(antidote path gradle/gradle-completion 2>/dev/null)/_gradle"
    [[ -f "$gradle_completion" ]] && source "$gradle_completion" 1>&2 2>/dev/null
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
