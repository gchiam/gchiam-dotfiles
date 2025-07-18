# vim: set ft=zsh:
# Zsh Keybindings
# Custom key bindings for improved productivity

# Vi-mode configuration (for zsh-vi-mode plugin)
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
    # Load FZF after vi-mode is initialized
    [[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

    bindkey '^[OA' history-substring-search-up   # Up
    bindkey '^[[A' history-substring-search-up   # Up

    bindkey '^[OB' history-substring-search-down # Down
    bindkey '^[[B' history-substring-search-down # Down

    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
}

# Use emacs-style key bindings by default (works well with zsh-vi-mode plugin)
bindkey -e

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Line editing shortcuts
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^B' backward-char
bindkey '^F' forward-char
bindkey '^D' delete-char
bindkey '^H' backward-delete-char
bindkey '^W' backward-kill-word
bindkey '^K' kill-line
bindkey '^U' kill-whole-line
bindkey '^Y' yank

# Word movement (Alt/Option key combinations)
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[d' kill-word
bindkey '^[^H' backward-kill-word  # Alt+Backspace

# Terminal-specific bindings for better compatibility
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left
bindkey '^[[3~' delete-char         # Delete key
bindkey '^[[H' beginning-of-line    # Home key
bindkey '^[[F' end-of-line          # End key

# macOS Terminal.app specific
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    bindkey '^[[3~' delete-char
    bindkey '^[^[[C' forward-word
    bindkey '^[^[[D' backward-word
fi

# iTerm2 specific
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    bindkey '^[[1;9C' forward-word   # Alt+Right
    bindkey '^[[1;9D' backward-word  # Alt+Left
fi

# Custom widget functions
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line     # Ctrl+X Ctrl+E to edit command in $EDITOR

# Quote current line or selection
autoload -Uz quote-line
zle -N quote-line
bindkey '^[q' quote-line             # Alt+Q

# URL quote/unquote
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Directory stack navigation
bindkey '^[u' undo                  # Alt+U for undo
bindkey '^[r' redo                  # Alt+R for redo

# Custom widgets
# Insert sudo at beginning of line
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey '^[s' sudo-command-line      # Alt+S to add/remove sudo

# Insert last argument from previous command
bindkey '^[.' insert-last-word       # Alt+. (like bash)

# Clear screen but keep current line
clear-screen-keep-line() {
    local saved_buffer="$BUFFER"
    local saved_cursor="$CURSOR"
    clear
    BUFFER="$saved_buffer"
    CURSOR="$saved_cursor"
    zle redisplay
}
zle -N clear-screen-keep-line
bindkey '^L' clear-screen-keep-line  # Ctrl+L

# Quick cd to parent directory
cd-parent() {
    BUFFER="cd .."
    zle accept-line
}
zle -N cd-parent
bindkey '^[^[[A' cd-parent           # Alt+Up

# Quick ls after cd
cd-ls() {
    BUFFER="cd $BUFFER && ls"
    zle accept-line
}
zle -N cd-ls
bindkey '^[l' cd-ls                  # Alt+L

# Git status shortcut
git-status() {
    BUFFER="git status"
    zle accept-line
}
zle -N git-status
bindkey '^G^S' git-status            # Ctrl+G Ctrl+S

# Git add shortcut
git-add() {
    BUFFER="git add ."
    zle accept-line
}
zle -N git-add
bindkey '^G^A' git-add               # Ctrl+G Ctrl+A

# Quick commit
git-commit() {
    BUFFER="git commit -m \"\""
    CURSOR=$((CURSOR - 1))
    zle redisplay
}
zle -N git-commit
bindkey '^G^C' git-commit            # Ctrl+G Ctrl+C

# Docker PS shortcut
docker-ps() {
    BUFFER="docker ps"
    zle accept-line
}
zle -N docker-ps
bindkey '^D^P' docker-ps             # Ctrl+D Ctrl+P

# Kubectl get pods
kubectl-pods() {
    BUFFER="kubectl get pods"
    zle accept-line
}
zle -N kubectl-pods
bindkey '^K^P' kubectl-pods          # Ctrl+K Ctrl+P

# Search and replace in command line
search-replace() {
    local search replace
    echo -n "Search for: "
    read search
    echo -n "Replace with: "
    read replace
    BUFFER="${BUFFER//$search/$replace}"
    zle redisplay
}
zle -N search-replace
bindkey '^[%' search-replace         # Alt+%

# Toggle between command and its output
toggle-command-output() {
    if [[ $BUFFER =~ ^(.*)\s*\|\s*less\s*$ ]]; then
        BUFFER="$match[1]"
    else
        BUFFER="$BUFFER | less"
    fi
    zle redisplay
}
zle -N toggle-command-output
bindkey '^[p' toggle-command-output  # Alt+P

# Quick file operations
quick-mkdir() {
    echo -n "Directory name: "
    read dirname
    if [[ -n "$dirname" ]]; then
        BUFFER="mkdir -p \"$dirname\" && cd \"$dirname\""
        zle accept-line
    fi
}
zle -N quick-mkdir
bindkey '^[m' quick-mkdir            # Alt+M

# Quick find files
quick-find() {
    echo -n "Find: "
    read pattern
    if [[ -n "$pattern" ]]; then
        BUFFER="find . -name '*$pattern*'"
        zle accept-line
    fi
}
zle -N quick-find
bindkey '^[f' quick-find             # Alt+F

# Browse directory with fzf (if available)
if command -v fzf >/dev/null; then
    fzf-cd() {
        local dir
        dir=$(find . -type d 2>/dev/null | fzf +m) && cd "$dir"
        zle redisplay
    }
    zle -N fzf-cd
    bindkey '^T' fzf-cd              # Ctrl+T
    
    # FZF file selection
    fzf-file() {
        local file
        file=$(find . -type f 2>/dev/null | fzf +m)
        if [[ -n "$file" ]]; then
            LBUFFER="${LBUFFER}${file}"
            zle redisplay
        fi
    }
    zle -N fzf-file
    bindkey '^[t' fzf-file           # Alt+T
fi

# Copy current command to clipboard (macOS)
if [[ "$OSTYPE" == darwin* ]]; then
    copy-command() {
        echo -n "$BUFFER" | pbcopy
        echo "Command copied to clipboard"
    }
    zle -N copy-command
    bindkey '^[c' copy-command       # Alt+C
    
    # Paste from clipboard
    paste-clipboard() {
        LBUFFER="${LBUFFER}$(pbpaste)"
        zle redisplay
    }
    zle -N paste-clipboard
    bindkey '^[v' paste-clipboard    # Alt+V
fi

# Linux clipboard operations (requires xclip or xsel)
if [[ "$OSTYPE" == linux* ]]; then
    if command -v xclip >/dev/null; then
        copy-command() {
            echo -n "$BUFFER" | xclip -selection clipboard
            echo "Command copied to clipboard"
        }
        zle -N copy-command
        bindkey '^[c' copy-command   # Alt+C
        
        paste-clipboard() {
            LBUFFER="${LBUFFER}$(xclip -selection clipboard -o)"
            zle redisplay
        }
        zle -N paste-clipboard
        bindkey '^[v' paste-clipboard # Alt+V
    elif command -v xsel >/dev/null; then
        copy-command() {
            echo -n "$BUFFER" | xsel --clipboard --input
            echo "Command copied to clipboard"
        }
        zle -N copy-command
        bindkey '^[c' copy-command   # Alt+C
        
        paste-clipboard() {
            LBUFFER="${LBUFFER}$(xsel --clipboard --output)"
            zle redisplay
        }
        zle -N paste-clipboard
        bindkey '^[v' paste-clipboard # Alt+V
    fi
fi

# Custom text objects (vi-mode specific)
# These will work when zsh-vi-mode plugin is loaded
bindkey -M vicmd 'ca' change-around
bindkey -M vicmd 'ci' change-in
bindkey -M vicmd 'da' delete-around
bindkey -M vicmd 'di' delete-in

# Quick escape from vi insert mode (if using vi mode)
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode

# Better history navigation in vi mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Custom completion key bindings
bindkey '^I' complete-word           # Tab
bindkey '^[[Z' reverse-menu-complete # Shift+Tab

# Menu selection bindings (only if menuselect is available)
if zle -l menu-select; then
    bindkey -M menuselect '^M' accept-line
    bindkey -M menuselect '^[[Z' reverse-menu-complete
    bindkey -M menuselect '^[[D' backward-char
    bindkey -M menuselect '^[[C' forward-char
    bindkey -M menuselect '^[[A' up-line-or-history
    bindkey -M menuselect '^[[B' down-line-or-history
fi

# Help system
bindkey '^[h' run-help               # Alt+H for help on current command

# Quick calculations (requires bc)
if command -v bc >/dev/null; then
    quick-calc() {
        echo -n "Calculate: "
        read expression
        if [[ -n "$expression" ]]; then
            result=$(echo "$expression" | bc -l)
            LBUFFER="${LBUFFER}$result"
            zle redisplay
        fi
    }
    zle -N quick-calc
    bindkey '^[=' quick-calc         # Alt+=
fi

# Display current key bindings (helpful for debugging)
show-keybindings() {
    bindkey | less
}
zle -N show-keybindings
bindkey '^[?' show-keybindings       # Alt+? to show all bindings